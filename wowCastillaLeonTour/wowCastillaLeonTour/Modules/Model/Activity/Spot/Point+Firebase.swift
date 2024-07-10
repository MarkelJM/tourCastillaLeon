//
//  Point+Firebase.swift
//  wowCastillaLeonTour
//
//  Created by Markel Juaristi on 10/7/24.
//

import Foundation
import FirebaseFirestore

extension Point {
    init?(from firestoreData: [String: Any]) {
        guard let id = firestoreData["id"] as? String,
              let province = firestoreData["province"] as? String,
              let name = firestoreData["name"] as? String,
              let title = firestoreData["title"] as? String,
              let activityId = firestoreData["activityId"] as? String,
              let activityType = firestoreData["activityType"] as? String,
              let image = firestoreData["image"] as? String,
              let coordinatesData = firestoreData["coordinates"] as? [String: Any],
              let latitude = coordinatesData["latitude"] as? Double,
              let longitude = coordinatesData["longitude"] as? Double else {
            return nil
        }

        self.id = id
        self.province = province
        self.name = name
        self.title = title
        self.activityId = activityId
        self.activityType = activityType
        self.image = image
        self.coordinates = Coordinate(latitude: latitude, longitude: longitude)
    }
    
    func toFirestoreData() -> [String: Any] {
        return [
            "id": id,
            "province": province,
            "name": name,
            "title": title,
            "activityId": activityId,
            "activityType": activityType,
            "image": image,
            "coordinates": [
                "latitude": coordinates.latitude,
                "longitude": coordinates.longitude
            ]
        ]
    }
}
