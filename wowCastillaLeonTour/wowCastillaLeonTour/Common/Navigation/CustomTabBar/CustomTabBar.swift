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
                selectedTab = .map
            }) {
                VStack {
                    Image(systemName: "map")
                    Text("Mapa")
                }
            }
            .frame(maxWidth: .infinity)
            
            Button(action: {
                selectedTab = .profile
            }) {
                VStack {
                    Image(systemName: "person.crop.circle")
                    Text("Perfil")
                }
            }
            .frame(maxWidth: .infinity)
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
    }
}
