//
//  ChallengeListView.swift
//  wowCastillaLeonTour
//
//  Created by Markel Juaristi on 24/8/24.
//

import SwiftUI

struct ChallengeListView: View {
    @StateObject var viewModel = ChallengeListViewModel()
    @EnvironmentObject var appState: AppState

    var body: some View {
        ZStack {
            Image("fondoSolar")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                // Título "Retos"
                Text("Retos")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.mateGold)
                    .padding(.top, 40) // Añadido un padding superior para separar el título del borde superior

                if viewModel.isUserLoaded {
                    List(viewModel.challenges) { challenge in
                        HStack {
                            AsyncImage(url: URL(string: challenge.image)) { image in
                                image
                                    .resizable()
                                    .frame(width: 60, height: 60)
                            } placeholder: {
                                // Imagen predeterminada en caso de que la URL sea inválida
                                Image(systemName: "photo")
                                    .resizable()
                                    .frame(width: 60, height: 60)
                            }

                            Text(challenge.challengeTitle)
                                .font(.headline)
                                .foregroundColor(.mateWhite)  // Color blanco para mayor contraste
                                .padding(.leading, 16)

                            Spacer()

                            let completedTasks = viewModel.completedTasks(for: challenge.challengeName)

                            Text("\(completedTasks) / \(challenge.taskAmount)")
                                .font(.subheadline)
                                .foregroundColor(.mateWhite)
                                .padding(.trailing, 16)
                        }
                        .padding()
                        .background(Color.gray)  // Fondo gris oscuro con mayor transparencia
                        .cornerRadius(20) // Aumento del tamaño del radio de las esquinas
                        .padding(.vertical, 8) // Incremento de padding vertical
                        .padding(.horizontal, 5) // Añadido padding horizontal para hacer las celdas más grandes
                        .onTapGesture {
                            viewModel.selectChallenge(challenge)

                            if viewModel.isChallengeAlreadyBegan(challengeName: challenge.challengeName) {
                                appState.currentView = .map
                            } else {
                                appState.currentView = .challengePresentation(challengeName: challenge.challengeName)
                            }
                        }
                    }
                    .listStyle(PlainListStyle())
                    .background(Color.black.opacity(0.2))
                    .cornerRadius(20)
                } else {
                    Text("Cargando datos...")
                        .font(.title)
                        .foregroundColor(.mateWhite)
                }
            }
            .padding()
            .background(Color.black.opacity(0.7))
            .cornerRadius(20)
            .padding(.top, 70)
        }
        .onAppear {
            print("Fetching challenges on appear")
            viewModel.fetchChallenges()
        }
        .alert(isPresented: $viewModel.showAlert) {
            Alert(
                title: Text("Atención"),
                message: Text(viewModel.alertMessage),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}

#Preview {
    ChallengeListView()
        .environmentObject(AppState())
}


/*
import SwiftUI

struct ChallengeListView: View {
    @StateObject var viewModel = ChallengeListViewModel()
    @EnvironmentObject var appState: AppState

    var body: some View {
        ZStack {
            // Fondo de pantalla
            Image("fondoSolar")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                if viewModel.isUserLoaded {
                    /*
                    // Monedas y conteo dentro de un fondo negro con opacidad
                    HStack {
                        VStack(spacing: 10) {
                            HStack {
                                /*
                                Text("\(viewModel.user?.coinTaskIDs.count ?? 0)")
                                    .font(.title)
                                    .foregroundColor(.mateGold)
                                 */
                                Image("coin")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                            }
                        }
                        .padding(10)
                        .background(Color.black.opacity(0.2)) // Fondo negro con baja opacidad
                        .cornerRadius(10)
                    }
                    .padding(.top, 40)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                     */

                    // Lista de challenges
                    List(viewModel.challenges) { challenge in
                        HStack {
                            AsyncImage(url: URL(string: challenge.image)) { image in
                                image
                                    .resizable()
                                    .frame(width: 60, height: 60)
                            } placeholder: {
                                ProgressView()
                                    .frame(width: 60, height: 60)
                            }

                            Text(challenge.challengeTitle)
                                .font(.headline)
                                .foregroundColor(.mateWhite)  // Color blanco para mayor contraste
                                .padding(.leading, 16)
                            
                            Spacer()
                            
                            let completedTasks = viewModel.completedTasks(for: challenge.challengeName)
                            
                            Text("\(completedTasks) / \(challenge.taskAmount)")
                                .font(.subheadline)
                                .foregroundColor(.mateWhite)
                                .padding(.trailing, 16)
                        }
                        .padding()
                        .background(Color.gray)  // Fondo gris oscuro con mayor transparencia
                        .cornerRadius(20) // Aumento del tamaño del radio de las esquinas
                        .padding(.vertical, 8) // Incremento de padding vertical
                        .padding(.horizontal, 5) // Añadido padding horizontal para hacer las celdas más grandes
                        .onTapGesture {
                            viewModel.selectChallenge(challenge)
                            
                            if viewModel.isChallengeAlreadyBegan(challengeName: challenge.challengeName) {
                                appState.currentView = .map
                            } else {
                                appState.currentView = .challengePresentation(challengeName: challenge.challengeName)
                            }
                        }
                    }
                    .listStyle(PlainListStyle()) // Ajuste de estilo para la lista
                    .background(Color.black.opacity(0.2)) // Fondo de la lista con opacidad baja
                    .cornerRadius(20)
                } else {
                    Text("Cargando datos...")
                        .font(.title)
                        .foregroundColor(.mateWhite)
                }
            }
            .padding()
            .background(Color.black.opacity(0.7)) // Fondo del VStack principal con baja opacidad
            .cornerRadius(20)
        }
        .onAppear {
            viewModel.fetchChallenges()
        }
        .alert(isPresented: $viewModel.showAlert) {
            Alert(
                title: Text("Atención"),
                message: Text(viewModel.alertMessage),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}
 
 */

#Preview {
    ChallengeListView()
        .environmentObject(AppState())
}
