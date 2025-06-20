//
//  RoomCaputreWrapperViewController.swift
//  Menata
//
//  Created by William Kesuma on 20/06/25.
//

import SwiftUI
import RoomPlan
import UIKit
import QuickLook

class RoomCaptureWrapperViewController: UIViewController, RoomCaptureViewDelegate {
    private var roomCaptureView: RoomCaptureView!
    private let roomCaptureSessionConfig = RoomCaptureSession.Configuration()
    private var isCapturing = false
    private var capturedRoom: CapturedRoom?
    private var hasPresentedPreview = false  // ✅ Prevents double preview
    var onScanSaved: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupRoomCaptureView()
        setupToggleButton()
    }

    private func setupRoomCaptureView() {
        roomCaptureView = RoomCaptureView(frame: view.bounds)
        roomCaptureView.delegate = self
        roomCaptureView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(roomCaptureView)

        NSLayoutConstraint.activate([
            roomCaptureView.topAnchor.constraint(equalTo: view.topAnchor),
            roomCaptureView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            roomCaptureView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            roomCaptureView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    private func setupToggleButton() {
        let button = UIButton(type: .system)
        button.setTitle("Start", for: .normal)
        button.backgroundColor = .red
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 25
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(toggleCaptureSession), for: .touchUpInside)
        view.addSubview(button)

        NSLayoutConstraint.activate([
            button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.widthAnchor.constraint(equalToConstant: 120),
            button.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    @objc private func toggleCaptureSession(_ sender: UIButton) {
        if isCapturing {
            roomCaptureView.captureSession.stop()
            sender.setTitle("Start", for: .normal)
            sender.backgroundColor = .red
            hasPresentedPreview = false // ✅ Reset flag for next scan
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.presentPreviewModal()
            }
        } else {
            roomCaptureView.captureSession.run(configuration: roomCaptureSessionConfig)
            sender.setTitle("Stop", for: .normal)
            sender.backgroundColor = .gray
        }
        isCapturing.toggle()
    }

    func captureView(didPresent room: CapturedRoom, error: Error?) {
        if let error = error {
            print("Capture failed: \(error.localizedDescription)")
        } else {
            capturedRoom = room
        }
    }

    private func presentPreviewModal() {
        guard !hasPresentedPreview else { return } // ✅ Prevent duplicate preview
        hasPresentedPreview = true
        guard let room = capturedRoom else { return }

        let exportURL = FileManager.default.temporaryDirectory.appendingPathComponent("Room.usdz")

        do {
            try room.export(to: exportURL)
            let previewVC = USDZPreviewController(usdzURL: exportURL)
            previewVC.modalPresentationStyle = .fullScreen
            previewVC.onSave = {
                self.saveUSDZToAppFolder(from: exportURL)
            }
            present(previewVC, animated: true)
        } catch {
            print("Export error: \(error)")
        }
    }

    private func saveUSDZToAppFolder(from url: URL) {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let destinationURL = documentsURL.appendingPathComponent("Room.usdz")

        do {
            if FileManager.default.fileExists(atPath: destinationURL.path) {
                try FileManager.default.removeItem(at: destinationURL)
            }
            try FileManager.default.copyItem(at: url, to: destinationURL)
        } catch {
            print("Save failed: \(error)")
        }

        dismiss(animated: true) {
            self.onScanSaved?()
        }
    }
}

import SwiftUI

struct CameraView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> RoomCaptureWrapperViewController {
        return RoomCaptureWrapperViewController()
    }

    func updateUIViewController(_ uiViewController: RoomCaptureWrapperViewController, context: Context) {}
}
