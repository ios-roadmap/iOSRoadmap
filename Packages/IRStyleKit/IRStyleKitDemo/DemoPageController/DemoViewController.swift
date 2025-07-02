//
//  IRMaskedDemoPageController.swift
//  IRStyleKit
//
//  Created by Ömer Faruk Öztürk on 2.07.2025.
//


import UIKit
import IRStyleKit
import IRCore

final class IRMaskedDemoPageController: UIViewController, ShowcaseListViewControllerProtocol {
    // MARK: - UI
    private let cardTextField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.borderStyle = .roundedRect
        tf.keyboardType = .numberPad
        tf.font = .monospacedDigitSystemFont(ofSize: 18, weight: .regular)
        return tf
    }()

    // MARK: - Mask Delegate
    private var maskedDelegate: IRMaskedInputFieldDelegate?

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureMaskDelegate()
    }

    // MARK: - Setup Helpers
    private func configureUI() {
        title = "Masked Input Demo"
        view.backgroundColor = .systemBackground
        view.addSubview(cardTextField)

        NSLayoutConstraint.activate([
            cardTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            cardTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            cardTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            cardTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    private func configureMaskDelegate() {
        // Define the custom mask pattern
        let maskDefinition = IRMaskDefinition(patternType: .custom("nnnn nn** **** nnnn"))

        // Initialise the delegate with a completion‑state callback
        maskedDelegate = IRMaskedInputFieldDelegate(
            formatter: .generic,
            maskDefinition: maskDefinition,
            onCompletionStateChanged: { [weak self] state in
                guard let self = self else { return }
                switch state {
                case .complete:
                    self.cardTextField.layer.borderColor = UIColor.systemGreen.cgColor
                    self.cardTextField.layer.borderWidth = 1
                case .incomplete:
                    self.cardTextField.layer.borderColor = UIColor.systemYellow.cgColor
                    self.cardTextField.layer.borderWidth = 1
                case .empty:
                    self.cardTextField.layer.borderWidth = 0
                }
            }
        )

        cardTextField.delegate = maskedDelegate
        cardTextField.placeholder = maskedDelegate?.placeholder
    }
}
