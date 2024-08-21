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
            // Mapa Tab
            MapView()
                .tabItem {
                    Image(systemName: "map")
                    Text("Mapa")
                }
            
            // SpecialPrize
            SpecialPrizeListView()
                .tabItem {
                    Image(systemName: "star.fill")
                    Text("Premios Especiales")
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
