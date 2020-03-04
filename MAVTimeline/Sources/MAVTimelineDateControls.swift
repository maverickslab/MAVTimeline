//
//  MAVTimelineDateControls.swift
//  MAVTimeline
//
//  Created by Mavericks's iOS Dev on 04-03-20.
//  Copyright © 2020 Mavericks. All rights reserved.
//

import UIKit

//Controls delegate
public protocol MAVTimelineDateControlsDelegate: class{
    //Back
    func didBackToDate(date: Date)
    //Forward
    func didForwardToDate(date: Date)
    //Back to year
    func backToMode(mode: MAVTimelineLevel)
}

public class MAVTimelineDateControls: UIView {

    //MARK: - Properties
    
    //Color for text and icon colors
    open var color: UIColor = .white
    
    //Font for labels
    open var labelFont: UIFont = UIFont.systemFont(ofSize: 20.0)
    
    //Current label
    private var date: Date? = nil
    
    //Delegate
    public weak var delegate: MAVTimelineDateControlsDelegate? = nil
    
    //Init
    public init(frame: CGRect,level: MAVTimelineLevel, currentDate: Date) {
        super.init(frame: frame)
        for i in self.subviews{
            i.removeFromSuperview()
        }
        if(level == .month){
            self.setupMonth(currentDate: currentDate)
        }else{
            self.setupYear(currentDate: currentDate)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - Year setup
    func setupYear(currentDate: Date){
        
        //First I need to put the current date
        self.date = currentDate
        
        //Back Button settings
        let backButton = UIButton()
        backButton.tintColor = self.color
        backButton.setImage(self.bundledImage(named: "back"), for: .normal)
        backButton.addTarget(self, action: #selector(back), for: .touchUpInside)
        
        //Label Settings
        let label = UILabel()
        label.font = self.labelFont
        label.textColor = self.color
        
        //I need to put the currently year
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyy"
        dateformatter.locale = Locale.current
        label.text = dateformatter.string(from: currentDate)
        
        //Forward button settings
        let forwardButton = UIButton()
        forwardButton.tintColor = self.color
        forwardButton.setImage(self.bundledImage(named: "forward"), for: .normal)
        forwardButton.addTarget(self, action: #selector(forward), for: .touchUpInside)
        
        //Get today date
        let today = Date()
        
        //Get the calendar
        let calendar = Calendar.current
        
        //Get the today date components and the currently date components
        let todayComponents = calendar.dateComponents([.year], from: today)
        let dateComponents = calendar.dateComponents([.year], from: currentDate)
        
        //Get the years
        let todayYear = todayComponents.year ?? 2020
        let dateYear = dateComponents.year ?? 2020
        
        //If I'm in the current year disable forward's year
        if(todayYear == dateYear){
            forwardButton.isEnabled = false
        }
        
        //Prepare stack view
        let stackView = UIStackView(arrangedSubviews: [backButton,label,forwardButton])
        stackView.alignment = .fill
        stackView.axis = .horizontal
        stackView.spacing = 8.0
        
        //Add subview
        self.addSubview(stackView)
        
    }
    
    //MARK: - Setup month
    func setupMonth(currentDate: Date){
        
        //First, I'll setup the date formatter as year label
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "yyyy"
        
        //Button setup
        let button = UIButton()
        button.setTitleColor(self.color, for: .normal)
        button.titleLabel?.font = self.labelFont
        button.setTitle(dateFormatter.string(from: currentDate), for: .normal)
        button.addTarget(self, action: #selector(backToYear), for: .touchUpInside)
        
        //Change date formatter to month label
        dateFormatter.dateFormat = "MMMM"
        
        //Month label setup
        let monthLabel = UILabel()
        monthLabel.font = UIFont(name: self.labelFont.fontName, size: self.labelFont.pointSize + 5.0)
        monthLabel.textColor = self.color
        monthLabel.font = self.labelFont
        monthLabel.text = dateFormatter.string(from: currentDate)
        
        //Stack View
        let stackView = UIStackView(arrangedSubviews: [button,monthLabel])
        stackView.alignment = .fill
        stackView.axis = .vertical
        stackView.spacing = 8.0
        
        //Add subview
        self.addSubview(stackView)
        
    }
    
    //MARK: - Back To Year
    /// Back to year. The idea is to reload months from current year
    @objc func backToYear(){
        if let delegate = self.delegate{
            delegate.backToMode(mode: .year)
        }
    }
    
    //MARK: - Back
    /// Back to last year. The idea is to reload the months from last year
    @objc func back(){
        let newDate = self.setNewDate(forward: false)
        if let delegate = self.delegate{
            delegate.didBackToDate(date: newDate)
        }
    }
    
    //MARK: - Forward
    /// Forward to next year. The idea is to reload the months from next year.
    @objc func forward(){
        let newDate = self.setNewDate(forward: true)
        if let delegate = self.delegate{
            delegate.didForwardToDate(date: newDate)
        }
    }
    
    //MARK: - Set new date
    func setNewDate(forward: Bool)->Date{
        // Get the current calendar
        let calendar = Calendar.current
        
        //Get date components from the current date
        var dateComponents = calendar.dateComponents([.day,.month,.year,.hour,.minute,.second], from: self.date ?? Date())
        
        // Add or minus year if there's forward or not.
        let year = forward ? dateComponents.year ?? 2020 + 1 :  dateComponents.year ?? 2020 - 1
        dateComponents.year = year
        
        //Retrieve the new date
        let newDate = calendar.date(from: dateComponents) ?? Date()
        
        return newDate
    }
    
    //MARK: - Bundled Image
    func bundledImage(named: String) -> UIImage? {
        let image = UIImage(named: named)
        if image == nil {
            return UIImage(named: named, in: Bundle(for: MAVTimelineDateControls.classForCoder()), compatibleWith: nil)
        } // Replace MyBasePodClass with yours
        return image
    }

}
