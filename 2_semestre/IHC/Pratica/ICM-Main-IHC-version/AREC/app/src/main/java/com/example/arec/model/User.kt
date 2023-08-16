package com.example.arec.model

class User {
    var name: String? = null
    var phoneNumber: String? = null
    var uid: String? = null
    var profileImage = mutableListOf<String>()
    var age: Int? = 0
    var gender: String? = ""
    var show : String? = ""
    var description: String? = ""
    val likedYou = mutableListOf<String>()
    val matched = mutableListOf<String>()

    constructor(){}
    constructor(name: String?, phoneNumber: String?, uid: String?, age : Int?, gender:String?,
                show : String?, description: String?, profileImage: String?) {
        this.name = name
        this.phoneNumber = phoneNumber
        this.uid = uid
        this.age = age
        this.gender = gender
        this.show = show
        this.description = description
        this.profileImage.add(profileImage!!)
    }
}