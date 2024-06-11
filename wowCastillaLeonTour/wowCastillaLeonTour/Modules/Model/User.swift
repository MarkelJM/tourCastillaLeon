//
//  User.swift
//  wowCastillaLeonTour
//
//  Created by Markel Juaristi on 11/6/24.
//

import Foundation

enum Avatar: String, CaseIterable, Identifiable {
    case boy = "Boy"
    case girl = "Girl"
    
    var id: String { self.rawValue }
}

enum Province: String, CaseIterable, Identifiable {
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

struct User: Identifiable {
    var id: String
    var email: String
    var firstName: String
    var lastName: String
    var birthDate: Date
    var postalCode: String
    var city: String
    var province: Province
    var avatar: Avatar
}
