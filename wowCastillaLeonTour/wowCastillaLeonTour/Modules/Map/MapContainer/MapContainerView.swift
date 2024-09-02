//
//  MapContainerView.swift
//  wowCastillaLeonTour
//
//  Created by Markel Juaristi on 2/9/24.
//

import SwiftUI

import SwiftUI

struct MapContainerView: View {
    @State private var is3DView = false
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            if is3DView {
                Map3DView()
                    .edgesIgnoringSafeArea(.all)
            } else {
                Map2DView()
                    .edgesIgnoringSafeArea(.all)
            }
            
            Button(action: {
                is3DView.toggle()
            }) {
                Text(is3DView ? "Cambiar a 2D" : "Cambiar a 3D")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .clipShape(Circle())
                    .shadow(radius: 10)
                    .padding(.bottom, 50) // Ajusta para que no esté pegado al borde
                    .padding(.trailing, 20) // Ajusta para que no esté pegado al borde
            }
        }
    }
}

