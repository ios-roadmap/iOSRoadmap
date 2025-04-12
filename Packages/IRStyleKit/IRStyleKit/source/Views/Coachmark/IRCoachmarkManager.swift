//
//  IRCoachmarkManager.swift
//  IRStyleKit
//
//  Created by Ömer Faruk Öztürk on 12.04.2025.
//

import UIKit

public protocol IRCoachmarkManagerDelegate: AnyObject {
    func coachmarkDidComplete()
    func coachmarkDidCurrentPage(index: Int, coachmark: IRCoachmarkProtocol)
}

public extension IRCoachmarkManagerDelegate {
    func coachmarkDidCurrentPage(index: Int, coachmark: IRCoachmarkProtocol) {
        
    }
}

public final class IRCoachmarkManager: NSObject {
    
    private var parentView: UIView!
    private var coachmarks: [IRCoachmarkProtocol] = []
    private var coachmarkDelay: CGFloat = .zero
    public private(set) var didSetupCoachmarks: Bool = false
    private let bundle: Bundle
    
    private var isEnable: Bool {
        guard let statusString = bundle.infoDictionary?["CoachmarkStatus"] as? String,
              let status = CoachmarkStatus(rawValue: statusString) else {
            return true
        }
        
        return status.isEnabled
    }
    
    private enum CoachmarkStatus: String {
        case enabled = "NO"
        case disabled = "YES"
        
        var isEnabled: Bool {
            switch self {
            case .enabled:
                return true
            case .disabled:
                return false
            }
        }
    }
    
    public weak var delegate: IRCoachmarkManagerDelegate?
    public var coachmarkItemsAlreadyShown = false
    
    public init(bundle: Bundle = .main) {
        self.bundle = bundle
    }
    
    public func setup(
        coachmarks: [IRCoachmarkProtocol],
        parentView: UIView
    ) {
        guard isEnable else {
            return
        }
        
        didSetupCoachmarks = true
        
        guard !coachmarks.isEmpty else {
            return
        }
        
        self.parentView = parentView
        self.coachmarks = coachmarks
        
        guard !coachmarks.allSatisfy({ $0.didShow }) else {
            coachmarkItemsAlreadyShown = true
            delegate?.coachmarkDidComplete()
            return
        }
        
        parentView.addDarkView { [weak self] in
            self?.showNext(index: 0)
        }
    }
    
    public func setCoachmarkDelay(coachmarkDelay: CGFloat) {
        self.coachmarkDelay = coachmarkDelay
    }
    
    public static func didShowCoachmark(key: String) -> Bool {
        let userDefaultsValue = UserDefaults.standard.bool(forKey: Constants.baseKey + key)
        return userDefaultsValue
    }
    
    public func didShowCoachmarks(keys: [String]) -> Bool {
        var isShowCoachmarks: [Bool] = []
        keys.forEach {
            let userDefaultsValue = UserDefaults.standard.bool(forKey: Constants.baseKey + $0)
            isShowCoachmarks.append(userDefaultsValue)
        }
        
        return !isShowCoachmarks.contains(false)
    }
    
    public static func didShowAllCoachmarks(keys: [String]) -> Bool {
        var isShowCoachmarks: Set<Bool> = []
        keys.forEach {
            let userDefaultsValue = UserDefaults.standard.bool(forKey: Constants.baseKey + $0)
            isShowCoachmarks.insert(userDefaultsValue)
        }
        
        return !isShowCoachmarks.contains(false)
    }
    
    private func showNext(index: Int) {
        guard let coachmark = coachmarks[safe: index] else {
            parentView.removeDarkView()
            delegate?.coachmarkDidComplete()
            return
        }

        delegate?.coachmarkDidCurrentPage(index: index, coachmark: coachmark)

        DispatchQueue.main.asyncAfter(deadline: .now() + coachmarkDelay) { [weak self] in
            guard let self else { return }

            guard !coachmark.didShow else { // <-- 🔁 fix burada
                self.showNext(index: index + 1)
                return
            }

            guard let snapshotView = coachmark.addSnapshot(to: self.parentView) else {
                self.parentView.removeDarkView()
                self.delegate?.coachmarkDidComplete()
                return
            }

            let actionButtonTitle = self.coachmarks.count == 1
                ? "Devam"
                : index == self.coachmarks.count - 1 ? "Tamam" : "Devam"

            let pageData = IRCoachmarkPageData(
                title: coachmark.title,
                description: coachmark.message,
                numberOfPages: self.coachmarks.count,
                pageIndex: index,
                triangleViewMidX: snapshotView.frame.midX,
                direction: coachmark.direction,
                actionButtonTitle: actionButtonTitle
            )

            let coachmarkView = IRCoachmarkView(pageData: pageData)
            coachmarkView.translatesAutoresizingMaskIntoConstraints = false
            self.parentView.addSubview(coachmarkView)

            var constraints: [NSLayoutConstraint] = [
                coachmarkView.leftAnchor.constraint(equalTo: self.parentView.leftAnchor, constant: Constants.horizontalPadding),
                coachmarkView.rightAnchor.constraint(equalTo: self.parentView.rightAnchor, constant: -Constants.horizontalPadding)
            ]

            switch coachmark.direction {
            case .top:
                constraints.append(
                    coachmarkView.topAnchor.constraint(equalTo: snapshotView.bottomAnchor, constant: Constants.verticalPadding)
                )
            case .bottom:
                constraints.append(
                    coachmarkView.bottomAnchor.constraint(equalTo: snapshotView.topAnchor, constant: -Constants.verticalPadding)
                )
            }

            NSLayoutConstraint.activate(constraints)

            coachmarkView.delegate = self
            coachmarkView.show()
        }
    }

}

extension IRCoachmarkManager: IRCoachmarkViewDelegate {
    public func closeDidTapped(_ view: IRCoachmarkView) {
        coachmarks.forEach {
            $0.setShown()
            view.hide()
            parentView.removeSnapshots()
            parentView.removeDarkView()
            delegate?.coachmarkDidComplete()
        }
    }
    
    public func actionDidTapped(_ view: IRCoachmarkView, index: Int) {
        guard let coachmark = coachmarks[safe: index] else { return }
        
        coachmark.setShown()
        view.hide()
        parentView.removeSnapshots()
        showNext(index: index + 1)
    }
}

public extension IRCoachmarkManager {
    enum Constants {
         public static let baseKey = "retailCoachmarkDidShow_"
         public static let horizontalPadding: CGFloat = 16
         public static let verticalPadding: CGFloat = 12
    }
}
