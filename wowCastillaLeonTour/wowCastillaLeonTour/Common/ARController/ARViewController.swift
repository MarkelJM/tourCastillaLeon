//
//  ARViewController.swift
//  wowCastillaLeonTour
//
//  Created by Markel Juaristi on 21/8/24.
//


import Foundation
import ARKit
import RealityKit
import SwiftUI

struct ARViewContainer<VM: BaseViewModel>: UIViewRepresentable {
    var prizeImageName: String
    var viewModel: VM
    
    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        
        #if !targetEnvironment(simulator)
        // Configurar la sesión AR solo en un dispositivo real
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal]
        arView.session.run(configuration)
        
        // Configurar la escena AR
        setupARScene(arView: arView, context: context)
        
        // Configurar el reconocimiento de gestos
        let tapGesture = UITapGestureRecognizer(target: context.coordinator, action: #selector(context.coordinator.handleTap(_:)))
        arView.addGestureRecognizer(tapGesture)
        #endif
        
        return arView
    }
    /*
    func setupARScene(arView: ARView, context: Context) {
        #if !targetEnvironment(simulator)
        // Crear una entidad ancla para el plano horizontal
        let anchorEntity = AnchorEntity(plane: .horizontal, minimumBounds: .zero)
        
        // Cargar la imagen desde los assets
        guard let image = UIImage(named: prizeImageName) else {
            print("Imagen no encontrada: \(prizeImageName)")
            return
        }
        
        var material = SimpleMaterial()
        let mesh = MeshResource.generatePlane(width: 0.5, height: 0.5) // Aumentar o disminuir según sea necesario
        let modelEntity = ModelEntity(mesh: mesh, materials: [material])
        
        // Aplicar la imagen como una textura
        if let texture = try? TextureResource.generate(from: image.cgImage!, options: .init(semantic: nil)) {
            material.baseColor = MaterialColorParameter.texture(texture)
            modelEntity.model?.materials = [material]  // Reasignar el material con la textura aplicada
        } else {
            print("Error al crear la textura")
        }
        
        // Colocar la entidad a 1 metro de la cámara (ajustar la posición si es necesario)
        modelEntity.position = [0, 0, -1]
        
        // Generar colisiones para la entidad para permitir la interacción con gestos
        modelEntity.generateCollisionShapes(recursive: true)
        
        // Añadir la entidad al ancla
        anchorEntity.addChild(modelEntity)
        
        // Añadir el ancla al ARView
        arView.scene.addAnchor(anchorEntity)
        
        // Almacenar la entidad actual en el coordinador para su manejo
        context.coordinator.currentEntity = modelEntity
        #endif
    }
     */
    
    func setupARScene(arView: ARView, context: Context) {
        #if !targetEnvironment(simulator)
        // Crear una entidad ancla para el plano horizontal
        let anchorEntity = AnchorEntity(plane: .horizontal, minimumBounds: .zero)
        
        // Cargar la imagen desde los assets
        guard let image = UIImage(named: prizeImageName) else {
            print("Imagen no encontrada: \(prizeImageName)")
            return
        }
        
        // Crear el material UnlitMaterial para manejar la transparencia
        var material = UnlitMaterial()
        
        // Generar el mesh de un plano
        let mesh = MeshResource.generatePlane(width: 0.5, height: 0.5)
        let modelEntity = ModelEntity(mesh: mesh)
        
        // Aplicar la imagen como una textura con transparencia
        if let cgImage = image.cgImage, let texture = try? TextureResource.generate(from: cgImage, options: .init(semantic: nil)) {
            material.baseColor = MaterialColorParameter.texture(texture)
            modelEntity.model?.materials = [material]
        } else {
            print("Error al crear la textura")
        }

        // Colocar la entidad a 1 metro de la cámara
        modelEntity.position = [0, 0, -1]
        
        // Generar colisiones para la entidad para permitir la interacción con gestos
        modelEntity.generateCollisionShapes(recursive: true)
        
        // Añadir la entidad al ancla
        anchorEntity.addChild(modelEntity)
        
        // Añadir el ancla al ARView
        arView.scene.addAnchor(anchorEntity)
        
        // Almacenar la entidad actual en el coordinador para su manejo
        context.coordinator.currentEntity = modelEntity
        #endif
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self, viewModel: viewModel)
    }
    
    class Coordinator: NSObject {
        var parent: ARViewContainer
        var currentEntity: ModelEntity?
        var viewModel: VM
        
        init(_ parent: ARViewContainer, viewModel: VM) {
            self.parent = parent
            self.viewModel = viewModel
        }
        
        @objc func handleTap(_ sender: UITapGestureRecognizer) {
            #if !targetEnvironment(simulator)
            guard let arView = sender.view as? ARView else { return }
            let tapLocation = sender.location(in: arView)
            
            if let tappedEntity = arView.entity(at: tapLocation), tappedEntity == currentEntity {
                currentEntity?.removeFromParent()
                
                if let specialPrizeViewModel = viewModel as? SpecialPrizeTaskViewModel {
                    specialPrizeViewModel.completeSpecialTask()
                } else if let coinViewModel = viewModel as? CoinViewModel {
                    if let coin = coinViewModel.coins.first {
                        coinViewModel.completeTask(coin: coin)
                    }
                }
            }
            #endif
        }
    }
}

/*
struct ARViewContainer<VM: BaseViewModel>: UIViewRepresentable {
    var prizeImageName: String
    var viewModel: VM
    
    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        
        // Configurar la sesión AR
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal]
        arView.session.run(configuration)
        
        // Configurar la escena AR
        setupARScene(arView: arView, context: context)
        
        // Configurar el reconocimiento de gestos
        let tapGesture = UITapGestureRecognizer(target: context.coordinator, action: #selector(context.coordinator.handleTap(_:)))
        arView.addGestureRecognizer(tapGesture)
        
        return arView
    }
    
    func setupARScene(arView: ARView, context: Context) {
        // Crear una entidad ancla para el plano horizontal
        let anchorEntity = AnchorEntity(plane: .horizontal)
        
        // Cargar la imagen desde los assets
        guard let image = UIImage(named: prizeImageName) else {
            print("Imagen no encontrada: \(prizeImageName)")
            return
        }
        
        var material = SimpleMaterial()
        let mesh = MeshResource.generatePlane(width: 0.5, height: 0.5) // Aumentar o disminuir según sea necesario
        let modelEntity = ModelEntity(mesh: mesh, materials: [material])
        
        // Aplicar la imagen como una textura
        if let texture = try? TextureResource.generate(from: image.cgImage!, options: .init(semantic: nil)) {
            material.baseColor = MaterialColorParameter.texture(texture)
            modelEntity.model?.materials = [material]  // Reasignar el material con la textura aplicada
        } else {
            print("Error al crear la textura")
        }
        
        // Colocar la entidad a 1 metro de la cámara (ajustar la posición si es necesario)
        modelEntity.position = [0, 0, -1]
        
        // Generar colisiones para la entidad para permitir la interacción con gestos
        modelEntity.generateCollisionShapes(recursive: true)
        
        // Añadir la entidad al ancla
        anchorEntity.addChild(modelEntity)
        
        // Añadir el ancla al ARView
        arView.scene.addAnchor(anchorEntity)
        
        // Almacenar la entidad actual en el coordinador para su manejo
        context.coordinator.currentEntity = modelEntity
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
    
    // Crear un Coordinador para manejar los gestos y el botón "Atrás"
    func makeCoordinator() -> Coordinator {
        Coordinator(self, viewModel: viewModel)
    }
    
    class Coordinator: NSObject {
        var parent: ARViewContainer
        var currentEntity: ModelEntity?
        var viewModel: VM
        
        init(_ parent: ARViewContainer, viewModel: VM) {
            self.parent = parent
            self.viewModel = viewModel
        }
        
        @objc func handleTap(_ sender: UITapGestureRecognizer) {
            guard let arView = sender.view as? ARView else { return }
            let tapLocation = sender.location(in: arView)
            
            // Buscar la entidad que fue tocada
            if let tappedEntity = arView.entity(at: tapLocation), tappedEntity == currentEntity {
                currentEntity?.removeFromParent()
                
                // Completar la tarea específica
                if let specialPrizeViewModel = viewModel as? SpecialPrizeTaskViewModel {
                    specialPrizeViewModel.completeSpecialTask()
                } else if let coinViewModel = viewModel as? CoinViewModel {
                    if let coin = coinViewModel.coins.first {
                        coinViewModel.completeTask(coin: coin)
                    }
                }
            }
        }
    }
}
*/


/*
 //FUNCIONA PERFECTAMENTE CON COIN
struct ARViewContainer: UIViewRepresentable {
    var prizeImageName: String
    var viewModel: CoinViewModel
    
    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        
        // Configurar la sesión AR
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal]
        arView.session.run(configuration)
        
        // Configurar la escena AR
        setupARScene(arView: arView, context: context)
        
        // Configurar el reconocimiento de gestos
        let tapGesture = UITapGestureRecognizer(target: context.coordinator, action: #selector(context.coordinator.handleTap(_:)))
        arView.addGestureRecognizer(tapGesture)
        
        return arView
    }
    
    func setupARScene(arView: ARView, context: Context) {
        // Crear una entidad ancla para el plano horizontal
        let anchorEntity = AnchorEntity(plane: .horizontal)
        
        // Cargar la imagen desde los assets
        guard let image = UIImage(named: prizeImageName) else {
            print("Imagen no encontrada: \(prizeImageName)")
            return
        }
        
        var material = SimpleMaterial()
        let mesh = MeshResource.generatePlane(width: 0.5, height: 0.5) // Aumentar el tamaño del plano
        let modelEntity = ModelEntity(mesh: mesh, materials: [material])
        
        // Aplicar la imagen como una textura
        if let texture = try? TextureResource.generate(from: image.cgImage!, options: .init(semantic: nil)) {
            material.baseColor = MaterialColorParameter.texture(texture)
            modelEntity.model?.materials = [material]  // Reasignar el material con la textura aplicada
        } else {
            print("Error al crear la textura")
        }
        
        // Colocar la moneda a 1 metro de la cámara (ajustar la posición si es necesario)
        modelEntity.position = [0, 0, -1]
        
        // Generar colisiones para la entidad para permitir la interacción con gestos
        modelEntity.generateCollisionShapes(recursive: true)
        
        // Añadir la entidad al ancla
        anchorEntity.addChild(modelEntity)
        
        // Añadir el ancla al ARView
        arView.scene.addAnchor(anchorEntity)
        
        // Almacenar la entidad actual en el coordinador para su manejo
        context.coordinator.currentEntity = modelEntity
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
    
    // Crear un Coordinador para manejar los gestos y el botón "Atrás"
    func makeCoordinator() -> Coordinator {
        Coordinator(self, viewModel: viewModel)
    }
    
    class Coordinator: NSObject {
        var parent: ARViewContainer
        var currentEntity: ModelEntity?
        var viewModel: CoinViewModel
        
        init(_ parent: ARViewContainer, viewModel: CoinViewModel) {
            self.parent = parent
            self.viewModel = viewModel
        }
        
        @objc func handleTap(_ sender: UITapGestureRecognizer) {
            guard let arView = sender.view as? ARView else { return }
            let tapLocation = sender.location(in: arView)
            
            // Buscar la entidad que fue tocada
            if let tappedEntity = arView.entity(at: tapLocation), tappedEntity == currentEntity {
                currentEntity?.removeFromParent()
                
                // Completar la tarea y mostrar el mensaje del coin
                if let coin = viewModel.coins.first {
                    viewModel.completeTask(coin: coin)
                }
            }
        }
    }
}

*/
