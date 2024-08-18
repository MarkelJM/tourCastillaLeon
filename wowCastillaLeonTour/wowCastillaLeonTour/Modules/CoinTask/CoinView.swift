//
//  CoinView.swift
//  wowCastillaLeonTour
//
//  Created by Markel Juaristi on 22/7/24.
//

import SwiftUI
import ARKit
import RealityKit

struct CoinView: View {
    @ObservedObject var viewModel: CoinViewModel
    
    var body: some View {
        VStack {
            if viewModel.isLoading {
                Text("Cargando datos...")
            } else if let errorMessage = viewModel.errorMessage {
                Text("Error: \(errorMessage)")
            } else if let coin = viewModel.coins.first {
                ARViewContainer(prizeImageName: coin.prize)
                    .edgesIgnoringSafeArea(.all)
            } else {
                Text("No hay datos disponibles")
            }
        }
        .padding()
    }
}

struct ARViewContainer: UIViewRepresentable {
    var prizeImageName: String
    
    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        
        // Configurar la sesión AR
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal]
        arView.session.run(configuration)
        
        // Crear una entidad ancla para el plano horizontal
        let anchorEntity = AnchorEntity(.plane(.horizontal, classification: .any, minimumBounds: [0.2, 0.2]))

        // Cargar la imagen desde los assets
        if let image = UIImage(named: prizeImageName) {
            var material = SimpleMaterial()
            let mesh = MeshResource.generatePlane(width: 0.2, height: 0.2)
            let modelEntity = ModelEntity(mesh: mesh, materials: [material])
            
            // Aplicar la imagen como una textura
            if let texture = try? TextureResource.generate(from: image.cgImage!, options: .init(semantic: nil)) {
                material.baseColor = MaterialColorParameter.texture(texture)
            }
            
            // Añadir la entidad al ancla
            anchorEntity.addChild(modelEntity)
        }
        
        // Añadir el ancla al ARView
        arView.scene.addAnchor(anchorEntity)
        
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
}

#Preview {
    CoinView(viewModel: CoinViewModel(activityId: "mockId"))
}
