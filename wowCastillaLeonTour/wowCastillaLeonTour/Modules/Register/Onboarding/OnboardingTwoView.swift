//
//  OnboardingTwoView.swift
//  wowCastillaLeonTour
//
//  Created by Markel Juaristi on 23/8/24.
//

import SwiftUI

struct OnboardingTwoView: View {
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
                                appState.currentView = .onboardingOne
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
                        Text("Continuación de la historia")
                            .font(.title)
                            .foregroundColor(.mateGold)
                            .padding(.top, 40)
                        
                        Text("""
                            Aquí puedes continuar la historia o proporcionar más información sobre cómo utilizar la aplicación,
                            qué pueden esperar los usuarios y cómo pueden aprovechar al máximo las funciones disponibles.
                            """)
                            .font(.body)
                            .foregroundColor(.mateWhite)
                    }
                    .padding()
                }
                
                Spacer()
                
                Button(action: {
                    appState.currentView = .registerEmail
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
    OnboardingTwoView()
}
*/
