//
//  QuestionAnswerView.swift
//  wowCastillaLeonTour
//
//  Created by Markel Juaristi on 22/7/24.
//

import SwiftUI

struct QuestionAnswerView: View {
    @ObservedObject var viewModel: QuestionAnswerViewModel
    
    var body: some View {
        VStack {
            if viewModel.isLoading {
                Text("Cargando datos...")
            } else if let errorMessage = viewModel.errorMessage {
                Text("Error: \(errorMessage)")
            } else if let questionAnswer = viewModel.questionAnswers.first {
                VStack {
                    Text(questionAnswer.question)
                        .font(.title)
                        .padding()
                    
                    ForEach(questionAnswer.options, id: \.self) { option in
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
    QuestionAnswerView(viewModel: QuestionAnswerViewModel(activityId: "mockId"))
}
