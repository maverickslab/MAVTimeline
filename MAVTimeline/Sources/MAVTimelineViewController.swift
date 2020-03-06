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
        
        ///Collection View Declaration
        let collectionView = UICollectionView()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(MAVTimelineCell.self, forCellWithReuseIdentifier: "timelineIdentifier")
        
        /// Date Controls declaration
        self.dateControls = MAVTimelineDateControls(frame: CGRect(x: 0, y: 0, width: 250.0, height: 100.0), level: self.level, currentDate: self.currentDate ?? Date())
        self.dateControls?.translatesAutoresizingMaskIntoConstraints = false
        self.dateControls?.delegate = self
        
        ///Contraint's logic
        ///Add subviews
        self.view.addSubview(self.dateControls ?? UIView())
        self.view.addSubview(collectionView)
        
        ///Add constraints
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|-[collection]-|", options: [], metrics: nil, views: ["collection" : collectionView]))
        self.view.addConstraint(NSLayoutConstraint(item: self.dateControls ?? UIView(), attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1.0, constant: 1.0))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(5)-[controls]-(5)-[collection]-|", options: [], metrics: nil, views: ["collection" : collectionView]))
        
        ///Retrun collection view
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
    
    //Data Source
    /// Timeline's data source
    open weak var dataSource: MAVTimeLineDataSource? = nil
    
    //Delegate
    /// Timeline's data delegate
    open weak var delegate: MAVTimeLineDelegate? = nil
    
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
        
        ///Set empty array of events
        self.events = []
        
        ///Instantiate gregorian calendar
        let calendar = Calendar.current
        
        ///If the level is year. Fill twelve months from january to december
        if(level == .year){
            
            ///Bucle of twelve months
            for i in 0..<12{
                
                ///First I put current's date components
                var dateComponents = calendar.dateComponents([.day,.month,.year], from: self.currentDate ?? Date())
                
                ///Set month of that components
                dateComponents.month = i
                
                ///Get the date
                let candidateDate = dateComponents.date ?? Date()
                
                ///Fill the event
                let start = candidateDate.beginMonth()
                let end = candidateDate.endMonth()
                let title = start.monthStr()
                let event = MAVTimelineUnit(title: title, start: start, end: end)
                
                ///Push to the event array
                self.events.append(event)
            }
        }
            ///If the level is month. Fill the days of this month
        else{
            
            ///Retrieve the number of days (length)
            let days = self.currentDate?.numberOfDays() ?? 30
            
            ///Bucle of these days
            for i in 0..<days{
                
                ///Get the current date components
                var dateComponents = calendar.dateComponents([.day,.month,.year], from: self.currentDate ?? Date())
                
                ///Set the current day
                dateComponents.day = i
                
                ///Get the date
                let candidateDate = dateComponents.date ?? Date()
                
                ///Fill event
                let start = candidateDate.beginDay()
                let end = candidateDate.endDay()
                let title = i < 10 ? "0\(i)" : "\(i)"
                let event = MAVTimelineUnit(title: title, start: start, end: end)
                
                ///Push to event's array
                self.events.append(event)
            }
        }
    }

}

//MARK: - Collection view Delegate and Data Source
extension MAVTimelineViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    
    //MARK: - Number of events
    /// When you have events. The collection view receive that number of events
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.events.count
    }
    
    //MARK: - Sections
    /// For that ui, it's only necessary 1 section
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    //MARK: - Render cell
    /// Render Timeline identifier
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        ///Declare cell
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "timelineIdentifier", for: indexPath) as? MAVTimelineCell{
            ///Set event
            cell.event = self.events[indexPath.row]
            
            ///Set index
            cell.index = indexPath.row
            
            ///declare event
            let event = self.events[indexPath.row]
            
            /// If there's event beetween dates you must show the circle
            if let dataSource = self.dataSource{
                if(dataSource.hasEvent(beetween: event.start, and: event.end)){
                    cell.circleLabel.isHidden = false
                }else{
                    cell.circleLabel.isHidden = false
                }
            }
            
            return cell
        }
        return UICollectionViewCell()
    }
    
}

//MARK: - Date Controls Delegate
extension MAVTimelineViewController: MAVTimelineDateControlsDelegate{
    
    //MARK: - Did Back to date
    ///If there's back to last month or last year (maybe in that case is only year)
    public func didBackToDate(date: Date) {
        self.currentDate = date
    }
    
    //MARK: - Did forward to date
    ///Forward to next year
    public func didForwardToDate(date: Date) {
        self.currentDate = date
    }
    
    //MARK: - Back To Mode
    /// Back to month
    public func backToMode(mode: MAVTimelineLevel) {
        self.level = mode
    }
}
