//
//  TakePhotoView.swift
//  wowCastillaLeonTour
//
//  Created by Markel Juaristi on 22/7/24.
//

import SwiftUI

struct TakePhotoView: View {
    @ObservedObject var viewModel: TakePhotoViewModel
    
    var body: some View {
        VStack {
            if viewModel.isLoading {
                Text("Cargando datos...")
            } else if let errorMessage = viewModel.errorMessage {
                Text("Error: \(errorMessage)")
            } else {
                Text("Datos cargados correctamente")
                // Añade aquí la lógica de tu vista
            }
        }
        .padding()
    }
}

#Preview {
    TakePhotoView(viewModel: TakePhotoViewModel(activityId: "mockId"))
}
