//
//  TermsAndConditionsView.swift
//  wowCastillaLeonTour
//
//  Created by Markel Juaristi on 23/8/24.
//

import SwiftUI
import Combine

struct TermsAndConditionsView: View {
    @EnvironmentObject var appState: AppState
    @Binding var agreeToTerms: Bool
    private let url = URL(string: "https://conquistacyl.wordpress.com")!
    
    var body: some View {
        ZStack {
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
                    
                    // Aquí va la WebView que carga el enlace
                    WebView(url: url)
                        .frame(height: 400)
                        .cornerRadius(10)
                        .padding(.horizontal)
                    
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
                .background(Color.black.opacity(0.5))  
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
