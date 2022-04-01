//
//  WCDeviceDB.swift
//  WcDeviceLib
//
//  Created by wangxi on 2022/3/31.
//

import Foundation
import SQLite
import Logging

let dbPath = "device.db"

struct DeviceDBManage {
    
    func createDb(){
        do {
            let db = try Connection(dbPath)
            let devices = Table("devices")
            let id = Expression<Int64>("id")
            let udid = Expression<String?>("udid")
            let name = Expression<String?>("name")
            let phoneNumber = Expression<String?>("phoneNumber")
            let osver = Expression<String?>("osver")
            
            try db.run(devices.create { t in
                t.column(id,primaryKey: true)
                t.column(udid,unique: true)
                t.column(name)
                t.column(phoneNumber)
                t.column(osver)
            })
            logger.info("数据库创建成功")
        }
        catch {
            logger.info("创建数据库失败")
        }
    }
    
    func addDevice(deviceModel:DeviceModel) {
        do{
            let db = try Connection(dbPath)
            let devices = Table("devices")
            let udid = Expression<String?>("udid")
            let name = Expression<String?>("name")
            let phoneNumber = Expression<String?>("phoneNumber")
            let osver = Expression<String?>("osver")
            let insert = devices.insert(udid <- deviceModel.udid, name <- deviceModel.name,phoneNumber <- deviceModel.phoneNumber, osver <- deviceModel.osVer)
            try db.run(insert)
            logger.info("数据库写入成功")
        }
        catch {
            logger.info("写入数据库失败")
        }
    }
    
    func deviceWith(udidStr:String) ->DeviceModel?{
        do{
            let db = try Connection(dbPath)
            let devices = Table("devices")
            let query = devices.filter(Expression<String?>("udid") == udidStr)
            let deviceItem = try db.prepare(query)
            for row in deviceItem {
                let name = try row.get(Expression<String>("name"))
                let phoneNumber = try row.get(Expression<String>("phoneNumber"))
                let osver = try row.get(Expression<String>("osver"))
                logger.info("读取数据成功")
                return DeviceModel(udid: udidStr, osVer: osver, name: name, phoneNumber: phoneNumber)
            }
        }
        catch {
            logger.info("读取数据库失败")
        }
        return nil
    }
    
    func devices() ->[DeviceModel]? {
        do{
            let db = try Connection(dbPath)
            let devices = Table("devices")
            let allItem = try db.prepare(devices)
            var models = [DeviceModel]()
            for row in allItem {
                let name = try row.get(Expression<String>("name"))
                let phoneNumber = try row.get(Expression<String>("phoneNumber"))
                let osver = try row.get(Expression<String>("osver"))
                let udid = try row.get(Expression<String>("udid"))
                let dmodel = DeviceModel(udid: udid, osVer: osver, name: name, phoneNumber: phoneNumber)
                models.append(dmodel)
            }
            print(models)
            return models
        }
        catch {
            logger.info("读取数据库失败")
            return nil
        }
    }
    
}
