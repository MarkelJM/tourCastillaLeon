//
//  MapView.swift
//  wowCastillaLeonTour
//
//  Created by Markel Juaristi on 10/7/24.
//

import SwiftUI
import MapKit

struct MapView: View {
    @StateObject private var viewModel = MapViewModel()
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 42.340442, longitude: -3.703952),
        span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    )

    var body: some View {
        VStack {
            if let errorMessage = viewModel.errorMessage {
                Text("Error: \(errorMessage)")
                    .foregroundColor(.red)
            }
            Map(coordinateRegion: $region, annotationItems: viewModel.points) { point in
                MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: point.coordinates.latitude, longitude: point.coordinates.longitude)) {
                    VStack {
                        if let imageURL = URL(string: point.image) {
                            AsyncImage(url: imageURL) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 30, height: 30)
                                    .clipShape(Circle())
                            } placeholder: {
                                ProgressView()
                            }
                        } else {
                            ProgressView()
                        }
                        Text(point.title)
                            .font(.caption)
                            .padding(5)
                            .background(Color.white)
                            .cornerRadius(8)
                            .shadow(radius: 3)
                    }
                }
            }
            .onAppear {
                viewModel.fetchPoints()
            }
        }
    }
}

#Preview {
    MapView()
}

#Preview {
    MapView()
}
