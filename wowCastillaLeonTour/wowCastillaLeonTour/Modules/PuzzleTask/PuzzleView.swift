//
//  PuzzleView.swift
//  wowCastillaLeonTour
//
//  Created by Markel Juaristi on 17/7/24.
//

import SwiftUI

struct PuzzleView: View {
    @StateObject private var viewModel = PuzzleViewModel()
    @State private var selectedPiece: String?
    @State private var dragOffset = CGSize.zero
    
    var body: some View {
        VStack {
            if let puzzle = viewModel.puzzles.first {
                Text(puzzle.question)
                    .font(.title)
                    .padding()
                
                AsyncImage(url: URL(string: puzzle.questionImage)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: .infinity, maxHeight: 300)
                } placeholder: {
                    ProgressView()
                }
                .padding()
                
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(puzzle.images.keys.sorted(), id: \.self) { key in
                            if let url = URL(string: puzzle.images[key] ?? "") {
                                AsyncImage(url: url) { image in
                                    image
                                        .resizable()
                                        .frame(width: 100, height: 100)
                                        .background(Color.white)
                                        .cornerRadius(8)
                                        .shadow(radius: 5)
                                        .padding(4)
                                        .offset(dragOffset)
                                        .gesture(
                                            DragGesture()
                                                .onChanged { value in
                                                    selectedPiece = key
                                                    dragOffset = value.translation
                                                }
                                                .onEnded { value in
                                                    if let selectedPiece = selectedPiece {
                                                        viewModel.piecePositions[selectedPiece] = CGPoint(x: value.location.x - 50, y: value.location.y - 50)
                                                    }
                                                    selectedPiece = nil
                                                    dragOffset = .zero
                                                }
                                        )
                                } placeholder: {
                                    ProgressView()
                                }
                            }
                        }
                    }
                }
                .frame(height: 150)
                .padding()
                
                Button("Comprobar Puzzle") {
                    if viewModel.checkPuzzleSolution(for: puzzle, tolerance: 10.0) {
                        print("Puzzle Correcto")
                    } else {
                        print("Puzzle Incorrecto")
                    }
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
        }
        .onAppear {
            viewModel.fetchPuzzles()
        }
    }
}

struct PuzzleView_Previews: PreviewProvider {
    static var previews: some View {
        PuzzleView()
    }
}
