//
//  PuzzleDataManager.swift
//  wowCastillaLeonTour
//
//  Created by Markel Juaristi on 17/7/24.
//

import Foundation
import Combine
import FirebaseFirestore

class PuzzleDataManager {
    //private let db = Firestore.firestore()
    private let firestoreManager = PuzzleFirestoreManager()
        
    func fetchPuzzleById(_ id: String) -> AnyPublisher<Puzzle, Error> {
        return firestoreManager.fetchPuzzleById(id)
    }
    
    /*
    //No needed anymore this mock
    func fetchPuzzles() -> AnyPublisher<[Puzzle], Error> {
        Future { promise in
            self.db.collection("puzzles").getDocuments { (querySnapshot, error) in
                if let error = error {
                    promise(.failure(error))
                } else {
                    let puzzles = querySnapshot?.documents.compactMap { document in
                        Puzzle(from: document.data())
                    } ?? []
                    promise(.success(puzzles))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func loadMockPuzzles() -> [Puzzle] {
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

        return [mockPuzzle]
    }
     */
}
