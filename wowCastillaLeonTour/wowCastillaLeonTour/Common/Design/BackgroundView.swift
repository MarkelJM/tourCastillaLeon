//
//  BackgroundView.swift
//  wowCastillaLeonTour
//
//  Created by Markel Juaristi on 16/7/24.
//

import SwiftUI

struct GradientBackgroundView: View {
    var body: some View {
        LinearGradient(gradient: Gradient(colors: [Color.mateRed, Color.mateWhite]), startPoint: .topLeading, endPoint: .bottomTrailing)
            .edgesIgnoringSafeArea(.all)
    }
}

struct MultiColorGradientBackgroundView: View {
    var body: some View {
        LinearGradient(gradient: Gradient(colors: [Color.mateRed, Color.mateWhite, Color.gray]), startPoint: .topLeading, endPoint: .bottomTrailing)
            .edgesIgnoringSafeArea(.all)
    }
}
/*
struct BackgroundExamplesView: View {
    var body: some View {
        VStack(spacing: 20) {
            GradientBackgroundView()
            //MultiColorGradientBackgroundView()
        }
    }
}

struct BackgroundExamplesView_Previews: PreviewProvider {
    static var previews: some View {
        BackgroundExamplesView()
    }
}
*/
