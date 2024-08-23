//
//  TermsAndConditionsView.swift
//  wowCastillaLeonTour
//
//  Created by Markel Juaristi on 23/8/24.
//

import SwiftUI

struct TermsAndConditionsView: View {
    @EnvironmentObject var appState: AppState
    @Binding var agreeToTerms: Bool
    
    var body: some View {
        ZStack {
            // Fondo de pantalla
            Image("fondoSolar")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            
            ScrollView {
                VStack(spacing: 20) {
                    HStack {
                        Button(action: {
                            appState.currentView = .registerEmail
                        }) {
                            Image(systemName: "chevron.left")
                                .font(.headline)
                                .padding()
                                .background(Color.mateGold)
                                .foregroundColor(.black)
                                .cornerRadius(10)
                        }
                        Spacer()
                    }
                    .padding([.top, .leading], 20)
                    
                    Text("Términos y Condiciones")
                        .font(.largeTitle)
                        .foregroundColor(.mateGold)
                        .padding()
                    
                    Text("Aquí van los términos y condiciones...") // Reemplaza con el contenido real
                        .foregroundColor(.white)
                        .padding()
                    
                    Spacer()
                    
                    Button(action: {
                        agreeToTerms = true
                        appState.currentView = .registerEmail
                    }) {
                        Text("Aceptar")
                            .padding()
                            .background(Color.mateRed)
                            .foregroundColor(.mateWhite)
                            .cornerRadius(10)
                    }
                    .padding(.bottom, 50)
                }
                .background(Color.black.opacity(0.5))  // Fondo del VStack con transparencia
                .cornerRadius(20)
                .padding()
            }
        }
    }
}

#Preview {
    TermsAndConditionsView(agreeToTerms: .constant(false))
        .environmentObject(AppState())
}
