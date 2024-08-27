//
//  PolicyView.swift
//  wowCastillaLeonTour
//
//  Created by Markel Juaristi on 27/8/24.
//

import SwiftUI

struct PolicyView: View {
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
                    
                    Text("Aquí van los términos y condiciones...") // Reemplaza con el contenido real
                        .foregroundColor(.white)
                        .padding()
                    
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


