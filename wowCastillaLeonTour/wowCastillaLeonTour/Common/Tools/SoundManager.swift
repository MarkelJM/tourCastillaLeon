//
//  SoundManager.swift
//  wowCastillaLeonTour
//
//  Created by Markel Juaristi on 4/9/24.
//

import Foundation
import AVFoundation

class SoundManager {
    static let shared = SoundManager()
    var player: AVAudioPlayer?

    func playSound(sound: String, type: String) {
        if let path = Bundle.main.path(forResource: sound, ofType: type) {
            do {
                player = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
                player?.play()
            } catch {
                print("Error al reproducir el sonido")
            }
        }
    }
}
