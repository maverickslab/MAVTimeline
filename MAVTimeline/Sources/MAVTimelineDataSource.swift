//
//  MAVTimelineDataSource.swift
//  MAVTimeline
//
//  Created by Mavericks's iOS Dev on 04-03-20.
//  Copyright © 2020 Mavericks. All rights reserved.
//

import Foundation

public protocol MAVTimeLineDataSource: class {
    func hasEvent(beetween date: Date, and date: Date) -> Bool
}


public protocol MAVTimeLineDelegate: class {
    func didSelectEvent(at date: Date)
}
