package com.example.arec.model

import com.google.android.gms.maps.model.LatLng

class Event {
    var eventName: String = ""
    var ID: String = ""                    //ID of the event
    var eventOwner: String = ""            //ID of the user
    var radius: Double = 0.0             //radius of the Event
    var latitude : Double = 0.0
    var longitude: Double = 0.0
    var duration: Double = 0.0           //duration of the event
    var totalParticipants: Int = 0
    val participants = mutableListOf<String>() //Participants on event real Time

    constructor() {
        // No-argument constructor for Firebase deserialization
    }

    constructor(
        eventName: String,
        ID: String,
        eventOwner: String,
        radius: Double,
        latlng: LatLng,
        duration: Double,
        totalParticipants: Int
    ) {
        this.eventName = eventName
        this.ID = ID
        this.eventOwner = eventOwner
        this.radius = radius
        this.latitude = latlng.latitude
        this.longitude = latlng.longitude
        this.duration = duration
        this.totalParticipants = totalParticipants
    }
    //toString
    override fun toString(): String {
        return "Event(ID=$ID, eventOwner=$eventOwner, radius=$radius, " +
                ", lat=$latitude, long = $longitude,  duration=$duration, " +
                "totalParticipants=$totalParticipants, " +
                "participants=$participants)\n"
    }


}