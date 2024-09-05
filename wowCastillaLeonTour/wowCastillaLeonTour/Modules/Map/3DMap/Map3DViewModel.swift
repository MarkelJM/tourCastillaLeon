//
//  Map3DViewModel.swift
//  wowCastillaLeonTour
//
//  Created by Markel Juaristi on 1/9/24.
//

//   sk.eyJ1IjoibWFya2Vsam0iLCJhIjoiY20wbDRyZXozMDFoczJsczM1Ym5tcm12ZCJ9.C9m_GUWhVsRgMOx98l2QMw
import Foundation
import MapKit

class Map3DViewModel: MapViewModel {
    @Published var selectedSpot: Spot?
    @Published var selectedReward: ChallengeReward?
    @Published var cameraBoundary: MKMapView.CameraBoundary?
    @Published var cameraZoomRange: MKMapView.CameraZoomRange?

    override init(appState: AppState) {
        super.init(appState: appState)
        setup3DCamera()
    }

    func setup3DCamera() {
        print("Configuring 3D camera...")
        self.cameraBoundary = MKMapView.CameraBoundary(coordinateRegion: region)
        self.cameraZoomRange = MKMapView.CameraZoomRange(minCenterCoordinateDistance: 500, maxCenterCoordinateDistance: 50000)
        region.span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    }

    func focusOnAnnotation(annotation: UnifiedAnnotation, mapView: MKMapView) {
        print("Focusing on annotation at coordinate: \(annotation.coordinate)")
        let camera = MKMapCamera(lookingAtCenter: annotation.coordinate, fromDistance: 500, pitch: 60, heading: 0)
        mapView.setCamera(camera, animated: true)
    }

    func handleAnnotationSelection(annotation: UnifiedAnnotation, mapView: MKMapView) {
        if let spot = annotation.spot {
            print("Annotation selected for spot: \(spot.name)")
            self.selectedSpot = spot
            focusOnAnnotation(annotation: annotation, mapView: mapView)
            // Se mantiene en la vista 3D pero se debería mostrar el callout
        } else if let reward = annotation.reward {
            print("Annotation selected for reward: \(reward.challengeTitle)")
            self.selectedReward = reward
            focusOnAnnotation(annotation: annotation, mapView: mapView)
            // Se mantiene en la vista 3D pero se debería mostrar el callout
        } else {
            print("Annotation selected but no spot or reward found.")
        }
    }
}

/*
import Foundation
import MapKit

class Map3DViewModel: MapViewModel {
    @Published var cameraBoundary: MKMapView.CameraBoundary?
    @Published var cameraZoomRange: MKMapView.CameraZoomRange?
    @Published var selectedSpot: Spot?

    override init(appState: AppState) {
        super.init(appState: appState)
        setup3DCamera()
    }

    func setup3DCamera() {
            // Configuración menos restrictiva de la cámara para la vista 3D
            self.cameraBoundary = MKMapView.CameraBoundary(coordinateRegion: region)
            self.cameraZoomRange = MKMapView.CameraZoomRange(minCenterCoordinateDistance: 500, maxCenterCoordinateDistance: 50000)

            region.span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        }

    // Agregar anotaciones 3D al mapa
    func add3DAnnotations(to mapView: MKMapView) {
        mapView.addAnnotations(mapAnnotations)
    }

    // Manejar la selección de anotaciones en el mapa 3D
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let annotation = view.annotation as? UnifiedAnnotation else { return }
        if let spot = annotation.spot {
            self.selectedSpot = spot
            focusOnAnnotation(annotation: annotation, mapView: mapView)
        }
    }

    // Configurar la cámara para enfocar en una anotación seleccionada
    func focusOnAnnotation(annotation: UnifiedAnnotation, mapView: MKMapView) {
        let camera = MKMapCamera(lookingAtCenter: annotation.coordinate, fromDistance: 500, pitch: 60, heading: 0)
        mapView.setCamera(camera, animated: true)
    }
}

*/

/*
import Combine
import MapKit

class Map3DViewModel: BaseViewModel {
    @Published var spots: [Spot] = []
    @Published var challenges: [Challenge] = []
    @Published var selectedChallenge: String
    @Published var isChallengeBegan: Bool = false
    @Published var selectedSpot: Spot?

    private var dataManager = Map3DDataManager()
    var appState: AppState

    init(appState: AppState) {
        self.appState = appState
        self.selectedChallenge = userDefaultsManager.getChallengeName() ?? "retoBasico"
        super.init()
        fetchChallenges()
    }

    func onMapLoad() {
        fetchSpots()
    }
    
    func saveSpotID(_ spotID: String) {
        // Lógica para guardar el ID del spot
        user?.spotIDs.append(spotID)
    }

    func fetchChallenges() {
        dataManager.fetchChallenges()
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    print("Error al obtener challenges: \(error.localizedDescription)")
                case .finished:
                    break
                }
            } receiveValue: { [weak self] challenges in
                self?.challenges = challenges
            }
            .store(in: &cancellables)
    }

    func fetchSpots() {
        dataManager.fetchSpots(for: selectedChallenge)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    print("Error al obtener spots: \(error.localizedDescription)")
                case .finished:
                    break
                }
            } receiveValue: { [weak self] spots in
                self?.spots = spots
            }
            .store(in: &cancellables)
    }

    func iconName(for spot: Spot) -> String {
        return isTaskCompleted(spotID: spot.id) ? "checkmark.circle.fill" : "mappin.circle.fill"
    }

    private func isTaskCompleted(spotID: String) -> Bool {
        return user?.spotIDs.contains(spotID) ?? false
    }
}
*/

/*
 
 
 import Combine
 import MapboxMaps

 class Map3DViewModel: BaseViewModel {
     @Published var viewport: Viewport = Viewport() // Inicializa con un Viewport por defecto
     @Published var spots: [Spot] = []
     @Published var challenges: [Challenge] = []
     @Published var selectedChallenge: String
     @Published var isChallengeBegan: Bool = false
     @Published var selectedSpot: Spot?

     private var dataManager = Map3DDataManager()
     var appState: AppState

     init(appState: AppState) {
         self.viewport = Viewport()
         self.appState = appState
         self.selectedChallenge = userDefaultsManager.getChallengeName() ?? "retoBasico"
         super.init()
         fetchChallenges()
     }

     func onMapLoad() {
         fetchSpots()
     }
     
     func saveSpotID(_ spotID: String) {
         // Lógica para guardar el ID del spot
         user?.spotIDs.append(spotID)
     }

     func fetchChallenges() {
         dataManager.fetchChallenges()
             .receive(on: DispatchQueue.main)
             .sink { completion in
                 switch completion {
                 case .failure(let error):
                     print("Error al obtener challenges: \(error.localizedDescription)")
                 case .finished:
                     break
                 }
             } receiveValue: { [weak self] challenges in
                 self?.challenges = challenges
             }
             .store(in: &cancellables)
     }

     func fetchSpots() {
         dataManager.fetchSpots(for: selectedChallenge)
             .receive(on: DispatchQueue.main)
             .sink { completion in
                 switch completion {
                 case .failure(let error):
                     print("Error al obtener spots: \(error.localizedDescription)")
                 case .finished:
                     break
                 }
             } receiveValue: { [weak self] spots in
                 self?.spots = spots
             }
             .store(in: &cancellables)
     }

     func iconName(for spot: Spot) -> String {
         return isTaskCompleted(spotID: spot.id) ? "checkmark.circle.fill" : "mappin.circle.fill"
     }

     private func isTaskCompleted(spotID: String) -> Bool {
         return user?.spotIDs.contains(spotID) ?? false
     }
 }

 */



/*
 
 ///no funciona- s eguardar por
import Combine
import MapboxMaps

class Map3DViewModel: BaseViewModel {
    @Published var viewport: Viewport
    @Published var spots: [Spot] = []
    @Published var challenges: [Challenge] = []
    @Published var selectedChallenge: String
    @Published var isChallengeBegan: Bool = false
    @Published var selectedSpot: Spot?

    private var dataManager = Map3DDataManager()
    var appState: AppState

    init(appState: AppState) {
        self.viewport = CameraOptions() // Initialize with default CameraOptions
        self.appState = appState
        self.selectedChallenge = "retoBasico"  // Temporary default value
        super.init()
        self.selectedChallenge = userDefaultsManager.getChallengeName() ?? "retoBasico"
        fetchChallenges()
    }

    func onMapLoad() {
        fetchSpots()
    }
    
    

    func fetchChallenges() {
        dataManager.fetchChallenges()
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    print("Error al obtener challenges: \(error.localizedDescription)")
                case .finished:
                    break
                }
            } receiveValue: { [weak self] challenges in
                self?.challenges = challenges
            }
            .store(in: &cancellables)
    }

    func fetchSpots() {
        dataManager.fetchSpots(for: selectedChallenge)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    print("Error al obtener spots: \(error.localizedDescription)")
                case .finished:
                    break
                }
            } receiveValue: { [weak self] spots in
                self?.spots = spots
            }
            .store(in: &cancellables)
    }

    func iconName(for spot: Spot) -> String {
        return isTaskCompleted(spotID: spot.id) ? "checkmark.circle.fill" : "mappin.circle.fill"
    }

    private func isTaskCompleted(spotID: String) -> Bool {
        return user?.spotIDs.contains(spotID) ?? false
    }
}

*/
    
/*
import Combine
import MapboxMaps

class Map3DViewModel: MapViewModel {
    @Published var mapView: MapView?
    private var pointAnnotationManager: PointAnnotationManager?

    override init(appState: AppState) {
        super.init(appState: appState)
    }

    func configureMap3D(mapView: MapView) {
        self.mapView = mapView
        print("Configuring 3D Map...")

        // Configura las opciones de inicialización del mapa centrado en Castilla y León
        let centerCoordinate = CLLocationCoordinate2D(latitude: 41.6500, longitude: -4.7200) // Coordenadas de Castilla y León
        let cameraOptions = CameraOptions(center: centerCoordinate, zoom: 12.0, bearing: -30.0, pitch: 60.0)
        mapView.camera.ease(to: cameraOptions, duration: 0)

        // Cargar el estilo y añadir anotaciones
        mapView.mapboxMap.loadStyleURI(.streets) { [weak self] error in
            if let error = error {
                print("Error al cargar el estilo del mapa: \(error.localizedDescription)")
            } else {
                print("Estilo de mapa cargado correctamente")
                self?.addAnnotations(to: mapView)
                self?.enable3DBuildings(on: mapView)
            }
        }

        self.mapView = mapView
    }

    private func addAnnotations(to mapView: MapView) {
        pointAnnotationManager = mapView.annotations.makePointAnnotationManager()

        // Añadir una anotación en las coordenadas de ejemplo en Castilla y León
        var annotation = PointAnnotation(coordinate: CLLocationCoordinate2D(latitude: 41.6500, longitude: -4.7200))
        annotation.image = PointAnnotation.Image(image: UIImage(systemName: "pin")!, name: "default")
        pointAnnotationManager?.annotations = [annotation]
    }

    private func enable3DBuildings(on mapView: MapView) {
        do {
            if let layer = try mapView.mapboxMap.style.layer(withId: "building") as? FillExtrusionLayer {
                var modifiedLayer = layer
                modifiedLayer.fillExtrusionHeight = .constant(20.0) // Ajusta la altura de los edificios
                try mapView.mapboxMap.style.updateLayer(withId: layer.id, type: FillExtrusionLayer.self) { layer in
                    layer.fillExtrusionHeight = .constant(20.0)
                }
            }
        } catch {
            print("Error al configurar edificios 3D: \(error.localizedDescription)")
        }
    }
}
*/
/*
import Combine
import MapboxMaps

class Map3DViewModel: MapViewModel {
    @Published var mapView: MapView?
    private var pointAnnotationManager: PointAnnotationManager?

    override init(appState: AppState) {
        super.init(appState: appState)
    }
    /*
     token en functions
     
    func configureMap3D(mapView: MapView) {
        self.mapView = mapView
        print("Configuring 3D Map...")

        // Configurar el estilo del mapa con manejo de errores
        mapView.mapboxMap.loadStyleURI(.streets) { [weak self] error in
            if let error = error {
                print("Error al cargar el mapa: \(error.localizedDescription)")
            } else {
                print("Mapa cargado correctamente")
                // Crear el PointAnnotationManager después de que el estilo se cargue correctamente
                self?.pointAnnotationManager = mapView.annotations.makePointAnnotationManager()
                print("PointAnnotationManager creado")
                // Añadir anotaciones 3D basadas en los spots
                self?.fetchSpotsAndAddToMap3D()
            }
        }
    }
     */
    
    //token directo:
    func configureMap3D(mapView: MapView) {
        self.mapView = mapView
        print("Configuring 3D Map...")

        let directToken = "tu_token_completo_aqui"
        mapView.resourceOptions.accessToken = directToken

        // Configurar el estilo del mapa con manejo de errores
        mapView.mapboxMap.loadStyleURI(.streets) { [weak self] error in
            if let error = error {
                print("Error al cargar el mapa: \(error.localizedDescription)")
            } else {
                print("Mapa cargado correctamente")
                self?.pointAnnotationManager = mapView.annotations.makePointAnnotationManager()
                self?.fetchSpotsAndAddToMap3D()
            }
        }
    }

    private func fetchSpotsAndAddToMap3D() {
        print("Fetching spots...")
        fetchSpots()
        print("Spots fetched: \(self.spots.count)")
        addSpotsToMap(spots: self.spots)  // Pasar los spots obtenidos al método de mapeo
    }

    override func addSpotsToMap(spots: [Spot]) {
        guard let pointAnnotationManager = pointAnnotationManager else {
            print("PointAnnotationManager no disponible")
            return
        }
        
        let annotations = spots.map { spot -> PointAnnotation in
            let unifiedAnnotation = UnifiedAnnotation(spot: spot)
            return unifiedAnnotation.toPointAnnotation() // Convertir cada spot en PointAnnotation
        }

        print("Añadiendo \(annotations.count) anotaciones al mapa")
        pointAnnotationManager.annotations = annotations
    }

    func handleTap(on annotation: PointAnnotation) {
        if let spot = spots.first(where: {
            $0.coordinates.latitude == annotation.point.coordinates.latitude &&
            $0.coordinates.longitude == annotation.point.coordinates.longitude
        }) {
            print("Spot selected: \(spot.name)")
            // Aquí se puede manejar la lógica adicional, como mostrar un callout o cambiar la vista
        }
    }
}
*/
