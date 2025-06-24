//
//  RoomCaptureViewController.swift
//  Menata
//
//  Created by Muhamad Azis on 24/06/25.
//

import UIKit
import RoomPlan

class RoomCaptureViewController: UIViewController, RoomCaptureViewDelegate, RoomCaptureSessionDelegate {
    private var roomCaptureView: RoomCaptureView!
    private var roomCaptureSessionConfig = RoomCaptureSession.Configuration()
    private var finalResults: CapturedRoom?

    var dismissHandler: (() -> Void)?
    private var exportButton: UIButton!
    private var backButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupRoomCaptureView()
        startSession()
        view.backgroundColor = .black

        setupNavigationBar()
        setupExportButton()
        setupBackButton()
    }

    private func setupRoomCaptureView() {
        roomCaptureView = RoomCaptureView(frame: .zero) // <-- Use zero frame
        roomCaptureView.captureSession.delegate = self
        roomCaptureView.delegate = self
        roomCaptureView.translatesAutoresizingMaskIntoConstraints = false
        view.insertSubview(roomCaptureView, at: 0)

        // Auto Layout constraints to adapt to screen size
        NSLayoutConstraint.activate([
            roomCaptureView.topAnchor.constraint(equalTo: view.topAnchor),
            roomCaptureView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            roomCaptureView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            roomCaptureView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.layoutIfNeeded()
    }


    private func startSession() {
        roomCaptureView.captureSession.run(configuration: roomCaptureSessionConfig)
    }

    private func stopSession() {
        roomCaptureView.captureSession.stop()
    }

    private func setupNavigationBar() {
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelScanning))
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneScanning))
        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.rightBarButtonItem = doneButton
        navigationController?.navigationBar.tintColor = .white
    }

    private func setupExportButton() {
        exportButton = UIButton(type: .system)
        exportButton.setTitle("Export", for: .normal)
        exportButton.tintColor = .white
        exportButton.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.8)
        exportButton.layer.cornerRadius = 10
        exportButton.translatesAutoresizingMaskIntoConstraints = false
        exportButton.addTarget(self, action: #selector(exportResults), for: .touchUpInside)
        exportButton.isHidden = true

        view.addSubview(exportButton)
        NSLayoutConstraint.activate([
            exportButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            exportButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            exportButton.widthAnchor.constraint(equalToConstant: 120),
            exportButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }

    private func setupBackButton() {
        backButton = UIButton(type: .system)
        backButton.setTitle("Back", for: .normal)
        backButton.tintColor = .white
        backButton.backgroundColor = UIColor.systemGray.withAlphaComponent(0.8)
        backButton.layer.cornerRadius = 10
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        backButton.isHidden = true

        view.addSubview(backButton)
        NSLayoutConstraint.activate([
            backButton.bottomAnchor.constraint(equalTo: exportButton.topAnchor, constant: -12),
            backButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            backButton.widthAnchor.constraint(equalToConstant: 120),
            backButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }

    @objc private func cancelScanning() {
        stopSession()
        dismissHandler?()
    }

    @objc private func doneScanning() {
        stopSession()
        exportButton.isHidden = false
        backButton.isHidden = false
    }

    @objc private func goBack() {
        dismissHandler?()
    }

    func captureView(shouldPresent roomDataForProcessing: CapturedRoomData, error: Error?) -> Bool {
        return true
    }

    func captureView(didPresent processedResult: CapturedRoom, error: Error?) {
        finalResults = processedResult
    }

    @objc private func exportResults() {
        guard let finalResults else { return }

        let fileManager = FileManager.default
        let destinationFolderURL = fileManager.temporaryDirectory.appendingPathComponent("Export")

        do {
            if fileManager.fileExists(atPath: destinationFolderURL.path) {
                try fileManager.removeItem(at: destinationFolderURL)
            }

            try fileManager.createDirectory(at: destinationFolderURL, withIntermediateDirectories: true)

            let usdzURL = destinationFolderURL.appendingPathComponent("Room.usdz")
            try finalResults.export(to: usdzURL, exportOptions: .parametric)

            let jsonURL = destinationFolderURL.appendingPathComponent("Room.json")
            let jsonData = try JSONEncoder().encode(finalResults)
            try jsonData.write(to: jsonURL)

            let activityVC = UIActivityViewController(activityItems: [usdzURL, jsonURL], applicationActivities: nil)
            activityVC.modalPresentationStyle = .popover

            if let popover = activityVC.popoverPresentationController {
                popover.sourceView = exportButton
                popover.sourceRect = exportButton.bounds
            }

            present(activityVC, animated: true)
        } catch {
            print("Export failed: \(error.localizedDescription)")
        }
    }
}

