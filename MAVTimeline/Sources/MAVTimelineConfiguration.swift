//
//  MAVTimelineConfiguration.swift
//  MAVTimeline
//
//  Created by Mavericks's iOS Dev on 06-03-20.
//  Copyright © 2020 Mavericks. All rights reserved.
//

import Foundation
import UIKit

public class MAVTimelineConfiguration {
    
    //MARK: - Timeline Background Color
    ///Background card color from timeline
    public var timelineBackgroundColor: UIColor = UIColor.lightGray
    
    //MARK: - Separator Color
    /// Separator color
    public var separatorColor: UIColor = UIColor.lightGray
    
    //MARK: - Date label color
    /// Date label color e.x Month or day
    public var dateLabelColor: UIColor = UIColor.white
    
    //MARK: - Singleton
    static public let shared: MAVTimelineConfiguration = MAVTimelineConfiguration()
    private init(){}
}
