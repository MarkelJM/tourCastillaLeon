//
//  AvatarSelectionView.swift
//  wowCastillaLeonTour
//
//  Created by Markel Juaristi on 15/7/24.
//

import SwiftUI

struct AvatarSelectionView: View {
    @Binding var selectedAvatar: Avatar
    @EnvironmentObject var appState: AppState

    var body: some View {
        VStack {
            Text("Selecciona tu Avatar")
                .font(.title)
                .padding()

            HStack {
                Button(action: {
                    selectedAvatar = .boy
                }) {
                    Image("normalMutila")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 150, height: 150)
                        .border(selectedAvatar == .boy ? Color.blue : Color.clear, width: 3)
                }

                Button(action: {
                    selectedAvatar = .girl
                }) {
                    Image("normalChica")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 150, height: 150)
                        .border(selectedAvatar == .girl ? Color.blue : Color.clear, width: 3)
                }
            }
            .padding()

            Button("Guardar y Continuar") {
                appState.currentView = .profile
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
    }
}

struct AvatarSelectionView_Previews: PreviewProvider {
    @State static var selectedAvatar: Avatar = .boy
    
    static var previews: some View {
        AvatarSelectionView(selectedAvatar: $selectedAvatar)
    }
}
