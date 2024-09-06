//
//  UnifiedAnnotation.swift
//  wowCastillaLeonTour
//
//  Created by Markel Juaristi on 30/8/24.
//

import Foundation
import MapKit

protocol IdentifiableAnnotation: MKAnnotation, Identifiable {}

class UnifiedAnnotation: NSObject, IdentifiableAnnotation {
    var id: UUID
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var abstract: String
    var activityID: String
    var activityType: String
    var image: String
    var challenge: String
    
    var spot: Spot?
    var reward: ChallengeReward?

    init(spot: Spot) {
        self.id = UUID()
        self.coordinate = CLLocationCoordinate2D(latitude: spot.coordinates.latitude, longitude: spot.coordinates.longitude)
        self.title = spot.title
        self.abstract = spot.abstract
        self.activityID = spot.activityID
        self.activityType = spot.activityType
        self.image = spot.image
        self.challenge = spot.challenge
        self.spot = spot
        self.reward = nil
    }
    
    init(reward: ChallengeReward) {
        self.id = UUID()
        self.coordinate = CLLocationCoordinate2D(latitude: reward.location.latitude, longitude: reward.location.longitude)
        self.title = reward.challengeTitle
        self.abstract = reward.abstract
        self.activityID = reward.activityID
        self.activityType = reward.activityType
        self.image = reward.prizeImage
        self.challenge = reward.challenge  
        self.spot = nil
        self.reward = reward
    }
    
    
    
}
