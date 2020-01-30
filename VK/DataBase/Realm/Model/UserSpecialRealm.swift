import Foundation
import RealmSwift

//наверное лучше в Realm делать один общий класс UserRealm и добавить в него данные из UserSpecialRealm
//так как оба класса имеют общие пункты, то мы точно можем их объеденить в одну "таблицу"

class UserSpecialRealm: Object {
    @objc dynamic var id = 0
    @objc dynamic var firstName = ""
    @objc dynamic var lastName = ""
    @objc dynamic var isClosed = false
    @objc dynamic var canAccessClosed = false
    @objc dynamic var photo200 = ""
    @objc dynamic var status = ""
    //{City}
    @objc dynamic var cityId = 0
    @objc dynamic var cityTitle = ""
    //{Counters}
    @objc dynamic var countersAlbums = 0
    @objc dynamic var countersVideos = 0
    @objc dynamic var countersAudios = 0
    @objc dynamic var countersPhotos = 0
    @objc dynamic var countersNotes = 0
    @objc dynamic var countersFriends = 0
    @objc dynamic var countersGroups = 0
    @objc dynamic var countersOnlineFriends = 0
    @objc dynamic var countersMutualFriends = 0
    @objc dynamic var countersUserVideos = 0
    @objc dynamic var countersFollowers = 0
    @objc dynamic var countersPages = 0
    //[Career]?
    @objc dynamic var career = false //добавим параметр для понимания пришли вообще значения или нет
}

class UserSpecialCareerRealm: Object {
    @objc dynamic var id = 0
    @objc dynamic var careerGroupId = 0
    @objc dynamic var careerCompany = ""
    @objc dynamic var careerCountryId = 0
    @objc dynamic var careerCityId = 0
    @objc dynamic var careerCityName = ""
    @objc dynamic var careerFrom = 0
    @objc dynamic var careerUntil = 0
    @objc dynamic var careerPosition = ""
    
    //dynamic var userSpecial: UserSpecialRealm! //привязываем каждый объект с данными к классу нашего UserSpecialRealm
}

class UserSpecialRepositoryRealm {
    
    var userSpecialRealm: UserSpecialRealm!
    var userSpecialCareerRealm: UserSpecialCareerRealm!
    
    func addUser(id: Int, firstName: String, lastName: String, isClosed: Bool, canAccessClosed: Bool, photo200: String, status: String, cityId: Int, cityTitle: String, countersAlbums: Int, countersVideos: Int, countersAudios: Int, countersPhotos: Int, countersNotes : Int, countersFriends: Int, countersGroups: Int, countersOnlineFriends: Int, countersMutualFriends: Int, countersUserVideos: Int, countersFollowers: Int, countersPages: Int, career: Bool) {
        
        let realm = try? Realm()
        let newUserSpecial = UserSpecialRealm()
        
        newUserSpecial.id = id
        newUserSpecial.firstName = firstName
        newUserSpecial.lastName = lastName
        newUserSpecial.isClosed = isClosed
        newUserSpecial.canAccessClosed = canAccessClosed
        newUserSpecial.photo200 = photo200
        newUserSpecial.status = status
        //{City}
        newUserSpecial.cityId = cityId
        newUserSpecial.cityTitle = cityTitle
        //{Counters}
        newUserSpecial.countersAlbums = countersAlbums
        newUserSpecial.countersVideos = countersVideos
        newUserSpecial.countersAudios = countersAudios
        newUserSpecial.countersPhotos = countersPhotos
        newUserSpecial.countersNotes = countersNotes
        newUserSpecial.countersFriends = countersFriends
        newUserSpecial.countersGroups = countersGroups
        newUserSpecial.countersOnlineFriends = countersOnlineFriends
        newUserSpecial.countersMutualFriends = countersMutualFriends
        newUserSpecial.countersUserVideos = countersUserVideos
        newUserSpecial.countersFollowers = countersFollowers
        newUserSpecial.countersPages = countersPages
        newUserSpecial.career = career
        
        try? realm?.write {
            realm?.add(newUserSpecial)
            self.userSpecialRealm = newUserSpecial
        }
    }
    
    func getUser(id: Int) -> UserSpecialRealm? {
        let realm = try! Realm()
        return realm.objects(UserSpecialRealm.self).filter("id == %@", id).first
    }
    
    func updateUser(id: Int, firstName: String, lastName: String, isClosed: Bool, canAccessClosed: Bool, photo200: String, status: String, cityId: Int, cityTitle: String, countersAlbums: Int, countersVideos: Int, countersAudios: Int, countersPhotos: Int, countersNotes : Int, countersFriends: Int, countersGroups: Int, countersOnlineFriends: Int, countersMutualFriends: Int, countersUserVideos: Int, countersFollowers: Int, countersPages: Int, career: Bool) {
        let realm = try! Realm()
        try! realm.write {
            self.userSpecialRealm.id = id
            self.userSpecialRealm.firstName = firstName
            self.userSpecialRealm.lastName = lastName
            self.userSpecialRealm.isClosed = isClosed
            self.userSpecialRealm.canAccessClosed = canAccessClosed
            self.userSpecialRealm.photo200 = photo200
            self.userSpecialRealm.status = status
            //{City}
            self.userSpecialRealm.cityId = cityId
            self.userSpecialRealm.cityTitle = cityTitle
            //{Counters}
            self.userSpecialRealm.countersAlbums = countersAlbums
            self.userSpecialRealm.countersVideos = countersVideos
            self.userSpecialRealm.countersAudios = countersAudios
            self.userSpecialRealm.countersPhotos = countersPhotos
            self.userSpecialRealm.countersNotes = countersNotes
            self.userSpecialRealm.countersFriends = countersFriends
            self.userSpecialRealm.countersGroups = countersGroups
            self.userSpecialRealm.countersOnlineFriends = countersOnlineFriends
            self.userSpecialRealm.countersMutualFriends = countersMutualFriends
            self.userSpecialRealm.countersUserVideos = countersUserVideos
            self.userSpecialRealm.countersFollowers = countersFollowers
            self.userSpecialRealm.countersPages = countersPages
            self.userSpecialRealm.career = career
        }
    }
    
    func getAllUsers() -> Results<UserSpecialRealm> {
        let realm = try! Realm()
        return realm.objects(UserSpecialRealm.self)
    }
    
    func addCareer(id: Int, careerGroupId: Int, careerCompany: String, careerCountryId: Int, careerCityId: Int, careerCityName: String, careerFrom: Int, careerUntil: Int, careerPosition: String) {
        
        let realm = try? Realm()
        let newUserSpecialCareer = UserSpecialCareerRealm()
        
        newUserSpecialCareer.id = id
        newUserSpecialCareer.careerGroupId = careerGroupId
        newUserSpecialCareer.careerCompany = careerCompany
        newUserSpecialCareer.careerCountryId = careerCountryId
        newUserSpecialCareer.careerCityId = careerCityId
        newUserSpecialCareer.careerCityName = careerCityName
        newUserSpecialCareer.careerFrom = careerFrom
        newUserSpecialCareer.careerUntil = careerUntil
        newUserSpecialCareer.careerPosition = careerPosition
        
        try? realm?.write {
            realm?.add(newUserSpecialCareer)
            self.userSpecialCareerRealm = newUserSpecialCareer
        }
    }
    
    func updateCareer(id: Int, careerGroupId: Int, careerCompany: String, careerCountryId: Int, careerCityId: Int, careerCityName: String, careerFrom: Int, careerUntil: Int, careerPosition: String) {
        let realm = try! Realm()
        try! realm.write {
            self.userSpecialCareerRealm.id = id
            self.userSpecialCareerRealm.careerGroupId = careerGroupId
            self.userSpecialCareerRealm.careerCompany = careerCompany
            self.userSpecialCareerRealm.careerCountryId = careerCountryId
            self.userSpecialCareerRealm.careerCityId = careerCityId
            self.userSpecialCareerRealm.careerCityName = careerCityName
            self.userSpecialCareerRealm.careerFrom = careerFrom
            self.userSpecialCareerRealm.careerUntil = careerUntil
            self.userSpecialCareerRealm.careerPosition = careerPosition
        }
    }
    
    func getAllCareers() -> Results<UserSpecialCareerRealm> {
        let realm = try! Realm()
        return realm.objects(UserSpecialCareerRealm.self)
    }
    
}
