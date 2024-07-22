//
//  PuzzleViewModel.swift
//  wowCastillaLeonTour
//
//  Created by Markel Juaristi on 17/7/24.
//

import SwiftUI
import Combine

class PuzzleViewModel: ObservableObject {
    @Published var puzzles: [Puzzle] = []
    @Published var errorMessage: String?
    @Published var isLoading: Bool = true
    @Published var droppedPieces: [String: CGPoint] = [:]
    @Published var draggingPiece: String?
    @Published var showSheet: Bool = false
    @Published var alertMessage: String = ""
    
    private let dataManager = PuzzleDataManager()
    private var cancellables = Set<AnyCancellable>()
    private var activityId: String
    
    init(activityId: String) {
        self.activityId = activityId
    }
    
    func fetchPuzzle() {
        isLoading = true
        dataManager.fetchPuzzleById(activityId)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                    self.isLoading = false
                case .finished:
                    break
                }
            } receiveValue: { puzzle in
                self.puzzles = [puzzle]
                self.isLoading = false
            }
            .store(in: &cancellables)
    }
    
    func updateDraggedPiecePosition(to location: CGPoint, key: String) {
        droppedPieces[key] = location
        print("Updated position for piece \(key): \(location)")
    }

    func dropPiece() {
        draggingPiece = nil
        print("Piece dropped")
    }

    func selectPiece(key: String) {
        droppedPieces[key] = CGPoint(x: 150, y: 150) // Cambia estas coordenadas según sea necesario
        print("Piece \(key) selected and moved to (150, 150)")
    }
    
    func checkPuzzle() {
        guard let puzzle = puzzles.first else { return }
        var isCorrect = true
        
        for (key, correctPosition) in puzzle.correctPositions {
            if let currentPosition = droppedPieces[key] {
                let tolerance: CGFloat = 10.0 // Tolerancia en puntos
                let correctX = correctPosition.x * 500 // Ajusta según el tamaño de la imagen principal
                let correctY = correctPosition.y * 500
                let differenceX = abs(currentPosition.x - correctX)
                let differenceY = abs(currentPosition.y - correctY)

                print("Checking position for piece \(key):")
                print(" - Correct position from Firestore: (\(correctPosition.x), \(correctPosition.y))")
                print(" - Correct position (scaled): (\(correctX), \(correctY))")
                print(" - Current position: (\(currentPosition.x), \(currentPosition.y))")
                print(" - Difference: (x: \(differenceX), y: \(differenceY))")

                if differenceX > tolerance || differenceY > tolerance {
                    isCorrect = false
                    break
                }
            } else {
                isCorrect = false
                break
            }
        }
        
        if isCorrect {
            alertMessage = puzzle.correctAnswerMessage
        } else {
            alertMessage = puzzle.incorrectAnswerMessage
        }
        
        print("Puzzle check result: \(alertMessage)")
        showSheet = true
    }
}

/*
import Foundation
import SwiftUI
import Combine

class PuzzleViewModel: ObservableObject {
    @Published var puzzles: [Puzzle] = []
    @Published var errorMessage: String?
    @Published var isLoading: Bool = true
    @Published var droppedPieces: [String: CGPoint] = [:]
    @Published var draggingPiece: String?

    private var cancellables = Set<AnyCancellable>()

    func loadMockPuzzles() {
        // Datos simulados para la previsualización
        let mockPuzzle = Puzzle(
            id: "BU-puzzle-17",
            province: "burgos",
            question: "Te encuentras en el Arco de Santa María. ¿Sabrías colocar adecuadamente cada personaje histórico?",
            questionImage: "https://firebasestorage.googleapis.com/v0/b/wowcastillaleon-2ff66.appspot.com/o/tareaArco.png?alt=media&token=79a9b05d-d4b8-4c55-a1f9-8b035439218f",
            images: [
                "a": "https://firebasestorage.googleapis.com/v0/b/wowcastillaleon-2ff66.appspot.com/o/a.png?alt=media&token=d708dcd2-9db9-4596-af12-0ba74529df29",
                "b": "https://firebasestorage.googleapis.com/v0/b/wowcastillaleon-2ff66.appspot.com/o/b.png?alt=media&token=5b76fdec-3aa5-47c5-9afe-5b3202183872",
                "c": "https://firebasestorage.googleapis.com/v0/b/wowcastillaleon-2ff66.appspot.com/o/c.png?alt=media&token=d3b400c2-612a-496e-b0ca-9b2abe29699d",
                "d": "https://firebasestorage.googleapis.com/v0/b/wowcastillaleon-2ff66.appspot.com/o/d.png?alt=media&token=6a6892bc-9fbe-4056-9519-d80fce4d1bd6",
                "e": "https://firebasestorage.googleapis.com/v0/b/wowcastillaleon-2ff66.appspot.com/o/e.png?alt=media&token=4248cac6-bb07-4669-919f-8207e1731083",
                "f": "https://firebasestorage.googleapis.com/v0/b/wowcastillaleon-2ff66.appspot.com/o/f.png?alt=media&token=57e0d214-36ce-45c7-99fc-43419864de8f",
                "g": "https://firebasestorage.googleapis.com/v0/b/wowcastillaleon-2ff66.appspot.com/o/g.png?alt=media&token=5ce29f5f-1495-4690-a977-40d86afa4795",
                "h": "https://firebasestorage.googleapis.com/v0/b/wowcastillaleon-2ff66.appspot.com/o/h.png?alt=media&token=b1fb2fe5-45db-4a6c-8997-0fc882658131"
            ],
            correctPositions: [
                "a": (x: 0.00367, y: 0.00233),
                "b": (x: 0.00363, y: 0.00560),
                "c": (x: 0.00239, y: 0.00847),
                "d": (x: 0.00358, y: 0.00827),
                "e": (x: 0.00345, y: 0.01287),
                "f": (x: 0.00235, y: 0.01035),
                "g": (x: 0.00354, y: 0.01044),
                "h": (x: 0.004785, y: 0.0104)
            ],
            customMessage: "Bienvenid@ al Arco de Santa María",
            correctAnswerMessage: "Si, es correcta tu respuesta.",
            incorrectAnswerMessage: "No, esa no es la respuesta correcta. ¡Vuelvelo a intenar!"
        )

        self.puzzles = [mockPuzzle]
        self.isLoading = false
    }

    func updateDraggedPiecePosition(to location: CGPoint, key: String) {
        if let draggingPiece = draggingPiece, draggingPiece == key {
            droppedPieces[key] = location
        }
    }

    func dropPiece() {
        draggingPiece = nil
    }

    func checkPuzzle() {
        // Aquí iría la lógica para verificar si las piezas están en la posición correcta
    }
}
*/
