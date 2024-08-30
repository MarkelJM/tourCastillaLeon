//
//  TakePhotoView.swift
//  wowCastillaLeonTour
//
//  Created by Markel Juaristi on 22/7/24.
//


import SwiftUI
import AVFoundation

struct TakePhotoView: View {
    @StateObject var viewModel: TakePhotoViewModel
    @EnvironmentObject var appState: AppState

    var body: some View {
        ScrollView {
            ZStack {
                // Fondo de pantalla
                Image("fondoSolar")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)

                VStack(spacing: 10) {

                    HStack {
                        Button(action: {
                            appState.currentView = .map
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
                    .padding(.horizontal)
                    .padding(.top, 5)

                    if viewModel.isLoading {
                        Text("Cargando tarea de foto...")
                            .font(.title2)
                            .foregroundColor(.mateWhite)
                    } else if let errorMessage = viewModel.errorMessage {
                        Text("Error: \(errorMessage)")
                            .foregroundColor(.red)
                    } else if let takePhoto = viewModel.takePhoto {
                        VStack(spacing: 20) {
                            Text(takePhoto.question)
                                .font(.title2)
                                .foregroundColor(.mateGold)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)

                            Button(action: {
                                checkCameraPermission()
                            }) {
                                Text("Tomar Foto")
                                    .padding()
                                    .background(Color.mateBlue)
                                    .foregroundColor(.mateWhite)
                                    .cornerRadius(10)
                            }
                        }
                    }
                }
                .padding()
                .background(Color.black.opacity(0.5))  // Fondo del VStack con transparencia
                .cornerRadius(20)
                .padding()
                .sheet(isPresented: $viewModel.showResultModal) {
                    ResultTakePhotoView(viewModel: viewModel)
                }
            }
            .onAppear {
                viewModel.fetchTakePhoto()
            }
        }
    }

    func checkCameraPermission() {
        AVCaptureDevice.requestAccess(for: .video) { granted in
            if granted {
                openCamera()
            } else {
                print("Permiso denegado para usar la cámara")
            }
        }
    }

    func openCamera() {
        DispatchQueue.main.async {
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                let cameraView = CameraView(viewModel: viewModel)
                let controller = UIApplication.shared.windows.first?.rootViewController
                controller?.present(UIHostingController(rootView: cameraView), animated: true, completion: nil)
            } else {
                print("La cámara no está disponible en este dispositivo")
            }
        }
    }
}


/*
import SwiftUI
import AVFoundation

struct TakePhotoView: View {
    @StateObject var viewModel: TakePhotoViewModel
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        ScrollView {
            ZStack {
                // Fondo de pantalla
                Image("fondoSolar")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 10) {
                    
                    HStack {
                        Button(action: {
                            appState.currentView = .map
                        }) {
                            Image(systemName: "chevron.left")
                                .font(.headline)
                                .padding()
                                .background(Color.mateGold)
                                .foregroundColor(.black)
                                .cornerRadius(10)
                        }
                        Spacer()
                        Button(action: {
                            viewModel.checkTakePhoto(isCorrect: true)
                        }) {
                            Text("Comprobar")
                                .padding()
                                .background(viewModel.capturedImage != nil ? Color.mateGreen : Color.gray)
                                .foregroundColor(.mateWhite)
                                .cornerRadius(10)
                        }
                        .disabled(viewModel.capturedImage == nil) // disable button if there is no image
                    }
                    .padding(.horizontal)
                    .padding(.top, 5)

                    if viewModel.isLoading {
                        Text("Cargando tarea de foto...")
                            .font(.title2)
                            .foregroundColor(.mateWhite)
                    } else if let errorMessage = viewModel.errorMessage {
                        Text("Error: \(errorMessage)")
                            .foregroundColor(.red)
                    } else if let takePhoto = viewModel.takePhoto {
                        VStack(spacing: 20) {
                            Text(takePhoto.question)
                                .font(.title2)
                                .foregroundColor(.mateGold)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)

                            if let capturedImage = viewModel.capturedImage {
                                Image(uiImage: capturedImage)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(maxWidth: 300, maxHeight: 300)
                                    .border(Color.black, width: 2)
                            } else {
                                Text("No se ha tomado ninguna foto")
                                    .foregroundColor(.gray)
                                    .padding()
                            }
                            
                            Button(action: {
                                checkCameraPermission()
                            }) {
                                Text("Tomar Foto")
                                    .padding()
                                    .background(Color.mateBlue)
                                    .foregroundColor(.mateWhite)
                                    .cornerRadius(10)
                            }
                        }
                    }
                }
                .padding()
                .background(Color.black.opacity(0.5))  // Fondo del VStack con transparencia
                .cornerRadius(20)
                .padding()
                .sheet(isPresented: $viewModel.showResultModal) {
                    ResultTakePhotoView(viewModel: viewModel)
                }
            }
            .onAppear {
                viewModel.fetchTakePhoto()
            }
        }
    }
    
    func checkCameraPermission() {
        AVCaptureDevice.requestAccess(for: .video) { granted in
            if granted {
                openCamera()
            } else {
                print("Permiso denegado para usar la cámara")
            }
        }
    }
    
    func openCamera() {
        DispatchQueue.main.async {
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                let cameraView = CameraView(viewModel: viewModel) { image in
                    viewModel.capturedImage = image
                    viewModel.checkTakePhoto(isCorrect: true) // Comprobar la foto tan pronto como se capture
                }
                let controller = UIApplication.shared.windows.first?.rootViewController
                controller?.present(UIHostingController(rootView: cameraView), animated: true, completion: nil)
            } else {
                print("La cámara no está disponible en este dispositivo")
            }
        }
    }
}
*/
struct ResultTakePhotoView: View {
    @ObservedObject var viewModel: TakePhotoViewModel
    
    var body: some View {
        ZStack {
            Image("fondoSolar")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)

            VStack {
                Text(viewModel.alertMessage)
                    .font(.title)
                    .foregroundColor(.mateGold)
                    .padding()

                Button(action: {
                    viewModel.showResultModal = false
                }) {
                    Text("Continuar")
                        .padding()
                        .background(Color.mateRed)
                        .foregroundColor(.mateWhite)
                        .cornerRadius(10)
                }
            }
            .padding()
            .background(Color.black.opacity(0.5))  // Fondo del VStack con transparencia
            .cornerRadius(20)
            .padding()
        }
    }
}


/*
#Preview {
    TakePhotoView(viewModel: TakePhotoViewModel(activityId: id, appState: appState))
        .environmentObject(AppState())
}
*/
