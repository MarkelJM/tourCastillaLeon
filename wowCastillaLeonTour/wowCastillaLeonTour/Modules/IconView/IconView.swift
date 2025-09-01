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
    let soundManager = SoundManager.shared

    var body: some View {
        ZStack {
            Image("fondoSolar")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)

            VStack {
                Spacer()

                VStack {
                    Text("Bienvenido a ConquistaCyL")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.mateGold)
                        .padding(.top, 20)
                    
                    Text("¡Logra todos tus retos!")
                        .font(.title2)
                        .foregroundColor(.mateGold)
                        .padding(.bottom, 20)
                }
                .padding(30)
                .background(Color.black.opacity(0.5))
                .cornerRadius(20)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.mateGold, lineWidth: 2)
                )
                .padding(.horizontal, 40)

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

                // Rectángulo blanco con logo y texto
                VStack {
                    Image("logoJuntaCyL")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 80)

                    Text("2. Premio: Datos Abiertos de la Comunidad de Castilla y León 2024")
                        .font(.system(size: 20)) // Tamaño de fuente corregido
                        .foregroundColor(.mateGold)
                        .multilineTextAlignment(.center)
                        .padding(.top, 5)
                        .padding(.bottom, 20)

                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.white)
                //.cornerRadius(10)
                //.shadow(radius: 5)
                //.padding(.horizontal, 20)
                //.padding(.bottom, 20)
            }
        }
        .onAppear {
            startProgress()
            soundManager.playInitialSound()
        }
    }

    private func startProgress() {
        withAnimation(.easeInOut(duration: 2.0)) {
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

struct IconView_Previews: PreviewProvider {
    static var previews: some View {
        IconView()
            .environmentObject(AppState()) // Asegúrate de que AppState esté correctamente definido
    }
}
