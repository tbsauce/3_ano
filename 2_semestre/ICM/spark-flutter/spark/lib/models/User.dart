class User {
  late String ID;
  late String email;
  late String username;
  late String password;
  String photoURL= "";
  String description = "";
  late int age; // change the type of 'age' from String to int
  late String seeking;
  late String gender;
  late List<String> iLiked = [];
  late List<String> matched = [];

  User(this.ID, this.email, this.password, this.username, this.age,
      this.seeking, this.gender);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'ID': ID,
      'email': email,
      'password': password,
      'username': username,
      'description': description,
      'age': age,
      'seeking': seeking,
      'gender': gender,
      'iLiked': iLiked,
      'matched': matched,
      'photoURL': photoURL,
    };
    return map;
  }

  User.fromMap(Map<dynamic, dynamic> map) {
    ID = map['ID'];
    email = map['email'];
    password = map['password'];
    username = map['username'];
    description = map['description'];
    age = map['age'];
    seeking = map['seeking'];
    gender = map['gender'];
    photoURL = map['photoURL'];
    iLiked = List<String>.from(map['iLiked'] ?? []);
    matched = List<String>.from(map['matched'] ?? []);
  }
}
