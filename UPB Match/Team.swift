//
//  Team.swift
//  UPB Match
//
//  Created by Andy Ibanez on 11/23/15.
//  Copyright © 2015 Fairese. All rights reserved.
//

import Foundation

/// A closure that gets called when an operation fetching content finishes successfully.
///
/// - paramater participants: An array of teams..
typealias SuccessTeamsClosure = (participants: [Team]) -> Void

/// A closure called when a Teams fetch fails.
typealias FailureTeamsFetchClosure = (error: String, objects: [Team]?) -> Void

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
    
    /// Fetches all teams from Parse. Teams are sorted by highest score to lowest.
    ///
    /// In the Android version, this logic was implemented in a different class called TeamsManager. For practical reasons we will use this class for that same purpose.
    /// - parameter success: A closure that gets called when the operation succeeds.
    /// - parameter failure: A closure that gets called when the operation fails.
    func fetchTeams(success success: SuccessTeamsClosure, failure: FailureTeamsFetchClosure) {
        let query = PFQuery(className: "Equipos")
        query.orderByDescending("Puntaje")
        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            if let e = error {
                print("Error fetching teams: \(e)")
                failure(error: e.localizedDescription, objects: nil)
            } else {
                var teams = [Team]()
                if let pTeams = objects {
                    for team in pTeams {
                        if let indiTeam = Team(team: team) {
                            teams += [indiTeam]
                        } else {
                            print("Couldn't create team")
                            failure(error: "Couldn't create team.", objects: nil)
                            break
                        }
                    }
                } else {
                    print("No teams")
                    failure(error: "No teams", objects: nil)
                }
                
                do {
                    try PFObject.unpinAllObjectsWithName("TEAMS_LABEL")
                } catch let e {
                    print("Couldn't unpin: \(e)")
                }
                
                PFObject.pinAllInBackground(objects, withName: "TEAMS_LABEL")
            }
        }
    }
    
    /// Fetches all teams from cache, sorted by highest score to lowest.
    ///
    /// - parameter success: A closure that gets called when the operation succeeds.
    /// - parameter failure: A closure that gets called when the operation fails.
    func fetchTeamsFromCache(success success: SuccessTeamsClosure, failure: FailureTeamsFetchClosure) {
        func fetchTeams(success success: SuccessTeamsClosure, failure: FailureTeamsFetchClosure) {
            let query = PFQuery(className: "Equipos")
            query.orderByDescending("Puntaje")
            query.fromLocalDatastore()
            query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
                if let e = error {
                    print("Error fetching teams: \(e)")
                    failure(error: e.localizedDescription, objects: nil)
                } else {
                    var teams = [Team]()
                    if let pTeams = objects {
                        for team in pTeams {
                            if let indiTeam = Team(team: team) {
                                teams += [indiTeam]
                            } else {
                                print("Couldn't create team")
                                failure(error: "Couldn't create team.", objects: nil)
                                break
                            }
                        }
                    } else {
                        print("No teams")
                        failure(error: "No teams", objects: nil)
                    }
                    
                    if teams.count > 0 {
                        failure(error: "cache", objects: teams)
                    } else {
                        failure(error: "no cache", objects: nil)
                    }
                }
            }
        }
    }
}