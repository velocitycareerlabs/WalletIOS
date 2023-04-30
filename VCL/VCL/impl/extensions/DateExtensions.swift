//
//  DateExtensions.swift
//
//
//  Created by Michael Avoyan on 26/04/2021.
//
// Copyright 2022 Velocity Career Labs inc.
// SPDX-License-Identifier: Apache-2.0

import Foundation

extension Date {
    func addDaysToNow(days: Int) -> Date {
        if let futureDate = Calendar.current.date(byAdding: .day, value: days, to: self) {
            return futureDate
        } else {
            return Date()
        }
    }
    
    private func get(_ components: Calendar.Component..., calendar: Calendar = Calendar.current) -> DateComponents {
        return calendar.dateComponents(Set(components), from: self)
    }

    private func get(_ component: Calendar.Component, calendar: Calendar = Calendar.current) -> Int {
        return calendar.component(component, from: self)
    }

    func getDurationFromNow() -> String {
        let components = Date().get(.day, .month, .year, .hour, .minute, .second)
        if let year: Int = components.year, let month: Int = components.month, let day: Int = components.day, let hour: Int = components.hour, let minute: Int = components.minute, let second: Int = components.second {
            return "P\(year)Y\(month)M\(day)DT\(hour)H\(minute)M\(second)S"
        }
        return ""
    }
    
    func toDouble() -> Double {
        return Double(self.timeIntervalSince1970)
    }
    
    func toInt() -> Int {
        return Int(self.timeIntervalSince1970)
    }
    
    func toString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ" // ISO 8601 format
        return dateFormatter.string(from: self)
    }
}

func - (lhs: Date, rhs: Date) -> TimeInterval {
    return (lhs.timeIntervalSinceReferenceDate - rhs.timeIntervalSinceReferenceDate)
}

func + (lhs: Date, rhs: Date) -> TimeInterval {
    return (lhs.timeIntervalSinceReferenceDate + rhs.timeIntervalSinceReferenceDate)
}
