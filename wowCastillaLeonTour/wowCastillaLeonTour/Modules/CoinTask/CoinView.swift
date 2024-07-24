//
//  CoinView.swift
//  wowCastillaLeonTour
//
//  Created by Markel Juaristi on 22/7/24.
//

import SwiftUI

struct CoinView: View {
    @ObservedObject var viewModel: CoinViewModel
    
    var body: some View {
        VStack {
            if viewModel.isLoading {
                Text("Cargando datos...")
            } else if let errorMessage = viewModel.errorMessage {
                Text("Error: \(errorMessage)")
            } else if let coin = viewModel.coins.first {
                VStack {
                    Text(coin.description)
                        .font(.title)
                        .padding()
                    
                    Text(coin.customMessage)
                        .font(.subheadline)
                        .padding()
                    
                    Text("Premio: \(coin.prize)")
                        .font(.headline)
                        .padding()
                }
            } else {
                Text("No hay datos disponibles")
            }
        }
        .padding()
    }
}

#Preview {
    CoinView(viewModel: CoinViewModel(activityId: "mockId"))
}
