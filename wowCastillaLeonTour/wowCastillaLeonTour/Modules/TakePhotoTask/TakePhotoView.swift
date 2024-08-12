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
        VStack {
            if viewModel.isLoading {
                Text("Cargando tarea de foto...")
            } else if let errorMessage = viewModel.errorMessage {
                Text("Error: \(errorMessage)")
            } else if let takePhoto = viewModel.takePhoto {
                VStack(spacing: 20) {
                    Text(takePhoto.question)
                        .font(.title2)
                        .multilineTextAlignment(.center)
                        .padding()
                    
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
                    
                    Button("Tomar Foto") {
                        checkCameraPermission()
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    
                    Button("Comprobar") {
                        viewModel.checkTakePhoto(isCorrect: true)
                    }
                    .padding()
                    .background(viewModel.capturedImage != nil ? Color.green : Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .disabled(viewModel.capturedImage == nil) // Desactiva el botón si no hay imagen
                }
                .padding()
                .sheet(isPresented: $viewModel.showResultModal) {
                    ResultTakePhotoView(viewModel: viewModel)
                }
            } else {
                Text("No hay tarea disponible")
            }
        }
        .onAppear {
            viewModel.fetchTakePhoto()
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

struct ResultTakePhotoView: View {
    @ObservedObject var viewModel: TakePhotoViewModel
    
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

#Preview {
    TakePhotoView(viewModel: TakePhotoViewModel(activityId: "mockId"))
}
