//
//  MapCallOut.swift
//  wowCastillaLeonTour
//
//  Created by Markel Juaristi on 12/7/24.
//

import SwiftUI

struct MapCallOutView: View {
    var point: Point

    var body: some View {
        VStack(spacing: 20) {
            Text(point.name)
                .font(.title2)
                .fontWeight(.bold)

            AsyncImage(url: URL(string: point.image)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 200)
                    .cornerRadius(10)
            } placeholder: {
                ProgressView()
            }

            Button(action: {
                print("Participar button tapped for \(point.name)")
            }) {
                Text("Participar")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }

            Spacer()
        }
        .padding()
    }
}
/*
#Preview {
    MapCallOutView(point: <#Point#>)
}
*/
