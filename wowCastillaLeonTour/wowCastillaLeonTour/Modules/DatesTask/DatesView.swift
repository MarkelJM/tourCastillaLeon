//
//  DatesView.swift
//  wowCastillaLeonTour
//
//  Created by Markel Juaristi on 22/7/24.
//

import SwiftUI

struct DatesOrderView: View {
    @StateObject var viewModel: DatesOrderViewModel
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        VStack {
            if viewModel.isLoading {
                Text("Cargando eventos...")
            } else if let errorMessage = viewModel.errorMessage {
                Text("Error: \(errorMessage)")
            } else if let dateEvent = viewModel.dateEvent {
                VStack(spacing: 20) {
                    Text(dateEvent.question)
                        .font(.title2)
                        .multilineTextAlignment(.center)
                    
                    ForEach(viewModel.shuffledOptions, id: \.self) { option in
                        Button(action: {
                            viewModel.selectEvent(option)
                        }) {
                            Text(option)
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(viewModel.selectedEvents.contains(option) ? Color.blue : Color.gray)
                                .cornerRadius(10)
                        }
                    }
                    
                    Button("Comprobar") {
                        viewModel.checkAnswer()
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                .padding()
                .sheet(isPresented: $viewModel.showResultAlert) {
                    ResultDatesOrderView(viewModel: viewModel)
                }
            } else {
                Text("No hay eventos disponibles")
            }
        }
        .onAppear {
            viewModel.fetchDateEvent()
        }
    }
}

struct ResultDatesOrderView: View {
    @ObservedObject var viewModel: DatesOrderViewModel
    
    var body: some View {
        VStack {
            Text(viewModel.alertMessage)
                .font(.title)
                .padding()

            Button("Continuar") {
                viewModel.showResultAlert = false
                // Aquí puedes añadir cualquier acción adicional, como navegar a otra vista
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .padding()
    }
}

struct DatesOrderView_Previews: PreviewProvider {
    static var previews: some View {
        DatesOrderView(viewModel: DatesOrderViewModel(activityId: "mockId"))
    }
}
