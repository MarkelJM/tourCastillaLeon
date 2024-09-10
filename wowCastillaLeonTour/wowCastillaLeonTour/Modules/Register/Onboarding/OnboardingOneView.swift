//
//  OnboardingOneView.swift
//  wowCastillaLeonTour
//
//  Created by Markel Juaristi on 23/8/24.
//

import SwiftUI

struct OnboardingOneView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        ZStack {
            Image("fondoSolar")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        HStack {
                            Button(action: {
                                appState.currentView = .login
                            }) {
                                Image(systemName: "chevron.left")
                                    .font(.headline)
                                    .padding()
                                    .background(Color.mateGold)
                                    .foregroundColor(.black)
                                    .cornerRadius(10)
                                    .padding(.top, 50)
                            }
                            Spacer()
                        }
                        VStack(alignment: .leading, spacing: 20) {
                            Text("Bienvenido a nuestra historia")
                                .font(.title)
                                .foregroundColor(.mateGold)
                                .padding(.top, 40)
                            
                            Text("""
                                Demuestra que no solo conoces los lugares más emblemáticos de Castilla y León sino que también su historia.
                                
                                ¡Vamos a la Conquista de CyL!
                                """)
                                .font(.body)
                                .foregroundColor(.mateWhite)
                        }
                        .padding()
                    }
                    

                    
                    
                }
                
                Spacer()
                
                Button(action: {
                    appState.currentView = .onboardingTwo
                }) {
                    Text("Continuar")
                        .padding()
                        .background(Color.mateRed)
                        .foregroundColor(.mateWhite)
                        .cornerRadius(10)
                        .padding(.bottom, 40)
                }
                Spacer()
            }
            .padding()
            .background(Color.black.opacity(0.6))  // Fondo con opacidad
            .cornerRadius(20)
            .padding()
        }
    }
}

/*
#Preview {
    OnboardingOneView()
}
*/
