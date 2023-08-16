import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:io' as io;
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:spark/models/User.dart';
import 'package:spark/models/Event.dart';

class DbHelper {
  static Database? _db;

  static const String DB_Name = 'spark.db';
  static const String Table_User = 'user';
  static const String C_Name = 'Name';
  static const String C_Password = 'Password';
  static const String C_Age = 'Age';
  static const String C_Seeking = 'Seeking';
  static const String C_Gender = 'Gender';

  static const String Table_Event = 'event';
  static const String C_EventName = 'eventName';
  static const String C_ID = 'ID';
  static const String C_EventOwner = 'eventOwner';
  static const String C_EventDescription = 'eventDescription';
  static const String C_Radius = 'radius';
  static const String C_Latitude = 'latitude';
  static const String C_Longitude = 'longitude';
  static const String C_TotalParticipants = 'totalParticipants';
  static const String C_Participants = 'participants';

  Future<Database> get db async {
    if (_db != null) {
      return _db!;
    }
    _db = await initDb();
    return _db!;
  }

  initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, DB_Name);
    var db = await openDatabase(path,
        version: 2, onCreate: _onCreate, onUpgrade: _onUpgrade);
    return db;
  }

  _onCreate(Database db, int version) async {
    await db.execute("CREATE TABLE $Table_User ("
        "ID TEXT,"
        "email TEXT,"
        "password TEXT,"
        "username TEXT,"
        "age TEXT,"
        "seeking TEXT,"
        "gender TEXT,"
        "PRIMARY KEY (ID)"
        ")");
    await db.execute("CREATE TABLE $Table_Event ("
        "$C_EventName TEXT,"
        "$C_ID TEXT PRIMARY KEY,"
        "$C_EventOwner TEXT,"
        "$C_EventDescription TEXT,"
        "$C_Radius INTEGER,"
        "$C_Latitude REAL,"
        "$C_Longitude REAL,"
        "$C_TotalParticipants INTEGER,"
        "$C_Participants TEXT"
        ")");
  }

  _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (newVersion > oldVersion) {
      await db.execute("CREATE TABLE IF NOT EXISTS $Table_Event ("
          "$C_EventName TEXT,"
          "$C_ID TEXT PRIMARY KEY,"
          "$C_EventOwner TEXT,"
          "$C_EventDescription TEXT,"
          "$C_Radius INTEGER,"
          "$C_Latitude REAL,"
          "$C_Longitude REAL,"
          "$C_TotalParticipants INTEGER,"
          "$C_Participants TEXT"
          ")");
    }
  }

  Future<User> saveData(User user) async {
    var dbClient = await db;
    int id = await dbClient.insert(Table_User, toMapUser(user));
    user.username = id.toString();
    return user;
  }

  Future<User?> getLoginUser(String name, String password) async {
    var dbClient = await db;
    var res = await dbClient.rawQuery("SELECT * FROM $Table_User WHERE "
        "$C_Name  = '$name' AND "
        "$C_Password =  '$password'");
    if (res.length > 0) {
      return User.fromMap(res.first);
    }
    return null;
  }

  Future<Event> saveEvent(Event event) async {
    var dbClient = await db;
    String participantsString = event.participants.join(',');
    Map<String, dynamic> eventData = {
      'eventName': event.eventName,
      'ID': event.ID,
      'eventOwner': event.eventOwner,
      'eventDescription': event.eventDescription,
      'radius': event.radius,
      'latitude': event.latitude,
      'longitude': event.longitude,
      'totalParticipants': event.totalParticipants,
      'participants': participantsString,
    };
    await dbClient.insert(Table_Event, eventData);
    return event;
  }

  Future<List<User>> getAllUsers() async {
    var dbClient = await db;
    var res = await dbClient.query(Table_User);
    List<User> list =
        res.isNotEmpty ? res.map((c) => FromMapUser(c)).toList() : [];
    return list;
  }

  Future<List<Event>> getAllEvents() async {
    var dbClient = await db;
    var res = await dbClient.query(Table_Event);
    List<Event> list =
        res.isNotEmpty ? res.map((c) => fromMapEvent(c)).toList() : [];
    return list;
  }

  Future<List<Event>> getEventById(String id) async {
    var dbClient = await db;
    var res =
        await dbClient.query(Table_Event, where: 'ID = ?', whereArgs: [id]);
    List<Event> list =
        res.isNotEmpty ? res.map((c) => Event.fromMap(c)).toList() : [];
    return list;
  }

  Map<String, dynamic> toMapUser(User user) {
    var map = <String, dynamic>{
      'ID': user.ID,
      'email': user.email,
      'password': user.password,
      'username': user.username,
      'age': user.age,
      'seeking': user.seeking,
      'gender': user.gender,
    };
    return map;
  }

  User FromMapUser(Map<dynamic, dynamic> map) {
    User a = User(
      map['ID'] as String,
      map['email'] as String,
      map['password'] as String,
      map['username'] as String,
      0,
      map['seeking'] as String,
      map['gender'] as String,
    );
    return a;
  }

  Event fromMapEvent(Map<dynamic, dynamic> map) {
    final event = Event(
      eventName: map['eventName'],
      ID: map['ID'],
      eventOwner: map['eventOwner'],
      eventDescription: map['eventDescription'],
      radius: map['radius'],
      latitude: map['latitude'].toDouble(),
      longitude: map['longitude'].toDouble(),
      totalParticipants: map['totalParticipants'],
    );
    return event;
  }

  Map<String, dynamic> toMapEvent(Event event) {
    var map = <String, dynamic>{
      'eventName': event.eventName,
      'ID': event.ID,
      'eventOwner': event.eventOwner,
      'eventDescription': event.eventDescription,
      'radius': event.radius,
      'latitude': event.latitude,
      'longitude': event.longitude,
      'totalParticipants': event.totalParticipants,
    };
    return map;
  }

  Future<void> clearUserTable() async {
    var dbClient = await db;
    await dbClient.delete(Table_User);
  }

  Future<void> clearEventTable() async {
    var dbClient = await db;
    await dbClient.delete(Table_Event);
  }

  Future<User?> getUserById(String id) async {
    var dbClient = await db;
    var res =
        await dbClient.query(Table_User, where: 'ID = ?', whereArgs: [id]);
    if (res.isNotEmpty) {
      return User.fromMap(res.first);
    }
    return null;
  }

  Future<String> getDbPath() async {
    Directory appDocumentsDirectory = await getApplicationDocumentsDirectory();
    return '${appDocumentsDirectory.path}/assets/images/my_database.db';
  }
}
