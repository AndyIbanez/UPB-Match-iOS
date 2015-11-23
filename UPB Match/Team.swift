//
//  Team.swift
//  UPB Match
//
//  Created by Andy Ibanez on 11/23/15.
//  Copyright © 2015 Fairese. All rights reserved.
//

import Foundation

/// Represents a team.
public class Team {
    /// Team color.
    var color: String
    
    /// Team name.
    var name: String
    
    /// Score.
    var score: Int
    
    /// Team ID.
    let ID: String
    
    /// Creates a new team.
    ///
    /// - parameter name: Team name.
    /// - parameter color: Team color.
    /// - parameter points: Team points.
    /// - parameter id: Team ID.
    init(name: String, color: String, points: Int, id: String) {
        self.name = name
        self.color = color
        self.score = points
        self.ID = id
    }
    
    /// Creates a new team with a Parse object.
    ///
    /// - parameter team: `PFObject` to create the team with.
    init?(team: PFObject) {
        do {
            self.name = try team.fetchIfNeeded()["Nombre_Equipo"] as! String
            self.color = try team.fetchIfNeeded()["Colot"] as! String
            self.score = Int(try team.fetchIfNeeded()["Nombre_Equipo"] as! String)!
            self.ID = try team.fetchIfNeeded().objectId!
        } catch _ {
            self.name = ""
            self.color = ""
            self.ID = ""
            self.score = 0
            return nil
        }
        
    }
}