//
//  MAVTimelineViewController.swift
//  MAVTimeline
//
//  Created by Mavericks's iOS Dev on 06-03-20.
//  Copyright © 2020 Mavericks. All rights reserved.
//

import UIKit

public class MAVTimelineViewController: UIViewController {

    //MARK: - Properties
    //Collection view
    /// That contains the items
    public lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        self.dateControls = MAVTimelineDateControls(frame: CGRect(x: 0, y: 0, width: 250.0, height: 100.0), level: self.level, currentDate: self.currentDate ?? Date())
        self.dateControls?.translatesAutoresizingMaskIntoConstraints = false
        self.dateControls?.delegate = self
        self.view.addSubview(self.dateControls ?? UIView())
        self.view.addSubview(collectionView)
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|-[collection]-|", options: [], metrics: nil, views: ["collection" : collectionView]))
        self.view.addConstraint(NSLayoutConstraint(item: self.dateControls ?? UIView(), attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1.0, constant: 1.0))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(5)-[controls]-(5)-[collection]-|", options: [], metrics: nil, views: ["collection" : collectionView]))
        return collectionView
    }()
    
    //Current Date
    ///Controller's current date
    public var currentDate: Date? = nil{
        didSet{
            self.loadData()
        }
    }
    
    //Level
    /// Can be year or month (to start)
    open var level: MAVTimelineLevel = .year{
        didSet{
            self.loadData()
        }
    }
    
    //Events
    /// Number of events
    open var events: [MAVTimelineUnit] = []{
        didSet{
            self.collectionView.reloadData()
        }
    }
    
    //Date Controls
    /// Controls to switch year or month
    fileprivate var dateControls: MAVTimelineDateControls? = nil
    
    //MARK: - Init
    convenience init(date: Date, level: MAVTimelineLevel){
        self.init()
        self.currentDate = date
        self.level = level
        self.loadData()
    }
    
    //MARK: - On load
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = MAVTimelineConfiguration.shared.timelineBackgroundColor
        // Do any additional setup after loading the view.
    }
    
    //MARK: - Load data
    /// Logic to fill data
    func loadData(){
        self.events = []
        let calendar = Calendar.current
        if(level == .year){
            for i in 0..<12{
                var dateComponents = calendar.dateComponents([.day,.month,.year], from: self.currentDate ?? Date())
                dateComponents.month = i
                let candidateDate = dateComponents.date ?? Date()
                let start = candidateDate.beginMonth()
                let end = candidateDate.endMonth()
                let title = start.monthStr()
                let event = MAVTimelineUnit(title: title, start: start, end: end)
                self.events.append(event)
            }
        }else{
            let days = self.currentDate?.numberOfDays() ?? 30
            for i in 0..<days{
               var dateComponents = calendar.dateComponents([.day,.month,.year], from: self.currentDate ?? Date())
                dateComponents.day = i
                let candidateDate = dateComponents.date ?? Date()
                let start = candidateDate.beginDay()
                let end = candidateDate.endDay()
                let title = i < 10 ? "0\(i)" : "\(i)"
                let event = MAVTimelineUnit(title: title, start: start, end: end)
                self.events.append(event)
            }
        }
    }

}

//MARK: - Collection view Delegate and Data Source
extension MAVTimelineViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.events.count
    }
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "timelineIdentifier", for: indexPath) as? MAVTimelineCell{
            cell.event = self.events[indexPath.row]
            cell.index = indexPath.row
            return cell
        }
        return UICollectionViewCell()
    }
    
}

//MARK: - Date Controls Delegate
extension MAVTimelineViewController: MAVTimelineDateControlsDelegate{
    public func didBackToDate(date: Date) {
        self.currentDate = date
    }
    
    public func didForwardToDate(date: Date) {
        self.currentDate = date
    }
    
    public func backToMode(mode: MAVTimelineLevel) {
        self.level = mode
    }
}

extension Date{
    
    func numberOfDays()->Int{
        let calendar = Calendar.current
        if let range = calendar.range(of: .day, in: .month, for: self){
            let numDays = range.count
            print(numDays) // 31
            return numDays
        }
        return 30
    }
    
    func beginMonth()->Date{
        let calendar = Calendar.current
        var dateComponents = calendar.dateComponents([.day,.month,.year,.hour,.minute,.second], from: self)
        dateComponents.day = 1
        dateComponents.hour = 0
        dateComponents.minute = 0
        dateComponents.second = 0
        return dateComponents.date ?? Date()
    }
    
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
    
    func beginDay()->Date{
        let calendar = Calendar.current
        var dateComponents = calendar.dateComponents([.day,.month,.year,.hour,.minute,.second], from: self)
        dateComponents.hour = 0
        dateComponents.minute = 0
        dateComponents.second = 0
        return dateComponents.date ?? Date()
    }
    
    func endDay()->Date{
        let calendar = Calendar.current
        var dateComponents = calendar.dateComponents([.day,.month,.year,.hour,.minute,.second], from: self)
        dateComponents.hour = 23
        dateComponents.minute = 59
        dateComponents.second = 59
        return dateComponents.date ?? Date()
    }
    
    func monthStr()->String{
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "MMM"
        return dateFormatter.string(from: self)
    }
    
}
