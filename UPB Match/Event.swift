//
//  Event.swift
//  UPB Match
//
//  Created by Andy Ibanez on 11/23/15.
//  Copyright © 2015 Fairese. All rights reserved.
//

import Foundation

/// A closure that gets called when a fetching operation of events succeeds.
typealias SuccessEventFetchClosure = (events: [Event]) -> Void

/// A closure that gets called when a fetching operation of events fails.
typealias FailureEventFetchClosure = (error: String, events: [Event]?) -> Void

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
    init(id: String, name: String, day: Int, hour: String, description: String) {
        self.ID = id
        self.name = name
        self.day = day
        self.hour = hour
        self.description = description
    }
    
    /// Fetches all events.
    static func fetchEvents(success: SuccessEventFetchClosure, failure: FailureEventFetchClosure) {
        let query = PFQuery(className: "Eventos")
        query.orderByAscending("Fecha_Evento")
        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            if let e = error {
                print("Error fetching Events: \(e)")
                failure(error: e.localizedDescription, events: nil)
            } else {
                var events = [Event]()
                for event in objects! {
                    do {
                        let id = try event.fetchIfNeeded().objectId!
                        let title = try event.fetchIfNeeded()["Nombre_Evento"] as! String
                        let date = try event.fetchIfNeeded()["Fecha_Evento"] as! NSDate
                        let cal = NSCalendar.currentCalendar().components([.Day, .Month, .Year, .Hour, .Minute], fromDate: date)
                        let eDay = cal.day
                        let min = cal.minute
                        let eHour: String
                        if(min == 0) {
                            eHour = "\(cal.hour):0\(min)"
                        } else {
                            eHour = "\(cal.hour):\(min)"
                        }
                        let desc = try event.fetchIfNeeded()["Descripcion"] as! String
                        let nEvent = Event(id: id, name: title, day: eDay, hour: eHour, description: desc)
                        events += [nEvent]
                    } catch let eyy {
                        print("fuck \(eyy)")
                    }
                }
                
                do {
                    try PFObject.unpinAllObjectsWithName("EVENTS_LABEL")
                } catch let e {
                    print("Couldn't unpin: \(e)")
                }
                
                success(events: events)
            }
        }
    }
}

/*     @Override
public void getAllEvents(final CustomSimpleCallback<Evento> callback) {
ParseQuery<ParseObject> query = ParseQuery.getQuery("Eventos");
query.orderByAscending("Fecha_Evento");
query.findInBackground(new FindCallback<ParseObject>() {
public void done(List<ParseObject> list, ParseException e) {

if (e == null) {
ArrayList<Evento> eventos = new ArrayList<>();

for(ParseObject event : list){
String eId = event.getObjectId();
String eTitulo = event.getString("Nombre_Evento");
Date eDate = event.getDate("Fecha_Evento");
Calendar cal = Calendar.getInstance();
cal.setTime(eDate);
String eHora;
int eDay = cal.get(Calendar.DAY_OF_MONTH);
if(cal.get(Calendar.MINUTE)==0) {
eHora = "" + cal.get(Calendar.HOUR_OF_DAY) + ":0" + cal.get(Calendar.MINUTE);
}else {
eHora = "" + cal.get(Calendar.HOUR_OF_DAY) + ":" + cal.get(Calendar.MINUTE);
}
String eDesc = event.getString("Descripcion");
Evento neoEvent = new Evento(eId,eTitulo,eDay,eHora,eDesc);
eventos.add(neoEvent);

}

try {
ParseObject.unpinAll("EVENTS_LABEL");
} catch (Exception ex) {
Log.e("ANDY EVENTS", "WHOOPS UNPINNING");
}

ParseObject.pinAllInBackground("TEAMS_LABEL", list);

callback.done(eventos);
}else {
allEventsCache( callback);
}

}

});
}*/