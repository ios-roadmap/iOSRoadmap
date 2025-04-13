//
//  CoachmarkManager.swift
//  CoachmarksKit
//
//  Created by Developer on 12.04.2025.
//

import UIKit

@MainActor
public protocol IRCoachmarkManagerDelegate: AnyObject {
    func coachmarksDidComplete()
    func coachmark(didDisplayPage index: Int, coachmark: IRCoachmarkProtocol)
}

@MainActor
public extension IRCoachmarkManagerDelegate {
    func coachmark(didDisplayPage index: Int, coachmark: IRCoachmarkProtocol) { }
}

@MainActor
public final class IRCoachmarkManager: NSObject {
    
    // MARK: - Properties

    private weak var parentView: UIView?
    
    private var coachmarkItems: [IRCoachmarkProtocol] = []
    
    private var delay: TimeInterval = 0.0
    
    public private(set) var didSetupCoachmarks: Bool = false
    public weak var delegate: IRCoachmarkManagerDelegate?
    
    public var coachmarksAlreadyShown: Bool = false
    
    private let bundle: Bundle
    
    // MARK: - Initialisation
    
    public init(bundle: Bundle = .main) {
        self.bundle = bundle
    }
    
    // MARK: - Public Methods
    
    public func setupCoachmarks(_ items: [IRCoachmarkProtocol], on view: UIView) {
        guard isCoachmarkEnabled else {
            return
        }
        
        didSetupCoachmarks = true
        guard !items.isEmpty else { return }
        
        parentView = view
        coachmarkItems = items
        
        if coachmarkItems.allSatisfy({ $0.hasBeenShown }) {
            coachmarksAlreadyShown = true
            delegate?.coachmarksDidComplete()
            return
        }
        
        view.addDarkOverlay { [weak self] in
            self?.displayCoachmark(at: 0)
        }
    }
    
    public func setDelay(_ delay: TimeInterval) {
        self.delay = delay
    }
    
    // MARK: - Private Methods
    
    private var isCoachmarkEnabled: Bool {
        if let statusString = bundle.infoDictionary?["CoachmarkStatus"] as? String,
           let status = CoachmarkStatus(rawValue: statusString.lowercased()) {
            return status == .enabled
        }
        return true
    }
    
    private enum CoachmarkStatus: String {
        case enabled, disabled
    }
    
    private func displayCoachmark(at index: Int) {
        guard let view = parentView else { return }
        guard let coachmark = coachmarkItems[safe: index] else {
            view.removeDarkOverlay()
            delegate?.coachmarksDidComplete()
            return
        }
        
        delegate?.coachmark(didDisplayPage: index, coachmark: coachmark)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
            guard let self = self else { return }
            
            if coachmark.hasBeenShown {
                self.displayCoachmark(at: index + 1)
                return
            }
            
            guard let snapshotView = coachmark.addSnapshot(to: view) else {
                view.removeDarkOverlay()
                self.delegate?.coachmarksDidComplete()
                return
            }
            
            let actionTitle = (self.coachmarkItems.count == 1 || index == self.coachmarkItems.count - 1) ? "Done" : "Next"
            
            let pageData = IRCoachmarkPageData(
                title: coachmark.title,
                description: coachmark.message,
                totalPages: self.coachmarkItems.count,
                pageIndex: index,
                triangleMidX: snapshotView.frame.midX,
                direction: coachmark.direction,
                actionTitle: actionTitle
            )
            
            let coachmarkView = IRCoachmarkView(pageData: pageData)
            coachmarkView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(coachmarkView)
            
            NSLayoutConstraint.activate([
                coachmarkView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.horizontalPadding),
                coachmarkView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.horizontalPadding)
            ])
            
            switch coachmark.direction {
            case .top:
                NSLayoutConstraint.activate([
                    coachmarkView.topAnchor.constraint(equalTo: snapshotView.bottomAnchor, constant: Constants.verticalPadding)
                ])
            case .bottom:
                NSLayoutConstraint.activate([
                    coachmarkView.bottomAnchor.constraint(equalTo: snapshotView.topAnchor, constant: -Constants.verticalPadding)
                ])
            }
            
            coachmarkView.delegate = self
            coachmarkView.show()
        }
    }
}

// MARK: - CoachmarkViewDelegate

extension IRCoachmarkManager: IRCoachmarkViewDelegate {
    public func closeTapped(on view: IRCoachmarkView) {
        coachmarkItems.forEach {
            $0.markAsShown()
        }
        view.hide()
        parentView?.removeSnapshots()
        parentView?.removeDarkOverlay()
        delegate?.coachmarksDidComplete()
    }
    
    public func actionTapped(on view: IRCoachmarkView, pageIndex: Int) {
        guard let coachmark = coachmarkItems[safe: pageIndex] else { return }
        
        coachmark.markAsShown()
        view.hide()
        parentView?.removeSnapshots()
        displayCoachmark(at: pageIndex + 1)
    }
}

// MARK: - Constants

public extension IRCoachmarkManager {
    enum Constants {
         public static let baseKey = "CoachmarkDidShow_"
         public static let horizontalPadding: CGFloat = 16
         public static let verticalPadding: CGFloat = 12
    }
}
