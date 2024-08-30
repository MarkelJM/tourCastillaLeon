//
//  PuzzleView.swift
//  wowCastillaLeonTour
//
//  Created by Markel Juaristi on 17/7/24.
//

import SwiftUI

struct PuzzleView: View {
    @StateObject var viewModel: PuzzleViewModel
    @EnvironmentObject var appState: AppState
    @State private var showInstructionsAlert = true
    
    var body: some View {
        ZStack {
            // Fondo de pantalla
            Image("fondoSolar")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            
            ScrollView { // ScrollView para asegurar que todo el contenido sea accesible
                VStack {
                    if viewModel.isLoading {
                        Text("Cargando puzzles...")
                            .font(.title2)
                            .foregroundColor(.mateWhite)
                    } else if let errorMessage = viewModel.errorMessage {
                        Text("Error: \(errorMessage)")
                            .foregroundColor(.red)
                    } else if let puzzle = viewModel.puzzles.first {
                        VStack(alignment: .leading) {
                            HStack {
                                // Botón de "Atrás" con imagen de flecha
                                Button(action: {
                                    appState.currentView = .map
                                }) {
                                    Image(systemName: "chevron.left") // Imagen de flecha del sistema
                                        .font(.headline)
                                        .padding()
                                        .background(Color.mateGold)
                                        .foregroundColor(.black)
                                        .cornerRadius(10)
                                }

                                Spacer()

                                Button(action: {
                                    viewModel.checkPuzzle()
                                }) {
                                    Text("Comprobar Puzzle")
                                        .padding()
                                        .background(Color.mateRed)
                                        .foregroundColor(.mateWhite)
                                        .cornerRadius(10)
                                }
                            }
                            .padding(.horizontal, 10)
                            .padding(.top, 50)

                            // Texto de la pregunta
                            Text(puzzle.question)
                                .font(.subheadline)
                                .foregroundColor(.mateGold)
                                .multilineTextAlignment(.leading)
                                .padding(.horizontal, 10)
                                .padding(.bottom, 10)
                                .padding(.top, 30)
                            
                            GeometryReader { geometry in
                                ZStack {
                                    // Main Puzzle Image
                                    AsyncImage(url: URL(string: puzzle.questionImage)) { image in
                                        image
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: geometry.size.width, height: geometry.size.height)
                                    } placeholder: {
                                        ProgressView()
                                            .frame(width: geometry.size.width, height: geometry.size.height)
                                    }
                                    .padding()

                                    // Dropped Pieces
                                    ForEach(viewModel.droppedPieces.keys.sorted(), id: \.self) { key in
                                        if let imageUrl = puzzle.images[key], let position = viewModel.droppedPieces[key] {
                                            AsyncImage(url: URL(string: imageUrl)) { image in
                                                image
                                                    .resizable()
                                                    .frame(width: 50, height: 50)
                                                    .position(x: position.x, y: position.y)
                                                    .gesture(
                                                        DragGesture()
                                                            .onChanged { value in
                                                                viewModel.updateDraggedPiecePosition(to: value.location, key: key)
                                                            }
                                                            .onEnded { _ in
                                                                viewModel.dropPiece()
                                                            }
                                                    )
                                            } placeholder: {
                                                ProgressView()
                                                    .frame(width: 50, height: 50)
                                                    .position(x: position.x, y: position.y)
                                            }
                                        }
                                    }
                                }
                            }
                            .frame(height: 500)
                            .padding()

                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack {
                                    ForEach(puzzle.images.keys.sorted(), id: \.self) { key in
                                        if let imageUrl = puzzle.images[key] {
                                            AsyncImage(url: URL(string: imageUrl)) { image in
                                                image
                                                    .resizable()
                                                    .frame(width: 100, height: 100)
                                                    .padding()
                                                    .onTapGesture {
                                                        viewModel.selectPiece(key: key)
                                                    }
                                            } placeholder: {
                                                ProgressView()
                                                    .frame(width: 100, height: 100)
                                            }
                                        }
                                    }
                                }
                                .padding()
                                .background(Color.gray.opacity(0.2))
                            }
                            .frame(height: 150)
                        }
                        .padding()
                        .background(Color.black.opacity(0.5)) // Fondo del VStack con transparencia
                        .cornerRadius(20)
                        .sheet(isPresented: $viewModel.showSheet) {
                            ResulPuzzleSheetView(viewModel: viewModel)
                        }
                        .alert(isPresented: $showInstructionsAlert) {
                            Alert(
                                title: Text("Instrucciones"),
                                message: Text("Primero debe seleccionar la imagen en la parte inferior y una vez que se muestre en el puzzle situarlo en su lugar."),
                                dismissButton: .default(Text("Entendido"))
                            )
                        }
                    } else {
                        Text("No hay puzzles disponibles")
                            .foregroundColor(.mateWhite)
                    }
                }
            }
        }
        .onAppear {
            viewModel.fetchPuzzle()
        }
    }
}

struct ResulPuzzleSheetView: View {
    @ObservedObject var viewModel: PuzzleViewModel
    @EnvironmentObject var appState: AppState  // Añadir el environment object
    
    var body: some View {
        ZStack {
            Image("fondoSolar")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)

            VStack {
                Text(viewModel.alertMessage)
                    .font(.title)
                    .foregroundColor(.mateGold)
                    .padding()

                Button(action: {
                    viewModel.showSheet = false
                    appState.currentView = .map  // Navegar al mapa después de cerrar el sheet
                }) {
                    Text("Continuar")
                        .padding()
                        .background(Color.mateRed)
                        .foregroundColor(.mateWhite)
                        .cornerRadius(10)
                }
            }
            .padding()
            .background(Color.black.opacity(0.5))
            .cornerRadius(20)
            .padding()
        }
    }
}

/*
#Preview {
    PuzzleView(viewModel: PuzzleViewModel(activityId: "mockId", appState: appState))        .environmentObject(AppState())
}
*/
/*
struct PuzzleView_Previews: PreviewProvider {
    static var previews: some View {
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

        let viewModel = PuzzleViewModel(activityId: mockPuzzle.id)
        viewModel.puzzles = [mockPuzzle]

        return PuzzleView(viewModel: viewModel)
            .environmentObject(AppState())
    }
}

*/

/*
struct PuzzleView: View {
    @StateObject private var viewModel = PuzzleViewModel()
    @EnvironmentObject var appState: AppState
    @State private var showAlert = true // Variable para controlar la alerta
    
    var body: some View {
        VStack {
            if viewModel.isLoading {
                Text("Cargando puzzles...")
            } else if let errorMessage = viewModel.errorMessage {
                Text("Error: \(errorMessage)")
            } else if let puzzle = viewModel.puzzles.first {
                VStack {
                    HStack {
                        Text(puzzle.question)
                            .font(.subheadline)
                            .padding(.trailing, 10)

                        Button("Comprobar Puzzle") {
                            viewModel.checkPuzzle()
                        }
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                    .padding()

                    GeometryReader { geometry in
                        ZStack {
                            AsyncImage(url: URL(string: puzzle.questionImage)) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: geometry.size.width, height: geometry.size.height )
                            } placeholder: {
                                ProgressView()
                                    .frame(width: geometry.size.width, height: geometry.size.height )
                            }
                            .padding()

                            ForEach(viewModel.droppedPieces.keys.sorted(), id: \.self) { key in
                                if let imageUrl = puzzle.images[key], let position = viewModel.droppedPieces[key] {
                                    AsyncImage(url: URL(string: imageUrl)) { image in
                                        image
                                            .resizable()
                                            .frame(width: 50, height: 50)
                                            .position(x: position.x, y: position.y)
                                            .gesture(
                                                DragGesture()
                                                    .onChanged { value in
                                                        viewModel.updateDraggedPiecePosition(to: value.location, key: key)
                                                    }
                                                    .onEnded { _ in
                                                        viewModel.dropPiece()
                                                    }
                                            )
                                    } placeholder: {
                                        ProgressView()
                                            .frame(width: 100, height: 100)
                                            .position(x: position.x, y: position.y)
                                    }
                                }
                            }
                        }
                    }
                    .frame(height: 500) // Hacer la imagen principal más grande
                    .padding()

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(puzzle.images.keys.sorted(), id: \.self) { key in
                                if let imageUrl = puzzle.images[key] {
                                    AsyncImage(url: URL(string: imageUrl)) { image in
                                        image
                                            .resizable()
                                            .frame(width: 100, height: 100)
                                            .padding()
                                            .onTapGesture {
                                                viewModel.selectPiece(key: key)
                                            }
                                    } placeholder: {
                                        ProgressView()
                                            .frame(width: 100, height: 100)
                                    }
                                }
                            }
                        }
                        .padding()
                        .background(Color.gray.opacity(0.2)) // Fondo para el HStack para mantenerlo visible
                    }
                    .frame(height: 150) // Mantener el HStack visible y con espacio
                }
                .padding()
                .background(GradientBackgroundView())
                .alert(isPresented: $showAlert) {
                    Alert(
                        title: Text("Instrucciones"),
                        message: Text("Primero debe seleccionar la imagen en la parte inferior y una vez que se muestre en el puzzle situarlo en su lugar."),
                        dismissButton: .default(Text("Entendido"))
                    )
                }
            } else {
                Text("No hay puzzles disponibles")
            }
        }
        .onAppear {
            viewModel.loadMockPuzzles() // Carga datos simulados para la previsualización
        }
    }
}

struct PuzzleView_Previews: PreviewProvider {
    static var previews: some View {
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

        let viewModel = PuzzleViewModel()
        viewModel.puzzles = [mockPuzzle]

        return PuzzleView()
            .environmentObject(AppState())
            .environmentObject(viewModel)
    }
}
*/
