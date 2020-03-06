//
//  MAVTimelineCell.swift
//  MAVTimeline
//
//  Created by Mavericks's iOS Dev on 06-03-20.
//  Copyright © 2020 Mavericks. All rights reserved.
//

import UIKit

class MAVTimelineCell: UICollectionViewCell {

    //MARK: - IBOutlets
    @IBOutlet weak var circleLabel: UIView!
    @IBOutlet weak var eventLabel: UILabel!
    @IBOutlet weak var rightSeparator: UIView!
    @IBOutlet weak var leftSeparator: UIView!
    
    var index: Int = 0{
        didSet{
            self.leftSeparator.isHidden = index != 0
        }
    }
    var level: MAVTimelineLevel = .month
    weak var event: MAVTimelineEvent? = nil{
        didSet{
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale.current
            dateFormatter.timeZone = TimeZone.current
            if(level == .month){
                dateFormatter.dateFormat = "dd"
            }else{
                dateFormatter.dateFormat = "MMM"
            }
            self.eventLabel.text = dateFormatter.string(from: event?.date ?? Date())
        }
    }

}
