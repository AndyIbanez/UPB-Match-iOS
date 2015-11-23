//
//  Event.swift
//  UPB Match
//
//  Created by Andy Ibanez on 11/23/15.
//  Copyright © 2015 Fairese. All rights reserved.
//

import Foundation

/// Represents a single event.
public class Event {
    /// Event ID.
    let ID: String
    
    /// Event name.
    let name: String
    
    /// Event day.
    let day: Int
    
    /// Event hour.
    let hour: String
    
    /// Event Date.
    let date: NSDate
    
    /// Event description.
    let description: String
    
    /// Creates a new Event.
    ///
    /// - parameter id: Event ID.
    /// - parameter name: Event name.
    /// - parameter day: Event day.
    /// - parameter hour: Event hour.
    /// - parameter date: Event date.
    /// - parameter description: Event discription.
    init(id: String, name: String, day: Int, hour: String, date: NSDate, description: String) {
        self.ID = id
        self.name = name
        self.day = day
        self.hour = hour
        self.date = date
        self.description = description
    }
}