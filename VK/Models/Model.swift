import Foundation

// struct or class for user and group.

class User {
    var name = String() //array [f,i,o,nickname]?
    var statusMessage = String()
    var birthday = Date()
    var city = String() //enum?
    var maritalStatus = String() //enum?
    var userLanguage = String() //enum?
    var education = String()
    var favoriteMusic = String()
    var favoriteMovie = String()
    var favoriteTVShow = String()
    var favoriteQuotes = String()
    var aboutMe = String()
    var friends = [User]()
}

class Group {
    var name = String()
    var statusMessage = String()
    var contacts = [User]()
    var members = [User]()
}
