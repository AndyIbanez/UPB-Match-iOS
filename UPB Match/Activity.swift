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

/// A closure called when a Parse fetching operation fails.
typealias FailureFetchClosure = () -> Void

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
    func participants(success: SuccessParticipantsClosure, failure: FailureFetchClosure) {
        let query = PFQuery(className: "Participacion")
        let acti = PFObject(withoutDataWithClassName: "Actividades", objectId: self.ID)
        acti.objectId = self.ID
        query.whereKey("Id_Actividad", equalTo: acti)
        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            if let e = error {
                print("Couldn't get activities: \(e)")
                failure()
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
    func participantsCache(success: SuccessParticipantsClosure, failure: FailureFetchClosure) {
        let query = PFQuery(className: "Participacion")
        let acti = PFObject(withoutDataWithClassName: "Actividades", objectId: self.ID)
        acti.objectId = self.ID
        query.whereKey("Id_Actividad", equalTo: acti)
        query.fromLocalDatastore()
        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            if let e = error {
                print("Couldn't get activities: \(e)")
                failure()
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
                
                PFObject.pinAllInBackground(objects, withName: "PARTICIPANTES_LABEL")
                success(participants: parts)
            }
        }
    }
}

/*public class Actividad {

/**
* Devuelve los participantes de esta actividad.
* @param callback
*/
public void getParticipantes(final CustomSimpleCallback<Participante> callback) {
Log.e("ANDY LOG", "Supercat");
ParseQuery query = ParseQuery.getQuery("Participacion");
final ParseObject acti = ParseObject.createWithoutData("Actividades", this.ID);
acti.setObjectId(this.ID);
Log.e("ANDY LOG", "Chu");
query.whereEqualTo("Id_Actividad", acti);
query.findInBackground(new FindCallback<ParseObject>() {
@Override
public void done(List<ParseObject> list, ParseException e) {
if (e == null) {
Log.e("ANDY PARSE LA LISTA", list.toString());

ArrayList<Participante> partis = new ArrayList<Participante>();
for (ParseObject participant : list) {
try {
Log.e("ANDY", "PERO CREO QUE LLEGA AQUI");
ParseObject team = participant.getParseObject("Id_Equipo");
Equipo indiTeam = new Equipo(team);
Log.e("ANDY INDITEAM", "OH SHIT");
Participante dudeBro = new Participante(indiTeam, participant.getInt("Puntos_Ganados"), participant.getInt("Puntos_Perdido"));
partis.add(dudeBro);
} catch(Exception errorcito) {
Log.e("ANDY EXCE", errorcito.getMessage());
callback.fail(errorcito.getMessage(), null);
}
}
try {
Log.e("ANDY BOY", "Pineando y despineando");
ParseObject.unpinAll("PARTICIPANTES_LABEL");
} catch(Exception exi) {
Log.e("ANDY CHE", "Ututuy no se pudo.");
}

ParseObject.pinAllInBackground("PARTICIPANTES_LABEL", list);

callback.done(partis);
} else {
Log.e("ANDY PARTICIPANTES", e.getMessage());
participantesCache(callback);
}
}
});
}

/**
* Devuelve el cache de los participantes.
* @param callback
*/
public void participantesCache(final CustomSimpleCallback<Participante> callback) {
ParseQuery query = ParseQuery.getQuery("Participacion");
final ParseObject acti = ParseObject.createWithoutData("Actividades", this.ID);
acti.setObjectId(this.ID);
ParseQuery cacheQuery = ParseQuery.getQuery("Participacion");
cacheQuery.whereEqualTo("Id_Actividad", acti);
cacheQuery.fromLocalDatastore();
//cacheQuery.setCachePolicy(ParseQuery.CachePolicy.CACHE_ONLY);
cacheQuery.findInBackground(new FindCallback<ParseObject>() {
@Override
public void done(List<ParseObject> list, ParseException e) {
Log.e("ANDY PARTI", "Los partis");
if (e == null) {
ArrayList<Participante> partis = new ArrayList<Participante>();
for (ParseObject participant : list) {
try {
Equipo indiTeam = new Equipo(participant);
Participante dudeBro = new Participante(indiTeam, participant.getInt("Puntos_Ganados"), participant.getInt("Puntos_Perdido"));
partis.add(dudeBro);
} catch (Exception errorcito) {
callback.fail(errorcito.getMessage(), null);
}
}

if (partis.toArray().length > 0) {
Log.e("ANDY PARTI", "hay mas 0 participantes");
callback.fail("cache", partis);
} else {
Log.e("Andy Parti", "Menos de 0 participantes");
callback.fail("no cache", null);
}
} else {
Log.e("ANDY PARTIS", "LOS PARTIS EN FAIL " + e.getMessage());
callback.fail(e.getMessage(), null);
}
}
});
}

/**
* Crea un participante (solo utilizado para debugeo.)
* @param e
* @param punt
* @param perds
* @return
*/
public Participante hiddenCreateParticipante(Equipo e, int punt, int perds) {
return new Actividad.Participante(e, punt, perds);
}
}*/