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
            // Fondo de pantalla
            Image("fondoSolar")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)

            VStack {
                Spacer()

                // Icono de la aplicación
                Image("iconoConquistaCyL")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .padding()

                Spacer()

                // Barra de progreso
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

        // Navegar al LoginView después de 1 segundo
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            appState.currentView = .login
        }
    }
}

#Preview {
    IconView()
        .environmentObject(AppState())
}
