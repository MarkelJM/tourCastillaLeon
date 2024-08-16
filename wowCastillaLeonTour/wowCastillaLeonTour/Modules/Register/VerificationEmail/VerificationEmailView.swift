//
//  VerificationEmailView.swift
//  wowCastillaLeonTour
//
//  Created by Markel Juaristi on 11/6/24.
//

import SwiftUI

struct VerificationEmailView: View {
    @ObservedObject var viewModel: RegisterViewModel

    var body: some View {
        VStack {
            Text("¿Has verificado tu correo electrónico?")
                .padding()

            Button("OK") {
                viewModel.checkEmailVerification()
            }
            .padding()
        }
        .alert(isPresented: $viewModel.showError) {
            Alert(title: Text("Error"), message: Text(viewModel.errorMessage), dismissButton: .default(Text("OK")))
        }
    }
}

#Preview {
    VerificationEmailView(viewModel: RegisterViewModel())
}
