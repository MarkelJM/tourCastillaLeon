//
//  PuzzlePiece.swift
//  wowCastillaLeonTour
//
//  Created by Markel Juaristi on 22/7/24.
//

import Foundation

struct PuzzleCoordinate {
    var x: Double
    var y: Double
}

extension PuzzleCoordinate {
    init?(from firestoreData: [String: Any]) {
        if let x = firestoreData["x"] as? Double, let y = firestoreData["y"] as? Double {
            self.x = x
            self.y = y
        } else if let xString = firestoreData["x"] as? String, let yString = firestoreData["y"] as? String,
                  let x = Double(xString), let y = Double(yString) {
            self.x = x
            self.y = y
        } else if let xNSNumber = firestoreData["x"] as? NSNumber, let yNSNumber = firestoreData["y"] as? NSNumber {
            self.x = xNSNumber.doubleValue
            self.y = yNSNumber.doubleValue
        } else {
            return nil
        }
    }

    func toFirestoreData() -> [String: Any] {
        return ["x": x, "y": y]
    }
}
