//
//  PuzzleView.swift
//  wowCastillaLeonTour
//
//  Created by Markel Juaristi on 17/7/24.
//

import SwiftUI

import SwiftUI

struct PuzzleView: View {
    @StateObject private var viewModel = PuzzleViewModel()
    @State private var selectedPiece: String?
    @State private var dragOffset = CGSize.zero
    @State private var piecePositions: [String: CGPoint] = [:]
    
    var body: some View {
        VStack {
            if let puzzle = viewModel.puzzles.first {
                Text(puzzle.question)
                    .padding()
                
                AsyncImage(url: URL(string: puzzle.questionImage)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                } placeholder: {
                    ProgressView()
                }
                .padding()
                
                ForEach(puzzle.images.keys.sorted(), id: \.self) { key in
                    if let url = URL(string: puzzle.images[key] ?? "") {
                        AsyncImage(url: url) { image in
                            image
                                .resizable()
                                .frame(width: 50, height: 50)
                                .position(piecePositions[key, default: .zero])
                                .gesture(
                                    DragGesture()
                                        .onChanged { value in
                                            selectedPiece = key
                                            dragOffset = value.translation
                                        }
                                        .onEnded { value in
                                            if let selectedPiece = selectedPiece {
                                                piecePositions[selectedPiece] = value.location
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
                
                Button("Submit") {
                    // Lógica para verificar el puzzle
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


#Preview {
    PuzzleView()
}
