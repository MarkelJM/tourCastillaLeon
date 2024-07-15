//
//  AvatarSelectionView.swift
//  wowCastillaLeonTour
//
//  Created by Markel Juaristi on 15/7/24.
//

import SwiftUI

struct AvatarSelectionView: View {
    @Binding var selectedAvatar: Avatar

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
                        .frame(width: 100, height: 100) // Ajustar tamaño
                        .clipShape(Circle())
                        .overlay(
                            Circle().stroke(selectedAvatar == .boy ? Color.blue : Color.clear, lineWidth: 4)
                        )
                        .shadow(radius: selectedAvatar == .boy ? 10 : 0)
                }

                Button(action: {
                    selectedAvatar = .girl
                }) {
                    Image("normalChica")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 100) // Ajustar tamaño
                        .clipShape(Circle())
                        .overlay(
                            Circle().stroke(selectedAvatar == .girl ? Color.blue : Color.clear, lineWidth: 4)
                        )
                        .shadow(radius: selectedAvatar == .girl ? 10 : 0)
                }
            }
            .padding()
        }
        .padding()
        .background(Color.gray.opacity(0.2))
        .cornerRadius(10) // Bordes redondeados para la vista
    }
}

struct AvatarSelectionView_Previews: PreviewProvider {
    @State static var selectedAvatar: Avatar = .boy
    
    static var previews: some View {
        AvatarSelectionView(selectedAvatar: $selectedAvatar)
    }
}
