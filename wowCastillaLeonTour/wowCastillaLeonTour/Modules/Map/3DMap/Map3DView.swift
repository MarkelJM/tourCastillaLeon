//
//  Map3DView.swift
//  wowCastillaLeonTour
//
//  Created by Markel Juaristi on 1/9/24.
//

import SwiftUI
import MapKit

struct Map3DView: UIViewRepresentable {
    @Binding var selectedSpot: Spot?
    @Binding var selectedReward: ChallengeReward?
    @ObservedObject var viewModel: Map3DViewModel

    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: Map3DView

        init(_ parent: Map3DView) {
            self.parent = parent
        }

        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            // Configurar la vista para cada anotación
            let annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "spot")
            annotationView.canShowCallout = true
            
            if let spotAnnotation = annotation as? UnifiedAnnotation {
                if let spot = spotAnnotation.spot, parent.viewModel.isTaskCompleted(spotID: spot.id) {
                    annotationView.markerTintColor = .green
                    annotationView.glyphImage = UIImage(systemName: "checkmark.circle.fill")
                } else if spotAnnotation.reward != nil {
                    annotationView.glyphImage = UIImage(systemName: "trophy.circle.fill")
                    annotationView.markerTintColor = .yellow
                } else {
                    annotationView.markerTintColor = .red
                }
            }

            return annotationView
        }

        func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
            if let annotation = view.annotation as? UnifiedAnnotation {
                if let spot = annotation.spot {
                    parent.selectedSpot = spot
                    parent.viewModel.focusOnAnnotation(annotation: annotation, mapView: mapView)
                } else if let reward = annotation.reward {
                    parent.selectedReward = reward
                    parent.viewModel.focusOnAnnotation(annotation: annotation, mapView: mapView)
                }
            }
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        
        // Configuración de la cámara 3D
        let camera = MKMapCamera(lookingAtCenter: viewModel.region.center, fromDistance: 1000, pitch: 80, heading: 0)
        mapView.setCamera(camera, animated: false)
        
        // Configuración del resto de propiedades del mapView
        mapView.showsUserLocation = true
        mapView.isPitchEnabled = true
        mapView.isRotateEnabled = true
        
        if let cameraBoundary = viewModel.cameraBoundary {
            mapView.setCameraBoundary(cameraBoundary, animated: false)
        }
        if let cameraZoomRange = viewModel.cameraZoomRange {
            mapView.setCameraZoomRange(cameraZoomRange, animated: false)
        }
        
        return mapView
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {
        uiView.removeAnnotations(uiView.annotations)
        uiView.addAnnotations(viewModel.mapAnnotations)
        
        // Actualizar la región cuando sea necesario
        uiView.setRegion(viewModel.region, animated: true)
    }
}

/*
import SwiftUI
import MapKit

struct Map3DView: UIViewRepresentable {
    @Binding var selectedSpot: Spot?
    @ObservedObject var viewModel: Map3DViewModel

    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: Map3DView

        init(_ parent: Map3DView) {
            self.parent = parent
        }

        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            let annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "spot")
            annotationView.canShowCallout = true
            annotationView.markerTintColor = .red

            if let spotAnnotation = annotation as? UnifiedAnnotation {
                if spotAnnotation.spot != nil {
                    annotationView.glyphText = "🟢"
                } else if spotAnnotation.reward != nil {
                    annotationView.glyphText = "🏆"
                }
            }

            return annotationView
        }

        func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
            if let annotation = view.annotation as? UnifiedAnnotation {
                if let spot = annotation.spot {
                    parent.selectedSpot = spot
                    parent.viewModel.mapView(mapView, didSelect: view)
                }
            }
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator

        // Configuración de la cámara 3D
        let camera = MKMapCamera(lookingAtCenter: viewModel.region.center, fromDistance: 1000, pitch: 60, heading: 0)
        mapView.setCamera(camera, animated: false)

        // Configuración del resto de propiedades del mapView
        mapView.showsUserLocation = true
        mapView.isPitchEnabled = true
        mapView.isRotateEnabled = true

        // Aplicar configuración específica de 3D
        if let boundary = viewModel.cameraBoundary {
            mapView.setCameraBoundary(boundary, animated: true)
        }
        if let zoomRange = viewModel.cameraZoomRange {
            mapView.setCameraZoomRange(zoomRange, animated: true)
        }

        return mapView
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {
        uiView.removeAnnotations(uiView.annotations)
        uiView.addAnnotations(viewModel.mapAnnotations)

        // Actualizar la región cuando sea necesario
        uiView.setRegion(viewModel.region, animated: true)
    }
}

 
 
 
 */

/*
import SwiftUI
import MapKit

struct Map3DView: View {
    @StateObject private var viewModel = MapViewModel(appState: AppState())
    @State private var selectedSpot: Spot?
    @State private var selectedReward: ChallengeReward?
    @EnvironmentObject var appState: AppState

    var body: some View {
        ZStack {
            Image("fondoSolar")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)

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
                    Map(coordinateRegion: $viewModel.region, showsUserLocation: true, annotationItems: viewModel.mapAnnotations) { annotation in
                        MapAnnotation(coordinate: annotation.coordinate) {
                            VStack {
                                if let reward = annotation.reward {
                                    Image(systemName: "trophy.circle.fill")
                                        .resizable()
                                        .foregroundColor(.yellow)
                                        .frame(width: 40, height: 40)
                                        .onTapGesture {
                                            selectedReward = reward
                                        }
                                } else if viewModel.isTaskCompleted(spotID: annotation.spot?.id ?? "") {
                                    Circle()
                                        .fill(Color.green)
                                        .frame(width: 30, height: 30)
                                        .overlay(
                                            Image(systemName: "checkmark")
                                                .foregroundColor(.white)
                                        )
                                        .onTapGesture {
                                            selectedSpot = annotation.spot
                                        }
                                } else {
                                    AsyncImage(url: URL(string: annotation.image)) { image in
                                        image
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 30, height: 30)
                                            .clipShape(Circle())
                                    } placeholder: {
                                        ProgressView()
                                    }
                                    .onTapGesture {
                                        selectedSpot = annotation.spot
                                    }
                                }
                            }
                        }
                    }
                    .onAppear {
                        viewModel.setup3DCamera()
                        viewModel.checkChallengeStatus()
                        if viewModel.isChallengeBegan {
                            viewModel.fetchSpots()
                        }
                    }
                    .sheet(item: $selectedSpot) { spot in
                        MapCallOutView(spot: spot, viewModel: viewModel)
                            .environmentObject(appState)
                    }
                    .sheet(item: $selectedReward) { reward in
                        CalloutRewardView(reward: reward, challenge: reward.challenge, viewModel: viewModel)
                            .environmentObject(appState)
                    }
                    Spacer()
                }
            }
            .padding(.bottom, 100)
            .padding()
        }
        .sheet(isPresented: $viewModel.showChallengeSelection) {
            ChallengeSelectionView(viewModel: viewModel)
        }
    }
}
*/
