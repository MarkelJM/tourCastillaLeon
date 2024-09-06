//
//  ARViewController.swift
//  wowCastillaLeonTour
//
//  Created by Markel Juaristi on 21/8/24.
//



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

/*
 //for screenshots
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
        // No se necesita actualizar nada para esta versión simplificada.
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
    
    #if !targetEnvironment(simulator)
    private func setupARScene(arView: ARView, context: Context) {
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
    #endif
}
 
 */


