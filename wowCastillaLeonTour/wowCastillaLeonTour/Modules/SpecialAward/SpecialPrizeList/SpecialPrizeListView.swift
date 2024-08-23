//
//  SpecialPrizeListView.swift
//  wowCastillaLeonTour
//
//  Created by Markel Juaristi on 21/8/24.
//

import SwiftUI

struct SpecialPrizeListView: View {
    @StateObject var viewModel = SpecialPrizeListViewModel()
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
                    // Monedas y conteo dentro de un fondo negro con opacidad
                    HStack {
                        VStack(spacing: 10) {
                            HStack {
                                Text("\(viewModel.user?.coinTaskIDs.count ?? 0)")
                                    .font(.title)
                                    .foregroundColor(.mateGold)
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

                    // Lista de premios especiales
                    List(viewModel.specialPrizes) { prize in
                        HStack {
                            Image(prize.image)
                                .resizable()
                                .frame(width: 60, height: 60)
                            
                            Text(prize.province)
                                .font(.headline)
                                .foregroundColor(.mateWhite)  // Color blanco para mayor contraste
                                .padding(.leading, 16)
                            
                            Spacer()
                            
                            let completedTasks = viewModel.completedTasks(in: prize.province, for: viewModel.user!)
                            
                            Text("\(completedTasks) / \(prize.tasksAmount)")
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
                            let canProceed = viewModel.canAttemptSpecialTask(prize: prize)
                            if canProceed {
                                appState.currentView = .specialPrize(id: prize.id)
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
            viewModel.fetchSpecialPrizes()
            print("User Data: \(String(describing: viewModel.user))")
        }
        .alert(isPresented: $viewModel.showAlert) {
            Alert(
                title: Text("Atención"),
                message: Text(viewModel.alertMessage),
                primaryButton: .default(Text("Usar monedas")) {
                    if let prize = viewModel.specialPrizes.first(where: { $0.id == viewModel.selectedSpecialPrizeId }),
                       viewModel.useCoinsForTask(prize: prize) {
                        appState.currentView = .specialPrize(id: prize.id)
                    }
                },
                secondaryButton: .cancel(Text("Cancelar"))
            )
        }
    }
}

#Preview {
    SpecialPrizeListView()
        .environmentObject(AppState())
}
