//
//  IRCoachmarkView.swift
//  IRStyleKit
//
//  Created by Ömer Faruk Öztürk on 11.04.2025.
//

import UIKit

public protocol IRCoachmarkViewDelegate: AnyObject {
    func actionDidTapped(_ view: IRCoachmarkView, index: Int)
    func closeDidTapped(_ view: IRCoachmarkView)
}

public final class IRCoachmarkView: UIView {
    
    private let clearView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let backgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = Constants.Size.cornerRadius
        view.backgroundColor = Constants.Color.backgroundColor
        return view
    }()
    
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Constants.Font.titleLabelFont
        label.textColor = Constants.Color.titleLabelColor
        label.numberOfLines = 1
        label.textAlignment = .left
        return label
    }()
    
    private let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Kapat", for: .normal)
        button.setTitleColor(UIColor.purple, for: .normal)
        button.titleLabel?.font = Constants.Font.titleLabelFont
        button.translatesAutoresizingMaskIntoConstraints = false
        button.contentHorizontalAlignment = .right
        return button
    }()
    
    private let seperatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.gray
        view.heightAnchor.constraint(equalToConstant: Constants.Size.seperatorViewHeight).isActive = true
        return view
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Constants.Font.descriptionLabelFont
        label.textColor = Constants.Color.descriptionLabelColor
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()
    
    private let pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.currentPageIndicatorTintColor = Constants.Color.titleLabelColor
        pageControl.pageIndicatorTintColor = Constants.Color.pageIndicatorTintColor
        pageControl.isUserInteractionEnabled = false
        return pageControl
    }()
    
    private let actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(Constants.Color.titleLabelColor, for: .normal)
        button.titleLabel?.font = Constants.Font.titleLabelFont
        button.backgroundColor = .orange
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        return button
    }()
    
    
    public weak var delegate: IRCoachmarkViewDelegate?
    private var pageData: IRCoachmarkPageData
    
    public init(pageData: IRCoachmarkPageData) {
        self.pageData = pageData
        super.init(frame: .zero)
        
        isHidden = true
        setupUI()
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension IRCoachmarkView {
    private func setupUI() {
        addSubview(clearView)
        addSubview(backgroundView)
        backgroundView.addSubview(containerView)

        switch pageData.direction {
        case .top:
            NSLayoutConstraint.activate([
                clearView.topAnchor.constraint(equalTo: topAnchor),
                clearView.heightAnchor.constraint(equalToConstant: Constants.Size.clearViewHeight),
                clearView.leadingAnchor.constraint(equalTo: leadingAnchor),
                clearView.trailingAnchor.constraint(equalTo: trailingAnchor),

                backgroundView.topAnchor.constraint(equalTo: clearView.bottomAnchor),
                backgroundView.leadingAnchor.constraint(equalTo: leadingAnchor),
                backgroundView.trailingAnchor.constraint(equalTo: trailingAnchor),
                backgroundView.bottomAnchor.constraint(equalTo: bottomAnchor),
            ])
        case .bottom:
            NSLayoutConstraint.activate([
                backgroundView.topAnchor.constraint(equalTo: topAnchor),
                backgroundView.leadingAnchor.constraint(equalTo: leadingAnchor),
                backgroundView.trailingAnchor.constraint(equalTo: trailingAnchor),

                clearView.topAnchor.constraint(equalTo: backgroundView.bottomAnchor),
                clearView.heightAnchor.constraint(equalToConstant: Constants.Size.clearViewHeight),
                clearView.leadingAnchor.constraint(equalTo: leadingAnchor),
                clearView.trailingAnchor.constraint(equalTo: trailingAnchor),
                clearView.bottomAnchor.constraint(equalTo: bottomAnchor),
            ])
        }

        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: Constants.Size.defaultPadding),
            containerView.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -Constants.Size.defaultPadding),
            containerView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: Constants.Size.defaultPadding),
            containerView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -Constants.Size.defaultPadding)
        ])

        // MARK: - Title & Close
        containerView.addSubview(titleLabel)
        containerView.addSubview(closeButton)
        containerView.addSubview(seperatorView)
        containerView.addSubview(descriptionLabel)

        titleLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        closeButton.setContentHuggingPriority(.required, for: .horizontal)
        closeButton.setContentCompressionResistancePriority(.required, for: .horizontal)
        closeButton.titleLabel?.lineBreakMode = .byTruncatingTail
        closeButton.contentEdgeInsets = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: closeButton.leadingAnchor, constant: -8),

            closeButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            closeButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            closeButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 60),
            closeButton.heightAnchor.constraint(equalToConstant: Constants.Size.closeButtonSize.height),

            seperatorView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            seperatorView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            seperatorView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            seperatorView.heightAnchor.constraint(equalToConstant: Constants.Size.seperatorViewHeight),

            descriptionLabel.topAnchor.constraint(equalTo: seperatorView.bottomAnchor, constant: Constants.Size.descriptionLabelTopPadding),
            descriptionLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
        ])

        closeButton.addAction { [weak self] in
            guard let self else { return }
            self.delegate?.closeDidTapped(self)
        }

        titleLabel.text = pageData.title
        descriptionLabel.text = pageData.description

        // MARK: - Action Button
        containerView.addSubview(actionButton)
        actionButton.setTitle(pageData.actionButtonTitle, for: .normal)
        actionButton.setContentHuggingPriority(.required, for: .horizontal)
        actionButton.contentHorizontalAlignment = .center

        actionButton.addAction { [weak self] in
            guard let self else { return }
            self.delegate?.actionDidTapped(self, index: self.pageData.pageIndex)
        }

        if pageData.numberOfPages > 1 {
            containerView.addSubview(pageControl)
            pageControl.numberOfPages = pageData.numberOfPages
            pageControl.currentPage = pageData.pageIndex
            
            NSLayoutConstraint.activate([
                pageControl.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: Constants.Size.defaultPadding),
                pageControl.leadingAnchor.constraint(equalTo: descriptionLabel.leadingAnchor),

                actionButton.centerYAnchor.constraint(equalTo: pageControl.centerYAnchor),
                actionButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
                actionButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
            ])

        } else {
            closeButton.isHidden = true

            NSLayoutConstraint.activate([
                actionButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: Constants.Size.defaultPadding),
                actionButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
                actionButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
                actionButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
            ])
        }

        setupTriangleView()
    }


    func setupTriangleView() {
        let originX = pageData.triangleViewMidX - Constants.Size.defaultPadding - Constants.Size.triangleViewSize.width / 2
        let triangleView = IRTriangleView(frame: .init(origin: .init(x: originX, y: .zero), size: Constants.Size.triangleViewSize))
        triangleView.direction = pageData.direction
        
        clearView.addSubview(triangleView)
    }
    
    public func show() {
        fadeIn()
    }
    
    public func hide() {
        fadeOut { [weak self] in
            self?.removeFromSuperview()
        }
    }
}

extension IRCoachmarkView {
    private enum Constants {
        enum Size {
            static let seperatorViewHeight: CGFloat = 1
            static let clearViewHeight: CGFloat = 12
            static let cornerRadius: CGFloat = 4
            static let triangleViewSize: CGSize = .init(width: 24, height: 12)
            static let defaultPadding: CGFloat = 16
            static let closeButtonSize: CGSize = .init(width: 24, height: 24)
            static let descriptionLabelTopPadding: CGFloat = 16
        }


        enum Color {
            static let backgroundColor = UIColor.green.withAlphaComponent(0.2)
            static let titleLabelColor = UIColor.black
            static let descriptionLabelColor = UIColor.darkGray
            static let pageIndicatorTintColor: UIColor = .lightGray
        }

        
        enum Font {
            static let titleLabelFont: UIFont = .systemFont(ofSize: 17, weight: .medium)
            static let descriptionLabelFont: UIFont = .systemFont(ofSize: 14)
        }
    }
}

final class IRTriangleView: UIView {
    
    var direction: IRCoachmarkDirection = .top
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        let isDirectionUp = direction == .top
        
        context.beginPath()
        context.move(to: CGPoint(x: rect.minX, y: isDirectionUp ? rect.maxY : rect.minY))
        context.addLine(to: CGPoint(x: rect.maxX, y: isDirectionUp ? rect.maxY : rect.minY))
        context.addLine(to: CGPoint(x: (rect.maxX / 2), y: isDirectionUp ? rect.minY : rect.maxY))
        context.closePath()
        
        context.setFillColor(UIColor.green.cgColor)
        context.fillPath()
    }
}

public extension UIControl {
    
    @discardableResult
    func addAction(for event: UIControl.Event = .touchUpInside, unparametrizedAction action: @escaping () -> Void) -> Any {
        let uiAction = UIAction { _ in
            action()
        }
        
        addAction(uiAction, for: event)
        return uiAction
    }
}

public extension UIView {
    func fadeIn(completion: (() -> Void)? = nil) {
        alpha = 0
        isHidden = false
        
        UIView.animate(
            withDuration: 0.3,
            animations: { [weak self] in
                self?.alpha = 1
            },
            completion: { _ in
                completion?()
            }
        )
    }
    
    func fadeOut(completion: (() -> Void)? = nil) {
        UIView.animate(
            withDuration: 0.3,
            animations: { [weak self] in
                self?.alpha = 0
            },
            completion: { [weak self] _ in
                self?.isHidden = true
                completion?()
            }
        )
    }
}
