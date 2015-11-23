//
//  Activity.swift
//  UPB Match
//
//  Created by Andy Ibanez on 11/23/15.
//  Copyright © 2015 Fairese. All rights reserved.
//

import Foundation

/// A closure that gets called when an operation fetching content finishes successfully.
///
/// - paramater participants: An array of participants involved in the activity.
typealias SuccessParticipantsClosure = (participants: [Activity.Participant]) -> Void

/// A closure called when a Participants fetch fails.
typealias FailureParticipantsFetchClosure = (error: String, objects: [Activity.Participant]?) -> Void

/// Represents an activity.
public class Activity {
    
    /// Represents a participant.
    public struct Participant {
        /// Team participating on this activity.
        let participant: Team
        
        /// Points earned.
        let totalPoints: Int
        
        /// Points lot.
        let pointsLost: Int
        
        /// Creates a new participant.
        ///
        /// - parameter team: The team represented by this object.
        /// - parameter totalPoints: Total points earned.
        /// - parameter pointsLost: Total points lost.
        init(team: Team, totalPoints: Int, pointsLost: Int) {
            self.participant = team
            self.totalPoints = totalPoints
            self.pointsLost = pointsLost
        }
    }
    
    /// State of the activity.
    let state: String
    
    /// Time of the activity.
    let dateOrHour: String
    
    /// Activity ID.
    let ID: String
    
    /// Activity name.
    let name: String
    
    /// Number of participants (people).
    let numberOfParticipants: Int
    
    /// Activity rules.
    let rules: String
    
    /// Background name.
    let backgroundName: String
    
    /// Icon name.
    let iconName: String
    
    /// Creates a new activity manually.
    ///
    /// - parameter state: State of the activity.
    /// - parameter dateTime: DateTime of the activity.
    /// - parameter name: Activity name.
    /// - parameter numberOfParticipants: Number of people involved.
    /// - parameter rules: Activity rules.
    /// - parameter backgroundName: Name for the background file.
    /// - parameter iconName: Name for the icon file.
    init(state: String, dateTime: String, id: String, name: String, numberOfParticipants: Int, rules: String, backgroundName: String, iconName: String) {
        self.state = state
        self.dateOrHour = dateTime
        self.name = name
        self.ID = id
        self.numberOfParticipants = numberOfParticipants
        self.rules = rules
        self.backgroundName = backgroundName
        self.iconName = iconName
    }
    
    /// Creates a new activity with a Parse object.
    ///
    /// - parameter parseObject: The `ParseObject` used to create this activity.
    init(parseObject: PFObject) {
        self.state = parseObject["Estado"] as! String // I don't like force-casting, but time is an evil thing :-)
        self.dateOrHour = parseObject["Fecha_Hora"] as! String
        self.ID = parseObject.objectId! 
        self.name = parseObject["Nombre_Actividad"] as! String
        self.numberOfParticipants = Int(parseObject["Numero_Participantes"] as! String)!
        self.rules = parseObject["Reglas"] as! String
        self.backgroundName = parseObject["FondoActividad"] as! String
        self.iconName = parseObject["Icono_Actividad"] as! String
    }
    
    /// Returns all the participants of this activity.
    ///
    /// - parameter success: A closure that gets called when the operation finishes successfully.
    /// - parameter failure: A closure that gets called when the operation fails.
    func participants(success: SuccessParticipantsClosure, failure: FailureParticipantsFetchClosure) {
        let query = PFQuery(className: "Participacion")
        let acti = PFObject(withoutDataWithClassName: "Actividades", objectId: self.ID)
        acti.objectId = self.ID
        query.whereKey("Id_Actividad", equalTo: acti)
        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            if let e = error {
                print("Couldn't get activities: \(e)")
                failure(error: e.localizedDescription, objects: nil)
            } else {
                var parts = [Participant]()
                if let objs = objects {
                    for participant in objs {
                        let team = participant.objectForKey("Id_Equipo") as! PFObject
                        // TODO
                        // let indiTeam = Team(team)
                        //let ptcpt = Participant(team: indieTeam, totalPoints: Int(participant["Puntos_Ganados"] as! String)!, pointsLost: Int(participant["Puntos_Puntos_Perdido"] as! String)!)
                        //parts += [ptcpt]
                    }
                }
                
                do {
                    try PFObject.unpinAllObjectsWithName("PARTICIPANTES_LABEL")
                } catch let e {
                    print("Couldn't unpin: \(e)")
                }
                
                PFObject.pinAllInBackground(objects, withName: "PARTICIPANTES_LABEL")
                success(participants: parts)
            }
        }
    }
    
    /// Returns all participants from cache.
    ///
    /// - parameter success: A closure that gets called when the operation finishes successfully.
    /// - parameter failure: A closure that gets called when the operation fails.
    func participantsCache(success: SuccessParticipantsClosure, failure: FailureParticipantsFetchClosure) {
        let query = PFQuery(className: "Participacion")
        let acti = PFObject(withoutDataWithClassName: "Actividades", objectId: self.ID)
        acti.objectId = self.ID
        query.whereKey("Id_Actividad", equalTo: acti)
        query.fromLocalDatastore()
        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            if let e = error {
                print("Couldn't get activities: \(e)")
                failure(error: e.localizedDescription, objects: nil)
            } else {
                var parts = [Participant]()
                if let objs = objects {
                    for participant in objs {
                        // TODO
                        // let indiTeam = Team(participant)
                        //let ptcpt = Participant(team: indieTeam, totalPoints: Int(participant["Puntos_Ganados"] as! String)!, pointsLost: Int(participant["Puntos_Puntos_Perdido"] as! String)!)
                        //parts += [ptcpt]
                    }
                }
                
                if parts.count > 0 {
                    print("We have a cache \(parts.count)")
                    failure(error: "cache", objects: parts)
                } else {
                    print("No cache")
                    failure(error: "no cache", objects: nil)
                }
                
                PFObject.pinAllInBackground(objects, withName: "PARTICIPANTES_LABEL")
            }
        }
    }
}