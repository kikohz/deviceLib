//
//  WCIDevice.swift
//  WcDeviceLib
//
//  Created by wangxi on 2022/3/31.
//

/*
 获取电脑连接iOS设备信息
 管理设备等操作
 命令参照   https://libimobiledevice.org/
 */

import Foundation
import SwiftShell
import Logging


//let device_list = "idevice_id --list"            //获取正在连接的手机udid
//let device_info = "ideviceinfo -u "              //通过udid获取手机完整信息
let device_list_path = "/opt/homebrew/bin/idevice_id"
let device_info_path = "/opt/homebrew/bin/ideviceinfo"

extension Array {
    func wc_toDist(_ f:(Element)->String) -> Dictionary<String,[Element]> {
        var dict = Dictionary<String, [Element]>()
        for item in self {
            if dict[f(item)] == nil {
                dict[f(item)] = [item]
            }
            else {
                dict[f(item)]!.append(item)
            }
        }
        return dict
    }
}


struct DeviceModel {
    var udid:String = ""
    var osVer = ""
    var name = ""
    var phoneNumber = ""
}

class IOSDevics {
    //设备列表
    var devices = [DeviceModel]()
    
    //获取连接的手机udid
    func devicesUdid() ->[String] {
        //获取目录
        let dList = run(device_list_path,"--list")
        if (dList.error != nil) {
            logger.error("获取设备信息失败，请检查连接")
            return []
        }
        else {
            var devices = dList.stdout.components(separatedBy: "\n")
            if devices.count > 1 {
                devices.removeLast()
            }
            logger.info("获取设备信息成功")
            return devices
            
        }
    }
    fileprivate func deviceInfo(udid:String) ->DeviceModel? {
        let deviceInfoOut = run(device_info_path,"-u",udid)
        if(deviceInfoOut.error != nil) {
            logger.error("设备信息获取失败")
            return nil
        }
        else {
            let deviceInfo = deviceInfoOut.stdout
            var deviceInfos = deviceInfo.components(separatedBy: "\n")
            if deviceInfos.count > 1 {
                deviceInfos.removeLast()
            }
            var deviceDict = [String:Any]()
            for  item in deviceInfos {
                let itemArr =  item.components(separatedBy: ":")
                deviceDict[String(itemArr[0])] = itemArr[1]
            }
            guard !deviceDict.isEmpty else {
                return nil
            }
            var deviceModel = DeviceModel()
            deviceModel.udid = udid//deviceDict["UniqueDeviceID"] as! String
            if let phoneNumber = deviceDict["PhoneNumber"] {
                deviceModel.phoneNumber = phoneNumber as! String
            }
            deviceModel.osVer = deviceDict["ProductVersion"] as! String
            deviceModel.name = deviceDict["DeviceName"] as! String
            return deviceModel
        }
    }
    
    func deviceInfoList() -> [DeviceModel] {
        var dModels = [DeviceModel]()
        let connetDevices = self.devicesUdid()
        for udid in connetDevices {
            if let dModel = self.deviceInfo(udid: udid){
                dModels.append(dModel)
            }
        }
        return dModels
    }
    //获取在线的列表
//    func deviceList() ->[DeviceModel] {
//
//    }
    
    
    
}

