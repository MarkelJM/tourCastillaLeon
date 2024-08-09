//
//  User+Firebase.swift
//  wowCastillaLeonTour
//
//  Created by Markel Juaristi on 12/6/24.
//

import FirebaseFirestore

extension User {
    init?(from firestoreData: [String: Any]) {
        guard let id = firestoreData["id"] as? String,
              let email = firestoreData["email"] as? String,
              let firstName = firestoreData["firstName"] as? String,
              let lastName = firestoreData["lastName"] as? String,
              let birthDateTimestamp = firestoreData["birthDate"] as? Timestamp,
              let postalCode = firestoreData["postalCode"] as? String,
              let city = firestoreData["city"] as? String,
              let provinceString = firestoreData["province"] as? String,
              let province = Province(rawValue: provinceString),
              let avatarString = firestoreData["avatar"] as? String,
              let avatar = Avatar(rawValue: avatarString),
              let taskIDs = firestoreData["taskIDs"] as? [String],
              let coinTaskIDs = firestoreData["coinTaskIDs"] as? [String],
              let gadgetTaskIDs = firestoreData["gadgetTaskIDs"] as? [String],
              let usedCoinTaskIDs = firestoreData["usedCoinTaskIDs"] as? [String],
              let specialRewards = firestoreData["specialRewards"] as? [String],
              let avilaCityTaskIDs = firestoreData["avilaCityTaskIDs"] as? [String],
              let burgosCityTaskIDs = firestoreData["burgosCityTaskIDs"] as? [String],
              let leonCityTaskIDs = firestoreData["leonCityTaskIDs"] as? [String],
              let palenciaCityTaskIDs = firestoreData["palenciaCityTaskIDs"] as? [String],
              let salamancaCityTaskIDs = firestoreData["salamancaCityTaskIDs"] as? [String],
              let segoviaCityTaskIDs = firestoreData["segoviaCityTaskIDs"] as? [String],
              let soriaCityTaskIDs = firestoreData["soriaCityTaskIDs"] as? [String],
              let valladolidCityTaskIDs = firestoreData["valladolidCityTaskIDs"] as? [String],
              let zamoraCityTaskIDs = firestoreData["zamoraCityTaskIDs"] as? [String] else {
            return nil
        }
        
        self.id = id
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
        self.birthDate = birthDateTimestamp.dateValue()
        self.postalCode = postalCode
        self.city = city
        self.province = province
        self.avatar = avatar
        self.taskIDs = taskIDs
        self.coinTaskIDs = coinTaskIDs
        self.gadgetTaskIDs = gadgetTaskIDs
        self.usedCoinTaskIDs = usedCoinTaskIDs
        self.specialRewards = specialRewards
        self.avilaCityTaskIDs = avilaCityTaskIDs
        self.burgosCityTaskIDs = burgosCityTaskIDs
        self.leonCityTaskIDs = leonCityTaskIDs
        self.palenciaCityTaskIDs = palenciaCityTaskIDs
        self.salamancaCityTaskIDs = salamancaCityTaskIDs
        self.segoviaCityTaskIDs = segoviaCityTaskIDs
        self.soriaCityTaskIDs = soriaCityTaskIDs
        self.valladolidCityTaskIDs = valladolidCityTaskIDs
        self.zamoraCityTaskIDs = zamoraCityTaskIDs
    }
    
    func toFirestoreData() -> [String: Any] {
        return [
            "id": id,
            "email": email,
            "firstName": firstName,
            "lastName": lastName,
            "birthDate": Timestamp(date: birthDate),
            "postalCode": postalCode,
            "city": city,
            "province": province.rawValue,
            "avatar": avatar.rawValue,
            "taskIDs": taskIDs,
            "coinTaskIDs": coinTaskIDs,
            "gadgetTaskIDs": gadgetTaskIDs,
            "usedCoinTaskIDs": usedCoinTaskIDs,
            "specialRewards": specialRewards,
            "avilaCityTaskIDs": avilaCityTaskIDs,
            "burgosCityTaskIDs": burgosCityTaskIDs,
            "leonCityTaskIDs": leonCityTaskIDs,
            "palenciaCityTaskIDs": palenciaCityTaskIDs,
            "salamancaCityTaskIDs": salamancaCityTaskIDs,
            "segoviaCityTaskIDs": segoviaCityTaskIDs,
            "soriaCityTaskIDs": soriaCityTaskIDs,
            "valladolidCityTaskIDs": valladolidCityTaskIDs,
            "zamoraCityTaskIDs": zamoraCityTaskIDs
        ]
    }
}
