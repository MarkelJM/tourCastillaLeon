//
//  CustomTabBar.swift
//  wowCastillaLeonTour
//
//  Created by Markel Juaristi on 28/8/24.
//

import SwiftUI

struct CustomTabBar: View {
    @Binding var selectedTab: AppState.AppView

    var body: some View {
        HStack {
            Button(action: {
                selectedTab = .challengeList
            }) {
                VStack {
                    Image(systemName: "list.bullet")
                    Text("Desafíos")
                }
            }
            .frame(maxWidth: .infinity)
            
            Button(action: {
                selectedTab = .mapContainer
            }) {
                VStack {
                    Image(systemName: "map")
                    Text("Mapa")
                }
            }
            .frame(maxWidth: .infinity)
            
            
            Button(action: {
                selectedTab = .settings
            }) {
                VStack {
                    Image(systemName: "gearshape")
                    Text("Ajustes")
                }
            }
            .frame(maxWidth: .infinity)
        }
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
        .padding(.top, 200)
    }
}
