//
//  MAVTimelineDataSource.swift
//  MAVTimeline
//
//  Created by Mavericks's iOS Dev on 04-03-20.
//  Copyright © 2020 Mavericks. All rights reserved.
//

import Foundation

protocol MAVTimeLineDataSource {
    func hasEvent(on Date: Date) -> Bool
}


protocol MAVTimeLineDelegate: class {
    func didChangeDate(date: Date, level: MAVTimelineLevel)
    func didSelectEvent(at date: Date)
}
