//
//  ARViewController.swift
//  wowCastillaLeonTour
//
//  Created by Markel Juaristi on 21/8/24.
//

import SwiftUI
import ARKit
import RealityKit

struct ARViewContainer<VM: BaseViewModel>: UIViewRepresentable {
    var prizeImageName: String
    var viewModel: VM

    func makeUIView(context: Context) -> UIView {
        #if targetEnvironment(simulator)
        // Simulador: Mostrar una vista vacía o un mensaje indicando que AR no está disponible
        let placeholderView = UIView()
        placeholderView.backgroundColor = .gray
        let label = UILabel()
        label.text = "AR no disponible en el simulador"
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        placeholderView.addSubview(label)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: placeholderView.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: placeholderView.centerYAnchor)
        ])
        return placeholderView
        #else
        // Dispositivo: Crear la vista AR real
        let arView = ARView(frame: .zero)
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal]
        arView.session.run(configuration)
        
        setupARScene(arView: arView, context: context)
        
        let tapGesture = UITapGestureRecognizer(target: context.coordinator, action: #selector(context.coordinator.handleTap(_:)))
        arView.addGestureRecognizer(tapGesture)
        
        return arView
        #endif
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        // No hay necesidad de actualizar nada para esta versión simplificada.
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self, viewModel: viewModel)
    }

    class Coordinator: NSObject {
        var parent: ARViewContainer
        var viewModel: VM
        
        init(_ parent: ARViewContainer, viewModel: VM) {
            self.parent = parent
            self.viewModel = viewModel
        }
        
        @objc func handleTap(_ sender: UITapGestureRecognizer) {
            // Aquí manejamos el tap en AR solo en el dispositivo
            #if !targetEnvironment(simulator)
            guard let arView = sender.view as? ARView else { return }
            let tapLocation = sender.location(in: arView)
            
            if let tappedEntity = arView.entity(at: tapLocation), let challengeRewardViewModel = viewModel as? ChallengeRewardViewModel {
                challengeRewardViewModel.completeRewardTask()
            }
            #endif
        }
    }
}
/*
//FUNCIONA, PERO PARA SIMULADOR Y SACAR CAPTURAS DA PROBLEMAS
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
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal]
        arView.session.run(configuration)
        
        setupARScene(arView: arView, context: context)
        
        let tapGesture = UITapGestureRecognizer(target: context.coordinator, action: #selector(context.coordinator.handleTap(_:)))
        arView.addGestureRecognizer(tapGesture)
        #endif
        
        return arView
    }

    func setupARScene(arView: ARView, context: Context) {
        #if !targetEnvironment(simulator)
        let anchorEntity = AnchorEntity(plane: .horizontal)
        
        if let url = URL(string: prizeImageName), UIApplication.shared.canOpenURL(url) {
            // Si es una URL, descarga la imagen
            downloadImage(from: url) { image in
                if let cgImage = image?.cgImage {
                    DispatchQueue.main.async {
                        self.addImageToARView(cgImage, arView: arView, context: context)
                    }
                }
            }
        } else if let image = UIImage(named: prizeImageName), let cgImage = image.cgImage {
            // Si es una imagen local, úsala directamente
            addImageToARView(cgImage, arView: arView, context: context)
        } else {
            print("Error: No se encontró la imagen local o la URL es inválida.")
        }
        #endif
    }

    private func addImageToARView(_ cgImage: CGImage, arView: ARView, context: Context) {
        var material = UnlitMaterial()
        let mesh = MeshResource.generatePlane(width: 0.5, height: 0.5)
        let modelEntity = ModelEntity(mesh: mesh)
        
        if let texture = try? TextureResource.generate(from: cgImage, options: .init(semantic: nil)) {
            material.baseColor = MaterialColorParameter.texture(texture)
            modelEntity.model?.materials = [material]
            print("Imagen cargada correctamente en ARView.")
        } else {
            print("Error al crear la textura para la imagen.")
        }

        modelEntity.position = [0, 0, -1]
        modelEntity.generateCollisionShapes(recursive: true)
        
        let anchorEntity = AnchorEntity(plane: .horizontal)
        anchorEntity.addChild(modelEntity)
        arView.scene.addAnchor(anchorEntity)
        
        context.coordinator.currentEntity = modelEntity
    }

    private func downloadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error al descargar la imagen: \(error.localizedDescription)")
                completion(nil)
                return
            }
            if let data = data, let image = UIImage(data: data) {
                completion(image)
            } else {
                print("Error al convertir los datos en imagen.")
                completion(nil)
            }
        }
        task.resume()
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
                
                if let challengeRewardViewModel = viewModel as? ChallengeRewardViewModel {
                    challengeRewardViewModel.completeRewardTask()
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
*/




/*
 ///USANDO COIN EN ASSETS
 
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
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal]
        arView.session.run(configuration)
        
        setupARScene(arView: arView, context: context)
        
        let tapGesture = UITapGestureRecognizer(target: context.coordinator, action: #selector(context.coordinator.handleTap(_:)))
        arView.addGestureRecognizer(tapGesture)
        #endif
        
        return arView
    }
    /*
    func setupARScene(arView: ARView, context: Context) {
        #if !targetEnvironment(simulator)
        let anchorEntity = AnchorEntity(plane: .horizontal, minimumBounds: .zero)
        guard let image = UIImage(named: prizeImageName) else {
            print("Imagen no encontrada: \(prizeImageName)")
            return
        }
        
        var material = UnlitMaterial()
        let mesh = MeshResource.generatePlane(width: 0.5, height: 0.5)
        let modelEntity = ModelEntity(mesh: mesh)
        
        if let cgImage = image.cgImage, let texture = try? TextureResource.generate(from: cgImage, options: .init(semantic: nil)) {
            material.baseColor = MaterialColorParameter.texture(texture)
            modelEntity.model?.materials = [material]
        } else {
            print("Error al crear la textura")
        }

        modelEntity.position = [0, 0, -1]
        modelEntity.generateCollisionShapes(recursive: true)
        
        anchorEntity.addChild(modelEntity)
        arView.scene.addAnchor(anchorEntity)
        
        context.coordinator.currentEntity = modelEntity
        #endif
    }
     */
    func setupARScene(arView: ARView, context: Context) {
        #if !targetEnvironment(simulator)
        let anchorEntity = AnchorEntity(plane: .horizontal, minimumBounds: .zero)
        guard let image = UIImage(named: prizeImageName) else {
            print("Imagen no encontrada: \(prizeImageName)")
            return
        }
        
        var material = UnlitMaterial()
        let mesh = MeshResource.generatePlane(width: 0.5, height: 0.5)
        let modelEntity = ModelEntity(mesh: mesh)
        
        if let cgImage = image.cgImage, let texture = try? TextureResource.generate(from: cgImage, options: .init(semantic: nil)) {
            material.baseColor = MaterialColorParameter.texture(texture)
            modelEntity.model?.materials = [material]
            print("Imagen cargada correctamente en ARView: \(prizeImageName)")
        } else {
            print("Error al crear la textura para la imagen: \(prizeImageName)")
        }

        modelEntity.position = [0, 0, -1]
        modelEntity.generateCollisionShapes(recursive: true)
        
        anchorEntity.addChild(modelEntity)
        arView.scene.addAnchor(anchorEntity)
        
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
                
                if let challengeRewardViewModel = viewModel as? ChallengeRewardViewModel {
                    challengeRewardViewModel.completeRewardTask()
                } else if let coinViewModel = viewModel as? CoinViewModel {
                    if let coin = coinViewModel.coins.first {
                        coinViewModel.completeTask(coin: coin)
                    }
                }
                // Aquí puedes añadir más casos similares para otros tipos de ViewModels que necesiten interactuar con el ARView
            }
            #endif
        }
    }
}
*/

/*

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
 
 */

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
