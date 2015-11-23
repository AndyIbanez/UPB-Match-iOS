//
//  InvolvedTeam.swift
//  UPB Match
//
//  Created by Andy Ibanez on 11/23/15.
//  Copyright © 2015 Fairese. All rights reserved.
//

import Foundation

/// Represents an involved team in an activiy.
public class InvolvedTeam {
    /// Team.
    let team: Team
    
    /// Event.
    let event: Event
    
    /// Creates a new InvolvedTeam.
    init(team: Team, event: Event) {
        self.team = team
        self.event = event
    }
}