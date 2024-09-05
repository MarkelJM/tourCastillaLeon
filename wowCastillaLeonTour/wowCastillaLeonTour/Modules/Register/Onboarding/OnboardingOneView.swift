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
            // Fondo de pantalla
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
                                Aquí puedes contar la historia que desees sobre la aplicación.
                                Puedes incluir una descripción detallada y cualquier otra información relevante
                                que el usuario deba saber antes de comenzar su experiencia.
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
