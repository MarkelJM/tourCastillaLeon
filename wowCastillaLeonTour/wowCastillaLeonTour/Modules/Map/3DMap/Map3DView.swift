//
//  Map3DView.swift
//  wowCastillaLeonTour
//
//  Created by Markel Juaristi on 1/9/24.
//

import SwiftUI
import MapboxMaps

struct Map3DView: UIViewRepresentable {

    func makeUIView(context: Context) -> MapView {
        let options = MapInitOptions(styleURI: .streets)
        let mapView = MapView(frame: .zero, mapInitOptions: options)
        return mapView
    }

    func updateUIView(_ uiView: MapView, context: Context) {
        // Aquí puedes actualizar el MapView si cambian las propiedades observadas
    }
}
