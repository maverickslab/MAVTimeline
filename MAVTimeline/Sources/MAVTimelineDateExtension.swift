//
//  MAVTimelineDateExtension.swift
//  MAVTimeline
//
//  Created by Mavericks's iOS Dev on 06-03-20.
//  Copyright © 2020 Mavericks. All rights reserved.
//

import Foundation

extension Date{
    
    //MARK: - Retrieve number of days
    /// Number of days of a month
    func numberOfDays()->Int{
        let calendar = Calendar.current
        if let range = calendar.range(of: .day, in: .month, for: self){
            let numDays = range.count
            print(numDays) // 31
            return numDays
        }
        return 30
    }
    
    //MARK: - Get begin of month
    /// Get the first day of a month
    func beginMonth()->Date{
        let calendar = Calendar.current
        var dateComponents = calendar.dateComponents([.day,.month,.year,.hour,.minute,.second], from: self)
        dateComponents.day = 1
        dateComponents.hour = 0
        dateComponents.minute = 0
        dateComponents.second = 0
        return dateComponents.date ?? Date()
    }
    
    //MARK: - Get end of the month
    /// Get the last day of the month
    func endMonth()->Date{
        let calendar = Calendar.current
        var dateComponents = calendar.dateComponents([.day,.month,.year,.hour,.minute,.second], from: self)
        dateComponents.day = -1
        dateComponents.month = dateComponents.month ?? 11 - 1
        dateComponents.hour = 0
        dateComponents.minute = 0
        dateComponents.second = 0
        return dateComponents.date ?? Date()
    }
    
    //MARK: - Get begin of the day
    /// Get the begin hour of the day (UTC - 3) 00:00:00
    func beginDay()->Date{
        let calendar = Calendar.current
        var dateComponents = calendar.dateComponents([.day,.month,.year,.hour,.minute,.second], from: self)
        dateComponents.hour = 0
        dateComponents.minute = 0
        dateComponents.second = 0
        return dateComponents.date ?? Date()
    }
    
    //MARK: - Get end of the day
    /// Get the end of the day (UTC - 3) 23:59:59
    func endDay()->Date{
        let calendar = Calendar.current
        var dateComponents = calendar.dateComponents([.day,.month,.year,.hour,.minute,.second], from: self)
        dateComponents.hour = 23
        dateComponents.minute = 59
        dateComponents.second = 59
        return dateComponents.date ?? Date()
    }
    
    //MARK: - Month String
    /// Get month string with format MMM
    func monthStr()->String{
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "MMM"
        return dateFormatter.string(from: self)
    }
    
}
