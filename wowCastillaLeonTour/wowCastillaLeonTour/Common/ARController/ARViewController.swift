//
//  ARViewController.swift
//  wowCastillaLeonTour
//
//  Created by Markel Juaristi on 21/8/24.
//

import UIKit
import Foundation
import ARKit
import RealityKit
import SwiftUI
import FirebaseStorage
import ZIPFoundation

struct ARViewContainer<VM: BaseViewModel>: UIViewRepresentable {
    var prizeImageName: String
    var viewModel: VM

    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)

        #if !targetEnvironment(simulator)
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal]
        configuration.environmentTexturing = .automatic
        arView.session.run(configuration)

        setupARScene(arView: arView, context: context)

        let tapGesture = UITapGestureRecognizer(target: context.coordinator, action: #selector(context.coordinator.handleTap(_:)))
        arView.addGestureRecognizer(tapGesture)
        #endif

        return arView
    }

    func setupARScene(arView: ARView, context: Context) {
        #if !targetEnvironment(simulator)
        // Referencia a Firebase Storage
        let storage = Storage.storage()
        let storageRef = storage.reference(forURL: prizeImageName)

        let tempDir = FileManager.default.temporaryDirectory
        let tempZipURL = tempDir.appendingPathComponent(UUID().uuidString + ".zip")

        // Descargar el archivo comprimido desde Firebase Storage
        storageRef.write(toFile: tempZipURL) { (url, error) in
            if let error = error {
                print("Error al descargar el archivo comprimido: \(error)")
                return
            }

            do {
                // Descomprimir el archivo
                let destinationURL = tempDir.appendingPathComponent(UUID().uuidString)
                try FileManager.default.createDirectory(at: destinationURL, withIntermediateDirectories: true, attributes: nil)
                try FileManager.default.unzipItem(at: tempZipURL, to: destinationURL)

                // Buscar el archivo .usdz descomprimido
                let usdzFileURL = try FileManager.default.contentsOfDirectory(at: destinationURL, includingPropertiesForKeys: nil)
                    .first { $0.pathExtension == "usdz" }

                // Cargar la entidad y verificar si es un ModelEntity
                if let modelEntity = try? ModelEntity.loadModel(contentsOf: usdzFileURL!) {
                    modelEntity.generateCollisionShapes(recursive: true)

                    let anchorEntity = AnchorEntity(plane: .horizontal)
                    anchorEntity.addChild(modelEntity)
                    arView.scene.addAnchor(anchorEntity)

                    context.coordinator.currentEntity = modelEntity
                } else {
                    print("Error: No se pudo cargar el archivo como ModelEntity")
                }
            } catch {
                print("Error al descomprimir el archivo o cargar el modelo: \(error)")
            }
        }
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
                currentEntity?.move(to: Transform(translation: [0, 0.1, 0]), relativeTo: currentEntity, duration: 0.5)

                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    self.currentEntity?.move(to: Transform(translation: [0, -0.1, 0]), relativeTo: self.currentEntity, duration: 1.0, timingFunction: .easeInOut)
                }

                SoundManager.shared.playButtonSound()

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
import Foundation
import ARKit
import RealityKit
import SwiftUI
import FirebaseStorage
import ZIPFoundation

struct ARViewContainer<VM: BaseViewModel>: UIViewRepresentable {
    var prizeImageName: String
    var viewModel: VM

    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)

        #if !targetEnvironment(simulator)
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal]
        configuration.environmentTexturing = .automatic
        arView.session.run(configuration)

        setupARScene(arView: arView, context: context)

        let tapGesture = UITapGestureRecognizer(target: context.coordinator, action: #selector(context.coordinator.handleTap(_:)))
        arView.addGestureRecognizer(tapGesture)
        #endif

        return arView
    }

    func setupARScene(arView: ARView, context: Context) {
        #if !targetEnvironment(simulator)
        // Referencia a Firebase Storage
        let storage = Storage.storage()
        let storageRef = storage.reference(forURL: prizeImageName)

        let tempDir = FileManager.default.temporaryDirectory
        let tempZipURL = tempDir.appendingPathComponent(UUID().uuidString + ".zip")

        // Descargar el archivo comprimido
        storageRef.write(toFile: tempZipURL) { (url, error) in
            if let error = error {
                print("Error al descargar el archivo comprimido: \(error)")
                return
            }

            do {
                // Descomprimir el archivo
                let destinationURL = tempDir.appendingPathComponent(UUID().uuidString)
                try FileManager.default.createDirectory(at: destinationURL, withIntermediateDirectories: true, attributes: nil)
                try FileManager.default.unzipItem(at: tempZipURL, to: destinationURL)

                // Buscar el archivo .usdz descomprimido
                let usdzFileURL = try FileManager.default.contentsOfDirectory(at: destinationURL, includingPropertiesForKeys: nil)
                    .first { $0.pathExtension == "usdz" }

                if let usdzFileURL = usdzFileURL {
                    // Cargar el archivo USDZ descomprimido
                    let entity = try ModelEntity.load(contentsOf: usdzFileURL)

                    if let modelEntity = entity as? ModelEntity {
                        modelEntity.generateCollisionShapes(recursive: true)

                        let anchorEntity = AnchorEntity(plane: .horizontal)
                        anchorEntity.addChild(modelEntity)
                        arView.scene.addAnchor(anchorEntity)

                        // Asignar el modelEntity al coordinador
                        context.coordinator.currentEntity = modelEntity
                    } else {
                        print("Error: La entidad cargada no es de tipo ModelEntity")
                    }
                }
            } catch {
                print("Error al descomprimir el archivo o cargar el modelo: \(error)")
            }
        }
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
                currentEntity?.move(to: Transform(translation: [0, 0.1, 0]), relativeTo: currentEntity, duration: 0.5)

                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    self.currentEntity?.move(to: Transform(translation: [0, -0.1, 0]), relativeTo: self.currentEntity, duration: 1.0, timingFunction: .easeInOut)
                }

                SoundManager.shared.playButtonSound()

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
//se supone que trae vale pero no muestra por modelentity
import Foundation
import ARKit
import RealityKit
import SwiftUI
import FirebaseStorage
import ZIPFoundation

struct ARViewContainer<VM: BaseViewModel>: UIViewRepresentable {
    var prizeImageName: String
    var viewModel: VM

    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        
        #if !targetEnvironment(simulator)
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal]
        configuration.environmentTexturing = .automatic
        arView.session.run(configuration)

        setupARScene(arView: arView, context: context)

        let tapGesture = UITapGestureRecognizer(target: context.coordinator, action: #selector(context.coordinator.handleTap(_:)))
        arView.addGestureRecognizer(tapGesture)
        #endif
        
        return arView
    }

    func setupARScene(arView: ARView, context: Context) {
        #if !targetEnvironment(simulator)
        // Descargar el archivo comprimido desde Firebase Storage
        let storage = Storage.storage()
        let storageRef = storage.reference(forURL: prizeImageName)
        
        let tempDir = FileManager.default.temporaryDirectory
        let tempFileURL = tempDir.appendingPathComponent(UUID().uuidString + ".zip")

        storageRef.write(toFile: tempFileURL) { (url, error) in
            if let error = error {
                print("Error al descargar el archivo: \(error)")
                return
            }

            do {
                // Descomprimir el archivo
                let unzipDir = tempDir.appendingPathComponent(UUID().uuidString)
                try FileManager.default.createDirectory(at: unzipDir, withIntermediateDirectories: true, attributes: nil)
                try FileManager.default.unzipItem(at: tempFileURL, to: unzipDir)

                // Obtener y mostrar todos los archivos en el directorio descomprimido
                let files = try FileManager.default.contentsOfDirectory(at: unzipDir, includingPropertiesForKeys: nil)
                
                // Imprimir los nombres de los archivos encontrados
                for file in files {
                    print("Archivo encontrado: \(file.lastPathComponent)")
                }

                // Verificar si hay un archivo .usdz en el directorio descomprimido
                if let usdzFile = files.first(where: { $0.pathExtension == "usdz" }) {
                    print("Archivo USDZ encontrado: \(usdzFile)")
                    
                    // Intentar cargar el archivo USDZ como Entity
                    let entity = try Entity.load(contentsOf: usdzFile)
                    
                    // Verificar si la entidad es un ModelEntity
                    if let modelEntity = entity as? ModelEntity {
                        modelEntity.generateCollisionShapes(recursive: true)

                        let anchorEntity = AnchorEntity(plane: .horizontal)
                        anchorEntity.addChild(modelEntity)
                        arView.scene.addAnchor(anchorEntity)
                        
                        // Asignar el modelEntity al coordinador
                        context.coordinator.currentEntity = modelEntity
                    } else {
                        print("Error: La entidad cargada no es de tipo ModelEntity")
                    }
                } else {
                    print("No se encontró ningún archivo .usdz en el archivo ZIP.")
                }
            } catch {
                print("Error al descomprimir o cargar el modelo: \(error)")
            }
        }
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
                currentEntity?.move(to: Transform(translation: [0, 0.1, 0]), relativeTo: currentEntity, duration: 0.5)

                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    self.currentEntity?.move(to: Transform(translation: [0, -0.1, 0]), relativeTo: self.currentEntity, duration: 1.0, timingFunction: .easeInOut)
                }

                SoundManager.shared.playButtonSound()

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
        configuration.environmentTexturing = .automatic
        arView.session.run(configuration)

        setupARScene(arView: arView, context: context)

        let tapGesture = UITapGestureRecognizer(target: context.coordinator, action: #selector(context.coordinator.handleTap(_:)))
        arView.addGestureRecognizer(tapGesture)
        #endif

        return arView
    }

    func setupARScene(arView: ARView, context: Context) {
        #if !targetEnvironment(simulator)
        // Cargar desde los assets
        guard let modelURL = Bundle.main.url(forResource: "sceneConverted", withExtension: "usdz") else {
            print("Error: No se encontró el archivo en los assets")
            return
        }

        do {
            // Cargar el archivo como Entity y asegurarnos de que es un ModelEntity
            let entity = try Entity.load(contentsOf: modelURL)

            if let modelEntity = entity as? ModelEntity {
                modelEntity.generateCollisionShapes(recursive: true)

                let anchorEntity = AnchorEntity(plane: .horizontal)
                anchorEntity.addChild(modelEntity)
                arView.scene.addAnchor(anchorEntity)

                context.coordinator.currentEntity = modelEntity
            } else {
                print("Error: El modelo cargado no es de tipo ModelEntity")
            }
        } catch {
            print("Error al cargar el modelo: \(error)")
        }
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
                currentEntity?.move(to: Transform(translation: [0, 0.1, 0]), relativeTo: currentEntity, duration: 0.5)

                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    self.currentEntity?.move(to: Transform(translation: [0, -0.1, 0]), relativeTo: self.currentEntity, duration: 1.0, timingFunction: .easeInOut)
                }

                SoundManager.shared.playButtonSound()

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
import Foundation
import ARKit
import RealityKit
import SwiftUI
import FirebaseStorage
import ZIPFoundation

struct ARViewContainer<VM: BaseViewModel>: UIViewRepresentable {
    var prizeImageName: String
    var viewModel: VM

    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        
        #if !targetEnvironment(simulator)
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal]
        configuration.environmentTexturing = .automatic
        arView.session.run(configuration)
        
        setupARScene(arView: arView, context: context)
        
        let tapGesture = UITapGestureRecognizer(target: context.coordinator, action: #selector(context.coordinator.handleTap(_:)))
        arView.addGestureRecognizer(tapGesture)
        #endif
        
        return arView
    }

    func setupARScene(arView: ARView, context: Context) {
         #if !targetEnvironment(simulator)
         guard let url = URL(string: prizeImageName) else {
             print("Error: URL no válida")
             return
         }

         let storage = Storage.storage()
         let storageRef = storage.reference(forURL: prizeImageName)
         
         let tempDir = FileManager.default.temporaryDirectory
         let tempFileURL = tempDir.appendingPathComponent(UUID().uuidString + ".zip")  // Nombre único para cada archivo

         storageRef.write(toFile: tempFileURL) { (url, error) in
             if let error = error {
                 print("Error al descargar el archivo: \(error)")
                 return
             }

             guard let zipURL = url else {
                 print("Error: URL del archivo descargado no válida")
                 return
             }

             // Verificar si el archivo ZIP ha sido descargado
             print("Archivo ZIP descargado: \(zipURL.path)")

             // Descomprimir el archivo ZIP
             do {
                 // Eliminar cualquier archivo existente con el mismo nombre antes de descomprimir
                 let usdcPath = tempDir.appendingPathComponent("scene.usdc")
                 if FileManager.default.fileExists(atPath: usdcPath.path) {
                     try FileManager.default.removeItem(at: usdcPath)
                 }

                 // Descomprimir el archivo ZIP
                 try FileManager.default.unzipItem(at: zipURL, to: tempDir)
                 print("Archivo ZIP descomprimido en: \(tempDir.path)")

                 // Verificar si existe un archivo .usdz o .usdc
                 let descomprimidos = try FileManager.default.contentsOfDirectory(at: tempDir, includingPropertiesForKeys: nil)

                 if let archivoUSDZ = descomprimidos.first(where: { $0.pathExtension == "usdz" || $0.pathExtension == "usdc" }) {
                     print("Modelo USDZ/USDC encontrado: \(archivoUSDZ)")

                     // Cargar el archivo USDZ/USDC en ARView
                     let modelEntity = try ModelEntity.load(contentsOf: archivoUSDZ)
                     modelEntity.generateCollisionShapes(recursive: true)

                     let anchorEntity = AnchorEntity(plane: .horizontal)
                     anchorEntity.addChild(modelEntity)
                     arView.scene.addAnchor(anchorEntity)

                     // Verificación y asignación del ModelEntity al coordinador
                     if let modelEntity = modelEntity as? ModelEntity {
                         context.coordinator.currentEntity = modelEntity
                     } else {
                         print("Error: El modelo cargado no es de tipo ModelEntity")
                     }
                 } else {
                     print("Error: No se encontró ningún archivo USDZ/USDC en \(tempDir.path)")
                 }
             } catch {
                 print("Error al descomprimir el archivo ZIP: \(error)")
             }
         }
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
                let floatUpAction = currentEntity?.move(to: Transform(translation: [0, 0.1, 0]), relativeTo: currentEntity, duration: 0.5)

                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    self.currentEntity?.move(to: Transform(translation: [0, -0.1, 0]), relativeTo: self.currentEntity, duration: 1.0, timingFunction: .easeInOut)
                }

                SoundManager.shared.playButtonSound()

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
        configuration.environmentTexturing = .automatic // Activa la detección de iluminación dinámica
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
            downloadImage(from: url) { image in
                if let cgImage = image?.cgImage {
                    DispatchQueue.main.async {
                        self.addImageToARView(cgImage, arView: arView, context: context, anchorEntity: anchorEntity)
                    }
                }
            }
        } else if let image = UIImage(named: prizeImageName), let cgImage = image.cgImage {
            addImageToARView(cgImage, arView: arView, context: context, anchorEntity: anchorEntity)
        } else {
            print("Error: No se encontró la imagen local o la URL es inválida.")
        }
        #endif
    }

    // Añadimos la imagen y configuramos oclusión y sombras
    func addImageToARView(_ cgImage: CGImage, arView: ARView, context: Context, anchorEntity: AnchorEntity) {
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

        // Desactivar la oclusión por el momento
        // let occlusionMaterial = OcclusionMaterial()
        // let occlusionEntity = ModelEntity(mesh: mesh, materials: [occlusionMaterial])
        // occlusionEntity.position = modelEntity.position
        // anchorEntity.addChild(occlusionEntity) // Oclusión aplicada

        anchorEntity.addChild(modelEntity)
        arView.scene.addAnchor(anchorEntity)
        
        context.coordinator.currentEntity = modelEntity
    }

    // Descargamos la imagen si es necesario
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
                // Animación de "flotar" al tocar la imagen
                let floatUpAction = currentEntity?.move(to: Transform(translation: [0, 0.1, 0]), relativeTo: currentEntity, duration: 0.5)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    self.currentEntity?.move(to: Transform(translation: [0, -0.1, 0]), relativeTo: self.currentEntity, duration: 1.0, timingFunction: .easeInOut)
                }

                SoundManager.shared.playButtonSound()

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
    /*
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
     */
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
    
    //ANIMATION INTERACTION WITH USER
    func addImageToARView(_ cgImage: CGImage, arView: ARView, context: Context) {
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

        // Posición inicial de la imagen
        modelEntity.position = [0, 0, -1]
        modelEntity.generateCollisionShapes(recursive: true)
        
        let anchorEntity = AnchorEntity(plane: .horizontal)
        anchorEntity.addChild(modelEntity)
        arView.scene.addAnchor(anchorEntity)
        
        context.coordinator.currentEntity = modelEntity
    }

    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        #if !targetEnvironment(simulator)
        guard let arView = sender.view as? ARView else { return }
        let tapLocation = sender.location(in: arView)
        
        if let tappedEntity = arView.entity(at: tapLocation), tappedEntity == currentEntity {
            // Animación de rotación al tocar la entidad
            let rotation = simd_quatf(angle: .pi, axis: [0, 1, 0]) // Rotación de 180 grados
            let rotateAction = currentEntity?.move(by: Transform(rotation: rotation), relativeTo: currentEntity, duration: 1.0)
            currentEntity?.runAnimation(rotateAction)
            
            // Eliminación de la entidad después de la animación (si es necesario)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.currentEntity?.removeFromParent()
            }

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
 
 */

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


