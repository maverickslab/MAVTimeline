//
//  MAVTimelineUnit.swift
//  MAVTimeline
//
//  Created by Mavericks's iOS Dev on 04-03-20.
//  Copyright © 2020 Mavericks. All rights reserved.
//

import Foundation

public class MAVTimelineUnit {
    
    //MARK: - Properties
    ///Title: Label to show
    public var title: String
    
    /// start date
    public var start: Date
    
    /// end date
    public var end: Date
    
    //MARK: - Init
    public init(title: String, start: Date, end: Date){
        self.title = title
        self.start = start
        self.end = end
    }
    
    
}
