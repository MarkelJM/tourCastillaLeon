//
//  Map3DView.swift
//  wowCastillaLeonTour
//
//  Created by Markel Juaristi on 1/9/24.
//

import SwiftUI
import MapboxMaps

struct Map3DView: UIViewRepresentable {
    typealias UIViewType = MapView

    class Coordinator: NSObject {
        var parent: Map3DView

        init(_ parent: Map3DView) {
            self.parent = parent
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> MapView {
        let options = MapInitOptions(cameraOptions: CameraOptions(zoom: 12.0, bearing: -30.0, pitch: 60.0))
        let mapView = MapView(frame: CGRect.zero, mapInitOptions: options)

        // Configuración inicial del mapa 3D
        try? mapView.mapboxMap.loadStyleURI(.streets)
        
        // Configura el Map3DViewModel para manejar las anotaciones y la lógica del mapa cuando el mapa se carga
        mapView.mapboxMap.onEvery(event: .mapLoaded) { _ in
            context.coordinator.parent.configureMap3D(mapView: mapView)
        }

        return mapView
    }

    func updateUIView(_ uiView: MapView, context: Context) {
        // Aquí puedes actualizar la vista si es necesario
    }
}

// Extensión para la configuración del Map3D
extension Map3DView {
    func configureMap3D(mapView: MapView) {
        let viewModel = Map3DViewModel(appState: AppState())
        viewModel.configureMap3D(mapView: mapView)
    }
}
