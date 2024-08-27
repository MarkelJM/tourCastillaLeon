//
//  MainTabView.swift
//  wowCastillaLeonTour
//
//  Created by Markel Juaristi on 16/8/24.
//

import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        TabView {
            
            // Lista de Desafíos (Challenges)
            ChallengeListView()
                .tabItem {
                    Image(systemName: "list.bullet")
                    Text("Desafíos")
                }
            
            // Mapa Tab
            MapView()
                .tabItem {
                    Image(systemName: "map")
                    Text("Mapa")
                }
            

            
            // Perfil Tab
            SettingProfileView()
                .tabItem {
                    Image(systemName: "person.crop.circle")
                    Text("Perfil")
                }
        }
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
            .environmentObject(AppState())
    }
}
