//
//  PolicyView.swift
//  wowCastillaLeonTour
//
//  Created by Markel Juaristi on 27/8/24.
//

import SwiftUI

struct PolicyView: View {
    
    private let url = URL(string: "https://conquistacyl.wordpress.com")!
    
    var body: some View {
        ZStack {
            // Fondo de pantalla
            Image("fondoSolar")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            
            ScrollView {
                VStack(spacing: 20) {
                    Text("Términos y Condiciones")
                        .font(.largeTitle)
                        .foregroundColor(.mateGold)
                        .padding()
                    
                    // Aquí va la WebView que carga el enlace
                    WebView(url: url)
                        .frame(height: 400) // Ajusta el tamaño según sea necesario
                        .cornerRadius(10)
                        .padding(.horizontal)
                    
                    Spacer()
                }
                .background(Color.black.opacity(0.5))  // Fondo del VStack con transparencia
                .cornerRadius(20)
                .padding()
            }
        }
    }
}

#Preview {
    PolicyView()
}


