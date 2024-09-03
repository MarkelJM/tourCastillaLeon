//
//  Map3DAnnotations.swift
//  wowCastillaLeonTour
//
//  Created by Markel Juaristi on 3/9/24.
//
/*
import MapboxMaps
import SwiftUI

class Map3DAnnotations {

    // Función para agregar una anotación personalizada en el mapa 3D
    static func addCustomAnnotation(mapView: MapView, coordinate: CLLocationCoordinate2D, imageName: String, allowOverlap: Bool = true) {
        let viewAnnotationOptions = ViewAnnotationOptions(
            geometry: Point(coordinate),
            allowOverlap: allowOverlap,
            anchor: .center
        )

        let annotationView = UIImageView(image: UIImage(systemName: imageName))
        annotationView.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        annotationView.contentMode = .scaleAspectFit

        do {
            try mapView.viewAnnotations.add(annotationView, options: viewAnnotationOptions)
        } catch {
            print("Error al agregar la anotación personalizada: \(error.localizedDescription)")
        }
    }
    
    // Función para manejar la interacción con las anotaciones en el mapa
    static func handleAnnotationInteraction(mapView: MapView, at point: CGPoint, viewModel: Map3DViewModel, selectedSpot: Binding<Spot?>) {
        for (view, options) in mapView.viewAnnotations.annotations {
            if view.frame.contains(point) {
                if let annotatedFeature = options.annotatedFeature as? Point { // Cambiado aquí
                    let newCamera = CameraOptions(center: annotatedFeature.coordinates, zoom: 14.0)
                    mapView.camera.ease(to: newCamera, duration: 1.5)
                    
                    if let selected = viewModel.spots.first(where: { $0.coordinates.latitude == annotatedFeature.coordinates.latitude && $0.coordinates.longitude == annotatedFeature.coordinates.longitude }) {
                        selectedSpot.wrappedValue = selected  // Actualiza la variable Binding para mostrar el Callout
                    }
                }
                break
            }
        }
    }
}
*/
