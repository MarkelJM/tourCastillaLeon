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
            guard !(annotation is MKUserLocation) else {
                return nil  // Dejar que el MKMapView maneje la ubicación del usuario por defecto
            }

            let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "spot")
            annotationView.canShowCallout = true

            if let spotAnnotation = annotation as? UnifiedAnnotation {
                if let spot = spotAnnotation.spot, parent.viewModel.isTaskCompleted(spotID: spot.id) {
                    // Crear un círculo verde con un checkmark blanco
                    let checkmarkView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
                    checkmarkView.layer.cornerRadius = 15
                    checkmarkView.backgroundColor = .systemGreen

                    let checkmarkImageView = UIImageView(image: UIImage(systemName: "checkmark"))
                    checkmarkImageView.tintColor = .white
                    checkmarkImageView.frame = CGRect(x: 5, y: 5, width: 20, height: 20)
                    checkmarkView.addSubview(checkmarkImageView)

                    // Renderizar la vista personalizada como una imagen
                    UIGraphicsBeginImageContextWithOptions(checkmarkView.bounds.size, false, 0.0)
                    checkmarkView.layer.render(in: UIGraphicsGetCurrentContext()!)
                    let checkmarkImage = UIGraphicsGetImageFromCurrentImageContext()
                    UIGraphicsEndImageContext()

                    annotationView.image = checkmarkImage
                } else if let imageURL = URL(string: spotAnnotation.image) {
                    // Cargar la imagen de forma asíncrona
                    DispatchQueue.global().async {
                        if let imageData = try? Data(contentsOf: imageURL), let image = UIImage(data: imageData) {
                            DispatchQueue.main.async {
                                annotationView.image = image
                                annotationView.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
                                annotationView.layer.cornerRadius = 15
                                annotationView.layer.masksToBounds = true
                            }
                        }
                    }
                } else if spotAnnotation.reward != nil {
                    let trophyImage = UIImage(systemName: "trophy.circle.fill")?.withRenderingMode(.alwaysTemplate)
                    annotationView.image = trophyImage
                    annotationView.tintColor = .yellow
                    annotationView.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
                } else {
                    let defaultImage = UIImage(systemName: "mappin.circle.fill")?.withRenderingMode(.alwaysTemplate)
                    annotationView.image = defaultImage
                    annotationView.tintColor = .red
                    annotationView.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
                }
            }

            return annotationView
        }

        func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
            if let annotation = view.annotation as? UnifiedAnnotation {
                if let spot = annotation.spot {
                    print("Annotation selected for spot: \(spot.name)")
                    parent.selectedSpot = spot
                    parent.viewModel.focusOnAnnotation(annotation: annotation, mapView: mapView)
                } else if let reward = annotation.reward {
                    print("Annotation selected for reward: \(reward.challengeTitle)")
                    parent.selectedReward = reward
                    parent.viewModel.focusOnAnnotation(annotation: annotation, mapView: mapView)
                }
            } else {
                print("Annotation selected: \(String(describing: view.annotation?.coordinate))")
            }
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> MKMapView {
        print("Creating MKMapView...")
        let mapView = MKMapView()
        mapView.delegate = context.coordinator

        // Configuración de la cámara 3D con un ángulo pronunciado para mostrar los edificios
        let camera = MKMapCamera(lookingAtCenter: viewModel.region.center, fromDistance: 600, pitch: 75, heading: 0)
        mapView.setCamera(camera, animated: false)

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
        print("Updating MKMapView with new annotations...")
        uiView.removeAnnotations(uiView.annotations)
        uiView.addAnnotations(viewModel.mapAnnotations)
        uiView.setRegion(viewModel.region, animated: true)
        let updatedCamera = MKMapCamera(lookingAtCenter: viewModel.region.center, fromDistance: 1000, pitch: 60, heading: 0)
        uiView.setCamera(updatedCamera, animated: true)
    }
}

