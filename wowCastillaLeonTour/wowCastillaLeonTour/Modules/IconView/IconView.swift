//
//  IconView.swift
//  wowCastillaLeonTour
//
//  Created by Markel Juaristi on 27/8/24.
//

import SwiftUI

struct IconView: View {
    @State private var progress: CGFloat = 0.0
    @EnvironmentObject var appState: AppState

    var body: some View {
        ZStack {
            Image("fondoSolar")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)

            VStack {
                Spacer()
                
                // Bienvenida
                Text("Bienvenido a ConquistaCyL")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.top, 20)
                
                Text("¡Logra todos tus retos!")
                    .font(.title2)
                    .foregroundColor(.white)
                    .padding(.bottom, 20)

                Image("iconoConquistaCyL")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .shadow(color: .black.opacity(0.7), radius: 10, x: 0, y: 10)
                    .padding()

                Spacer()

                ProgressView(value: progress)
                    .progressViewStyle(LinearProgressViewStyle(tint: .mateGold))
                    .frame(width: 200)
                    .padding(.bottom, 40)
            }
        }
        .onAppear {
            startProgress()
        }
    }

    private func startProgress() {
        withAnimation(.easeInOut(duration: 1.0)) {
            progress = 1.0
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            if let _ = KeychainManager.shared.read(key: "userUID") {
                appState.currentView = .challengeList
            } else {
                appState.currentView = .login
            }
        }
    }
}
