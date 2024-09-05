//
//  SoundManager.swift
//  wowCastillaLeonTour
//
//  Created by Markel Juaristi on 4/9/24.
//

import Foundation
import AVFoundation
import UIKit

class SoundManager {
    static let shared = SoundManager()
    private var player: AVAudioPlayer?

    // Método genérico para reproducir cualquier sonido
    func playSound(sound: String, type: String) {
        let userDefaultsManager = UserDefaultsManager()
        
        // Comprobar si el sonido está activado
        if userDefaultsManager.isSoundEnabled() {
            // Los sonidos están en Assets, cargarlos usando NSDataAsset
            if let soundAsset = NSDataAsset(name: sound) {
                do {
                    player = try AVAudioPlayer(data: soundAsset.data, fileTypeHint: type)
                    player?.play()
                } catch {
                    print("Error al reproducir el sonido \(sound): \(error.localizedDescription)")
                }
            } else {
                print("No se encontró el sonido \(sound) en los Assets.")
            }
        }
    }

    // Métodos específicos para cada sonido
    func playInitialSound() {
        playSound(sound: "initial", type: "mp3")
    }

    func playButtonSound() {
        playSound(sound: "button", type: "mp3")
    }

    func playWinnerSound() {
        playSound(sound: "winner", type: "mp3")
    }
}
