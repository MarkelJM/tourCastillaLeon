//
//  ActivityType.swift
//  wowCastillaLeonTour
//
//  Created by Markel Juaristi on 1/7/24.
//

import Foundation
import SwiftUI


// Tipos de actividad
enum ActivityType: String, Codable {
    case puzzleColocar = "puzzleColocar"
    case ordenarFechas = "ordenarFechas"
    case preguntasRespuestas = "preguntasRespuestas"
    case arPulsar = "arPulsar"
    case arrastrarCosas = "arrastrarCosas"
    case buscarYSacarFotos = "buscarYSacarFotos"
    case sacarFotoGeneral = "sacarFotoGeneral"
    case ordenarPreferencias = "ordenarPreferencias"
}


