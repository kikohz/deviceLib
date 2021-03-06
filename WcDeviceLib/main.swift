//
//  main.swift
//  WcDeviceLib
//
//  Created by wangxi on 2022/3/31.
//

import Foundation
import Logging

let logger = Logger(label: "com.wcdevice.lib.main")


let script = CommandLine.arguments
print(script)

let idevice = IOSDevics()
let udidList = idevice.deviceInfoList()
logger.info("\(udidList)")

let dbM = DeviceDBManage()
dbM.createDb()
//dbM.addDevice(deviceModel: udidList.first!)
dbM.devices()
//let info = ProcessInfo.processInfo
//print("Process info")
//print("Process identifier:", info.processIdentifier)
//print("System uptime:", info.systemUptime)
//print("Globally unique process id string:", info.globallyUniqueString)
//print("Process name:", info.processName)
//
//print("Software info")
//print("Host name:", info.hostName)
//print("OS major version:", info.operatingSystemVersion.majorVersion)
//print("OS version string", info.operatingSystemVersionString)
//
//print("Hardware info")
//print("Active processor count:", info.activeProcessorCount)
//print("Physical memory (bytes)", info.physicalMemory)
//
///// same as CommandLine.arguments
//print("Arguments")
//print(ProcessInfo.processInfo.arguments)
//
//print("Environment")
///// print available environment variables
//print(info.environment)
//
