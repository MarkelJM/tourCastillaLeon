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
        ZStack {
            Image("fondoSolar")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)

            VStack(spacing: 20) {
                Text("¿Has verificado tu correo electrónico?")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.mateGold)
                    .padding(.top, 50)

                redBackgroundButton(title: "OK") {
                    viewModel.checkEmailVerification()
                }
                .padding(.bottom, 50)

                if viewModel.showError {
                    Text(viewModel.errorMessage)
                        .foregroundColor(.red)
                        .padding()
                }
            }
            .background(Color.black.opacity(0.5))
            .cornerRadius(20)
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
