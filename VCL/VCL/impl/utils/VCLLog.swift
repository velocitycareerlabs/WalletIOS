//
//  VCLLog.swift
//  VCL
//
//  Created by Michael Avoyan on 16/03/2021.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation

struct VCLLog {
    
    enum LogLevel: String {
        case error = "⛔️"
        case warning = "⚠️"
        case debug = "💬"
    }
    static func d(_ infoData: Data?, level: LogLevel = .debug, file: String = #file, function: String = #function, line: Int = #line) {
        if GlobalConfig.IsLoggerOn {
            let info = String(data: infoData ?? Data(bytes: [] as [UInt8], count: 0), encoding: .utf8) ?? ""
            print("\(level.rawValue), \((file as NSString).lastPathComponent), \(line), \(function), \(GlobalConfig.LogTagPrefix + info)")
        }
    }
    static func d(_ info: String, level: LogLevel = .debug, file: String = #file, function: String = #function, line: Int = #line) {
        if GlobalConfig.IsLoggerOn {
            print("\(level.rawValue), \((file as NSString).lastPathComponent), \(line), \(function), \(GlobalConfig.LogTagPrefix + info)")
        }
    }
    
    static func w(_ warning: String, level: LogLevel = .warning, file: String = #file, function: String = #function, line: Int = #line) {
        if GlobalConfig.IsLoggerOn {
            print("\(level.rawValue), \((file as NSString).lastPathComponent), \(line), \(function), \(GlobalConfig.LogTagPrefix + warning)")
        }
    }
    
    static func e(_ error: Error, level: LogLevel = .error, file: String = #file, function: String = #function, line: Int = #line) {
        // always log errors
        VCLLog.e("\(error)", level: level, file: file, function: function, line: line)
    }
    
    static func e(_ error: String, level: LogLevel = .error, file: String = #file, function: String = #function, line: Int = #line) {
        // always log errors
        print("\(level.rawValue), \((file as NSString).lastPathComponent), \(line), \(function), \(GlobalConfig.LogTagPrefix + error)")
    }
}
