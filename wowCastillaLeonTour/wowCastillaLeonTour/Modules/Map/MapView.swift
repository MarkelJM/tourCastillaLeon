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
    
    var body: some View {
        VStack {
            if let errorMessage = viewModel.errorMessage {
                Text("Error: \(errorMessage)")
                    .foregroundColor(.red)
            } else if viewModel.authorizationStatus == .notDetermined {
                Text("Requesting location permissions...")
            } else if viewModel.authorizationStatus == .denied {
                Text("Location permissions denied.")
                    .foregroundColor(.red)
            } else {
                Map(coordinateRegion: $viewModel.region, showsUserLocation: true, annotationItems: viewModel.points) { point in
                    MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: point.coordinates.latitude, longitude: point.coordinates.longitude)) {
                        AsyncImage(url: URL(string: point.image)) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 30, height: 30)
                                .clipShape(Circle())
                        } placeholder: {
                            ProgressView()
                        }
                    }
                }
                .onAppear {
                    viewModel.fetchPoints()
                }
            }
        }
    }
}

#Preview {
    MapView()
        .environmentObject(AppState())
}
