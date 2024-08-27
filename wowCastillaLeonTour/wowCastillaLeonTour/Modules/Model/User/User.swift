//
//  User.swift
//  wowCastillaLeonTour
//
//  Created by Markel Juaristi on 11/6/24.
//

import Foundation

enum Avatar: String, Codable, CaseIterable, Identifiable {
    case boy = "chico"
    case girl = "chica"

    var id: String { self.rawValue }
}

enum Province: String, Codable, CaseIterable, Identifiable {
    case avila = "Ávila"
    case burgos = "Burgos"
    case leon = "León"
    case palencia = "Palencia"
    case salamanca = "Salamanca"
    case segovia = "Segovia"
    case soria = "Soria"
    case valladolid = "Valladolid"
    case zamora = "Zamora"
    case other = "Other"
    
    var id: String { self.rawValue }
}

struct User: Identifiable, Codable {
    var id: String
    var email: String
    var firstName: String
    var lastName: String
    var birthDate: Date
    var postalCode: String
    var city: String
    var province: Province
    var avatar: Avatar
    var spotIDs: [String]  // Manteniendo el array taskIDs
    var specialRewards: [String]  // Manteniendo el array specialRewards
    var challenges: [String: [String]]  // Diccionario donde la clave es el ID del reto y el valor es un array con los IDs de las tasks completadas en ese reto.
}



/*
import Foundation

enum Avatar: String, Codable, CaseIterable, Identifiable {
    case boy = "chico"
    case girl = "chica"

    var id: String { self.rawValue }
}

enum Province: String, Codable, CaseIterable, Identifiable {
    case avila = "Ávila"
    case burgos = "Burgos"
    case leon = "León"
    case palencia = "Palencia"
    case salamanca = "Salamanca"
    case segovia = "Segovia"
    case soria = "Soria"
    case valladolid = "Valladolid"
    case zamora = "Zamora"
    case other = "Other"
    
    var id: String { self.rawValue }
}


struct User: Identifiable, Codable {
    var id: String
    var email: String
    var firstName: String
    var lastName: String
    var birthDate: Date
    var postalCode: String
    var city: String
    var province: Province
    var avatar: Avatar
    var taskIDs: [String]
    var coinTaskIDs: [String]
    var gadgetTaskIDs: [String]
    var usedCoinTaskIDs: [String]
    var specialRewards: [String]
    var avilaCityTaskIDs: [String]
    var burgosCityTaskIDs: [String]
    var leonCityTaskIDs: [String]
    var palenciaCityTaskIDs: [String]
    var salamancaCityTaskIDs: [String]
    var segoviaCityTaskIDs: [String]
    var soriaCityTaskIDs: [String]
    var valladolidCityTaskIDs: [String]
    var zamoraCityTaskIDs: [String]

}
*/
