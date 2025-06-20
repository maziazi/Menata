import SwiftUI

struct ScannerView: View {
    @State private var showCameraView = false

    var body: some View {
        VStack {
            // Header
            HStack {
                Text("Scanner")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
                Spacer()
            }
            .padding(.horizontal)
            .padding(.top, 10)
            .padding(.bottom, 15)
            .background(Color.orange)

            Spacer()

            // Camera Preview Placeholder
            RoundedRectangle(cornerRadius: 15)
                .fill(Color(.systemGray6))
                .frame(height: 300)
                .overlay(
                    VStack {
                        Image(systemName: "camera")
                            .font(.system(size: 60))
                            .foregroundColor(.gray)
                        Text("Camera Preview")
                            .font(.headline)
                            .foregroundColor(.secondary)
                            .padding(.top, 10)
                    }
                )
                .padding(.horizontal)

            Spacer()

            // Buttons
            VStack(spacing: 20) {
                // This button will now open CameraView (Room Plan Scanner)
                Button(action: {
                    showCameraView = true
                }) {
                    HStack {
                        Image(systemName: "camera.metering.center.weighted")
                            .font(.title2)
                            .foregroundColor(.black)
                        Text("Room Plan Scanner")
                            .font(.headline)
                            .foregroundColor(.black)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundColor(.gray)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
                }

                // You can keep or change this second button
                Button(action: {
                    print("Object Scanner tapped")
                }) {
                    HStack {
                        Image(systemName: "camera.metering.spot")
                            .font(.title2)
                            .foregroundColor(.black)
                        Text("Object Scanner")
                            .font(.headline)
                            .foregroundColor(.black)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundColor(.gray)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 30)
        }
        .background(Color(.systemGray6))
        .navigationBarHidden(true)
        .fullScreenCover(isPresented: $showCameraView) {
            CameraView() // Your custom view with AVCaptureSession
        }
    }
}

#Preview {
    ScannerView()
}

