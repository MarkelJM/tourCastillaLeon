//
//  MainTabView.swift
//  wowCastillaLeonTour
//
//  Created by Markel Juaristi on 16/8/24.
//

import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var appState: AppState
    @State private var selectedTab: Int = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            // Lista de Desafíos (Challenges)
            ChallengeListView()
                .tabItem {
                    Image(systemName: "list.bullet")
                    Text("Desafíos")
                }
                .tag(0)
            
            // Mapa Tab
            MapView()
                .tabItem {
                    Image(systemName: "map")
                    Text("Mapa")
                }
                .tag(1)
            
            // Perfil Tab
            SettingProfileView()
                .tabItem {
                    Image(systemName: "person.crop.circle")
                    Text("Perfil")
                }
                .tag(2)
        }
        .onChange(of: appState.currentView) { newView in
            switch newView {
            case .map:
                selectedTab = 1
            case .challengeList:
                selectedTab = 0
            case .profile:
                selectedTab = 2
            default:
                break
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
