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
        VStack {
            if viewModel.isUserLoaded {
                HStack {
                    Text("\(viewModel.user?.coinTaskIDs.count ?? 0)")
                        .font(.title)
                    Image("coin")
                        .resizable()
                        .frame(width: 30, height: 30)
                }
                .padding(.trailing, 16)
                .frame(maxWidth: .infinity, alignment: .trailing)
                
                List(viewModel.specialPrizes) { prize in
                    HStack {
                        Image(prize.image)
                            .resizable()
                            .frame(width: 50, height: 50)
                        
                        Text(prize.province)
                            .font(.headline)
                            .padding(.leading, 16)
                        
                        Spacer()
                        
                        let completedTasks = viewModel.completedTasks(in: prize.province, for: viewModel.user!)
                        
                        Text("\(completedTasks) / \(prize.tasksAmount)")
                            .font(.subheadline)
                            .padding(.trailing, 16)
                    }
                    .onTapGesture {
                        let canProceed = viewModel.canAttemptSpecialTask(prize: prize)
                        if canProceed {
                            appState.currentView = .specialPrize(id: prize.id)
                        }
                    }
                }
            } else {
                Text("Cargando datos...")
                    .font(.title)
            }
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
}
