class Event {
  late String eventName;
  late String ID;
  late String eventOwner;
  late String eventDescription;
  String photoURL = "";
  late int radius;
  late double latitude;
  late double longitude;
  late int totalParticipants;
  late List<String> participants;

  Event({
    required this.eventName,
    required this.ID,
    required this.eventOwner,
    required this.eventDescription,
    required this.radius,
    required this.latitude,
    required this.longitude,
    required this.totalParticipants,
    this.participants = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'eventName': eventName,
      'ID': ID,
      'eventOwner': eventOwner,
      'eventDescription': eventDescription,
      'radius': radius,
      'latitude': latitude,
      'longitude': longitude,
      'totalParticipants': totalParticipants,
      'participants': participants,
      'photoURL': photoURL,
    };
  }

  Event.fromMap(Map<dynamic, dynamic> map) {
    eventName = map['eventName'];
    ID = map['ID'];
    eventOwner = map['eventOwner'];
    eventDescription = map['eventDescription'];
    radius = map['radius'];
    latitude = map['latitude'].toDouble();
    longitude = map['longitude'].toDouble();
    totalParticipants = map['totalParticipants'];
    photoURL = map['photoURL'];
    participants = List<String>.from(map['participants'] ?? []);
  }
}
