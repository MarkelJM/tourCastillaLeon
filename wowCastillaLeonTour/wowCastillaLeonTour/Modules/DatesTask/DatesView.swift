//
//  DatesView.swift
//  wowCastillaLeonTour
//
//  Created by Markel Juaristi on 22/7/24.
//

import SwiftUI

struct DatesView: View {
    @ObservedObject var viewModel: DatesViewModel
    
    var body: some View {
        VStack {
            if viewModel.isLoading {
                Text("Cargando datos...")
            } else if let errorMessage = viewModel.errorMessage {
                Text("Error: \(errorMessage)")
            } else if let dateEvent = viewModel.dates.first {
                VStack {
                    Text(dateEvent.question)
                        .font(.title)
                        .padding()
                    
                    ForEach(dateEvent.options, id: \.self) { option in
                        Text(option)
                            .padding()
                    }
                }
            } else {
                Text("No hay datos disponibles")
            }
        }
        .padding()
    }
}

#Preview {
    DatesView(viewModel: DatesViewModel(activityId: "mockId"))
}
