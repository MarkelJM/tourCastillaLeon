//
//  Map3DViewModel.swift
//  wowCastillaLeonTour
//
//  Created by Markel Juaristi on 1/9/24.
//

import Combine
import MapboxMaps

class Map3DViewModel: MapViewModel {
    @Published var mapView: MapView?

    override init(appState: AppState) {
        super.init(appState: appState)
    }

    func configureMap3D(mapView: MapView) {
        self.mapView = mapView
        
        // Configurar el estilo del mapa
        try? mapView.mapboxMap.loadStyleURI(.streets)

        // Añadir anotaciones 3D basadas en los spots
        addSpotsToMap3D(spots: spots)
    }

    func addSpotsToMap3D(spots: [Spot]) {
        guard let mapView = mapView else { return }
        
        var annotations = [PointAnnotation]()

        for spot in spots {
            let coordinates = CLLocationCoordinate2D(latitude: spot.coordinates.latitude, longitude: spot.coordinates.longitude)
            var annotation = PointAnnotation(coordinate: coordinates)
            
            // Configura la anotación según si el spot está completado o no
            if isTaskCompleted(spotID: spot.id) {
                annotation.image = .init(image: UIImage(systemName: "checkmark.circle.fill")!, name: "completedSpot")
            } else {
                annotation.image = .init(image: UIImage(named: spot.image)!, name: "spotImage")
            }
            
            annotations.append(annotation)
        }

        // Añadir anotaciones al mapa
        let annotationManager = mapView.annotations.makePointAnnotationManager()
        annotationManager.annotations = annotations
    }

    func handleTap(on annotation: PointAnnotation) {
        if let spot = spots.first(where: { $0.coordinates.latitude == annotation.coordinate.latitude && $0.coordinates.longitude == annotation.coordinate.longitude }) {
            print("Spot selected: \(spot.name)")
            // Lógica adicional, como mostrar un callout o cambiar la vista
        }
    }
}
