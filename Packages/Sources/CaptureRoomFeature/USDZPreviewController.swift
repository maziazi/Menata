//
//  USDZPreviewController.swift
//  Menata
//
//  Created by William Kesuma on 20/06/25.
//

import UIKit
import QuickLook

class USDZPreviewController: UIViewController, QLPreviewControllerDataSource {
    private var usdzURL: URL
    var onSave: (() -> Void)?

    init(usdzURL: URL) {
        self.usdzURL = usdzURL
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        view.backgroundColor = .white

        let previewController = QLPreviewController()
        previewController.dataSource = self

        addChild(previewController)
        previewController.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(previewController.view)
        previewController.didMove(toParent: self)

        let saveButton = UIButton(type: .system)
        saveButton.setTitle("Save", for: .normal)
        saveButton.backgroundColor = .systemGreen
        saveButton.setTitleColor(.white, for: .normal)
        saveButton.layer.cornerRadius = 8
        saveButton.addTarget(self, action: #selector(handleSave), for: .touchUpInside)

        let cancelButton = UIButton(type: .system)
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.backgroundColor = .systemRed
        cancelButton.setTitleColor(.white, for: .normal)
        cancelButton.layer.cornerRadius = 8
        cancelButton.addTarget(self, action: #selector(handleCancel), for: .touchUpInside)

        let buttonStack = UIStackView(arrangedSubviews: [saveButton, cancelButton])
        buttonStack.axis = .horizontal
        buttonStack.spacing = 12
        buttonStack.distribution = .fillEqually
        buttonStack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonStack)

        NSLayoutConstraint.activate([
            previewController.view.topAnchor.constraint(equalTo: view.topAnchor),
            previewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            previewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            previewController.view.bottomAnchor.constraint(equalTo: buttonStack.topAnchor, constant: -20),

            buttonStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            buttonStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            buttonStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            buttonStack.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    @objc private func handleSave() {
        onSave?()
    }

    @objc private func handleCancel() {
        dismiss(animated: true)
    }

    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return 1
    }

    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        return usdzURL as QLPreviewItem
    }
}

