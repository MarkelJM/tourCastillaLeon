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
    @EnvironmentObject var appState: AppState

    var body: some View {
        ZStack {
            // Fondo de pantalla
            Image("fondoSolar")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                if viewModel.isLoading {
                    Text("Cargando datos...")
                        .font(.title2)
                        .foregroundColor(.white)
                } else if let errorMessage = viewModel.errorMessage {
                    Text("Error: \(errorMessage)")
                        .foregroundColor(.red)
                } else if let coin = viewModel.coins.first {
                    ARViewContainer(prizeImageName: coin.prize, viewModel: viewModel)
                        .edgesIgnoringSafeArea(.all)
                } else {
                    Text("No hay datos disponibles")
                        .foregroundColor(.white)
                }
            }
            
            VStack {
                HStack {
                    Button(action: {
                        appState.currentView = .mapContainer
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.headline)
                            .padding()
                            .background(Color.mateGold)
                            .foregroundColor(.black)
                            .cornerRadius(10)
                    }
                    Spacer()
                }
                .padding([.top, .leading], 20)
                
                Spacer()
            }
        }
        .sheet(isPresented: $viewModel.showResultModal) {
            ResultCoinView(viewModel: viewModel)
                .environmentObject(appState)
        }
    }
}

struct ResultCoinView: View {
    @ObservedObject var viewModel: CoinViewModel
    @EnvironmentObject var appState: AppState
    let soundManager = SoundManager.shared  

    var body: some View {
        ZStack {
            Image("fondoSolar")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Text(viewModel.resultMessage)
                    .font(.title)
                    .foregroundColor(.mateGold)
                    .padding()

                Button("Continuar") {
                    // Navegar de vuelta al mapa
                    viewModel.showResultModal = false
                    appState.currentView = .map
                }
                .padding()
                .background(Color.mateRed)
                .foregroundColor(.mateWhite)
                .cornerRadius(10)
            }
            .padding()
            .background(Color.black.opacity(0.5))  // Fondo semitransparente del VStack
            .cornerRadius(20)
            .padding()
        }
        .onAppear {
            soundManager.playWinnerSound() // Reproducir sonido cuando aparezca el resultado
        }
    }
}


/*

struct CoinView: View {
    @ObservedObject var viewModel: CoinViewModel
    @EnvironmentObject var appState: AppState

    var body: some View {
        ZStack {
            if viewModel.isLoading {
                Text("Cargando datos...")
            } else if let errorMessage = viewModel.errorMessage {
                Text("Error: \(errorMessage)")
            } else if let coin = viewModel.coins.first {
                ARViewContainer(prizeImageName: coin.prize, viewModel: viewModel)
                    .edgesIgnoringSafeArea(.all)
            } else {
                Text("No hay datos disponibles")
            }

            VStack {
                HStack {
                    Button(action: {
                        appState.currentView = .map
                    }) {
                        Text("Atrás")
                            .padding()
                            .background(Color.black.opacity(0.7))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    Spacer()
                }
                .padding([.top, .leading], 20)
                
                Spacer()
            }
        }
        .sheet(isPresented: $viewModel.showResultModal) {
            ResultCoinView(viewModel: viewModel, appState: _appState)
        }
    }
}

struct ResultCoinView: View {
    @ObservedObject var viewModel: CoinViewModel
    @EnvironmentObject var appState: AppState

    var body: some View {
        VStack {
            Text(viewModel.resultMessage)
                .font(.title)
                .padding()

            Button("Continuar") {
                // Navegar de vuelta al mapa
                viewModel.showResultModal = false
                appState.currentView = .map
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .padding()
    }
}
*/


/*
///genial
import SwiftUI
import ARKit
import RealityKit

struct CoinView: View {
    @ObservedObject var viewModel: CoinViewModel
    @EnvironmentObject var appState: AppState

    var body: some View {
        ZStack {
            if viewModel.isLoading {
                Text("Cargando datos...")
            } else if let errorMessage = viewModel.errorMessage {
                Text("Error: \(errorMessage)")
            } else if let coin = viewModel.coins.first {
                ARViewContainer(prizeImageName: coin.prize, viewModel: viewModel)
                    .edgesIgnoringSafeArea(.all)
            } else {
                Text("No hay datos disponibles")
            }

            VStack {
                HStack {
                    Button(action: {
                        appState.currentView = .map
                    }) {
                        Text("Atrás")
                            .padding()
                            .background(Color.black.opacity(0.7))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    Spacer()
                }
                .padding([.top, .leading], 20)
                
                Spacer()
            }
        }
        .sheet(isPresented: $viewModel.showResultModal) {
            ResultCoinView(viewModel: viewModel)
        }
    }
}

struct ResultCoinView: View {
    @ObservedObject var viewModel: CoinViewModel
    
    var body: some View {
        VStack {
            Text(viewModel.alertMessage)
                .font(.title)
                .padding()

            Button("Continuar") {
                viewModel.showResultModal = false
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .padding()
    }
}

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
                // Completar la tarea
                if let coin = viewModel.coins.first {
                    viewModel.completeTask(coin: coin)
                }
            }
        }
    }
}
 */


/*
//MUESTRA COIN Y AL TOCAR DESAPARECE. ATRAS FUNCIONA
import SwiftUI
import ARKit
import RealityKit

struct CoinView: View {
    @ObservedObject var viewModel: CoinViewModel
    @EnvironmentObject var appState: AppState

    var body: some View {
        ZStack {
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

            VStack {
                HStack {
                    Button(action: {
                        appState.currentView = .map
                    }) {
                        Text("Atrás")
                            .padding()
                            .background(Color.black.opacity(0.7))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    Spacer()
                }
                .padding([.top, .leading], 20)
                
                Spacer()
            }
        }
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
        Coordinator(self)
    }
    
    class Coordinator: NSObject {
        var parent: ARViewContainer
        var currentEntity: ModelEntity?
        
        init(_ parent: ARViewContainer) {
            self.parent = parent
        }
        
        @objc func handleTap(_ sender: UITapGestureRecognizer) {
            guard let arView = sender.view as? ARView else { return }
            let tapLocation = sender.location(in: arView)
            
            // Buscar la entidad que fue tocada
            if let tappedEntity = arView.entity(at: tapLocation), tappedEntity == currentEntity {
                currentEntity?.removeFromParent()
                // Aquí puedes añadir la lógica para mostrar un mensaje o hacer alguna acción adicional
                print("Moneda capturada")
            }
        }
    }
}
 */

/*
//atras funciona coin se muestra pero no interactua
import SwiftUI
import ARKit
import RealityKit

struct CoinView: View {
    @ObservedObject var viewModel: CoinViewModel
    @EnvironmentObject var appState: AppState

    var body: some View {
        ZStack {
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

            VStack {
                HStack {
                    Button(action: {
                        appState.currentView = .map
                    }) {
                        Text("Atrás")
                            .padding()
                            .background(Color.black.opacity(0.7))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    Spacer()
                }
                .padding([.top, .leading], 20)
                
                Spacer()
            }
        }
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
        
        // Configurar la escena AR
        setupARScene(arView: arView)
        
        return arView
    }
    
    func setupARScene(arView: ARView) {
        // Crear una entidad ancla para el plano horizontal
        let anchorEntity = AnchorEntity(plane: .horizontal)
        
        // Cargar la imagen desde los assets
        guard let image = UIImage(named: prizeImageName) else {
            print("Imagen no encontrada: \(prizeImageName)")
            return
        }
        
        var material = SimpleMaterial()
        let mesh = MeshResource.generatePlane(width: 0.2, height: 0.2)
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
        
        // Añadir la entidad al ancla
        anchorEntity.addChild(modelEntity)
        
        // Añadir el ancla al ARView
        arView.scene.addAnchor(anchorEntity)
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
    
    // Crear un Coordinador para manejar el botón "Atrás"
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject {
        var parent: ARViewContainer
        
        init(_ parent: ARViewContainer) {
            self.parent = parent
        }
    }
}
 
 */
/*
///MUESTRA EL COIN, PERO NO HAY INTERACCION
import SwiftUI
import ARKit
import RealityKit

struct CoinView: View {
    @ObservedObject var viewModel: CoinViewModel
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        ZStack {
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

            VStack {
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Atrás")
                            .padding()
                            .background(Color.black.opacity(0.7))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    Spacer()
                }
                .padding([.top, .leading], 20)
                
                Spacer()
            }
        }
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
        
        // Configurar la escena AR
        setupARScene(arView: arView)
        
        return arView
    }
    
    func setupARScene(arView: ARView) {
        // Crear una entidad ancla para el plano horizontal
        let anchorEntity = AnchorEntity(plane: .horizontal)
        
        // Cargar la imagen desde los assets
        guard let image = UIImage(named: prizeImageName) else {
            print("Imagen no encontrada: \(prizeImageName)")
            return
        }
        
        var material = SimpleMaterial()
        let mesh = MeshResource.generatePlane(width: 0.2, height: 0.2)
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
        
        // Añadir la entidad al ancla
        anchorEntity.addChild(modelEntity)
        
        // Añadir el ancla al ARView
        arView.scene.addAnchor(anchorEntity)
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject {
        var parent: ARViewContainer
        
        init(_ parent: ARViewContainer) {
            self.parent = parent
        }
    }
}

struct CoinView_Previews: PreviewProvider {
    static var previews: some View {
        CoinView(viewModel: CoinViewModel(activityId: "mockId"))
    }
}

 
 
 
 
 */
/*
 ///MUESTRA EL COIN, PERO NO INTERACTURA NI COIN NI ATRAS
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
        
        // Configurar la escena AR
        setupARScene(arView: arView)
        
        // Añadir botón "Atrás"
        let backButton = UIButton(frame: CGRect(x: 20, y: 50, width: 100, height: 50))
        backButton.setTitle("Atrás", for: .normal)
        backButton.setTitleColor(.white, for: .normal)
        backButton.backgroundColor = .black.withAlphaComponent(0.7)
        backButton.layer.cornerRadius = 10
        backButton.addTarget(context.coordinator, action: #selector(context.coordinator.backButtonPressed), for: .touchUpInside)
        arView.addSubview(backButton)
        
        return arView
    }
    
    func setupARScene(arView: ARView) {
        // Crear una entidad ancla para el plano horizontal
        let anchorEntity = AnchorEntity(plane: .horizontal)
        
        // Cargar la imagen desde los assets
        guard let image = UIImage(named: prizeImageName) else {
            print("Imagen no encontrada: \(prizeImageName)")
            return
        }
        
        var material = SimpleMaterial()
        let mesh = MeshResource.generatePlane(width: 0.2, height: 0.2)
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
        
        // Añadir la entidad al ancla
        anchorEntity.addChild(modelEntity)
        
        // Añadir el ancla al ARView
        arView.scene.addAnchor(anchorEntity)
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
    
    // Crear un Coordinador para manejar el botón "Atrás"
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject {
        var parent: ARViewContainer
        
        init(_ parent: ARViewContainer) {
            self.parent = parent
        }
        
        @objc func backButtonPressed() {
            UIApplication.shared.windows.first?.rootViewController?.dismiss(animated: true, completion: nil)
        }
    }
}

#Preview {
    CoinView(viewModel: CoinViewModel(activityId: "mockId"))
}
 
 */

/*
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
                modelEntity.model?.materials = [material]  // Reasignar el material con la textura aplicada
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

*/

/*
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
*/
