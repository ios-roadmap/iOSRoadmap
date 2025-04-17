//
//  CoachmarkView.swift
//  CoachmarksKit
//
//  Created by Developer on 11.04.2025.
//

import UIKit

@MainActor
public protocol IRCoachmarkViewDelegate: AnyObject {
    func actionTapped(on view: IRCoachmarkView, pageIndex: Int)
    func closeTapped(on view: IRCoachmarkView)
}

public struct IRCoachmarkPageData {
    public let title: String
    public let description: String
    public let totalPages: Int
    public let pageIndex: Int
    public let triangleMidX: CGFloat
    public let direction: IRCoachmarkDirection
    public let actionTitle: String
    
    public init(
        title: String,
        description: String,
        totalPages: Int = 1,
        pageIndex: Int,
        triangleMidX: CGFloat,
        direction: IRCoachmarkDirection,
        actionTitle: String
    ) {
        self.title = title
        self.description = description
        self.totalPages = totalPages
        self.pageIndex = pageIndex
        self.triangleMidX = triangleMidX
        self.direction = direction
        self.actionTitle = actionTitle
    }
}

public final class IRCoachmarkView: UIView {
    
    // MARK: - UI Components
    private let clearView = UIView()
    private let backgroundView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = Constants.Size.cornerRadius
        view.backgroundColor = Constants.Color.backgroundColor
        return view
    }()
    
    private let containerView = UIView()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.Font.titleLabelFont
        label.textColor = Constants.Color.titleLabelColor
        label.numberOfLines = 1
        label.textAlignment = .left
        return label
    }()
    
    private let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Close", for: .normal)
        button.setTitleColor(.purple, for: .normal)
        button.titleLabel?.font = Constants.Font.titleLabelFont
        button.contentHorizontalAlignment = .right
        button.contentEdgeInsets = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)
        return button
    }()
    
    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        view.heightAnchor.constraint(equalToConstant: Constants.Size.separatorHeight).isActive = true
        return view
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.Font.descriptionLabelFont
        label.textColor = Constants.Color.descriptionLabelColor
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()
    
    private let pageControl: UIPageControl = {
        let control = UIPageControl()
        control.currentPageIndicatorTintColor = Constants.Color.titleLabelColor
        control.pageIndicatorTintColor = Constants.Color.pageIndicatorTintColor
        control.isUserInteractionEnabled = false
        return control
    }()
    
    private let actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(Constants.Color.titleLabelColor, for: .normal)
        button.titleLabel?.font = Constants.Font.titleLabelFont
        button.backgroundColor = .orange
        button.layer.cornerRadius = 8
        button.configuration = .filled()
        return button
    }()
    
    // MARK: - Properties
    
    public weak var delegate: IRCoachmarkViewDelegate?
    private var pageData: IRCoachmarkPageData
    
    // MARK: - Initialisation
    
    public init(pageData: IRCoachmarkPageData) {
        self.pageData = pageData
        super.init(frame: .zero)
        isHidden = true
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }
    
    // MARK: - Animations
    
    public func show() {
        fadeIn()
    }
    
    public func hide() {
        fadeOut { [weak self] in
            self?.removeFromSuperview()
        }
    }
}

// MARK: - UI Setup

private extension IRCoachmarkView {
    
    func setupUI() {
        configureHierarchy()
        configureLayout()
        configureContent()
        configureActions()
        setupTriangleView()
    }
    
    func configureHierarchy() {
        clearView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(clearView)
        addSubview(backgroundView)
        backgroundView.addSubview(containerView)
        
        [titleLabel, closeButton, separatorView, descriptionLabel, actionButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            containerView.addSubview($0)
        }
        
        if pageData.totalPages > 1 {
            pageControl.translatesAutoresizingMaskIntoConstraints = false
            containerView.addSubview(pageControl)
        }
    }
    
    func configureLayout() {
        layoutClearAndBackground()
        layoutContainerSubviews()
    }
    
    func layoutClearAndBackground() {
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
                backgroundView.bottomAnchor.constraint(equalTo: bottomAnchor)
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
                clearView.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
        }
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: Constants.Size.defaultPadding),
            containerView.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -Constants.Size.defaultPadding),
            containerView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: Constants.Size.defaultPadding),
            containerView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -Constants.Size.defaultPadding)
        ])
    }
    
    func layoutContainerSubviews() {
        titleLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        closeButton.setContentHuggingPriority(.required, for: .horizontal)
        closeButton.setContentCompressionResistancePriority(.required, for: .horizontal)
        closeButton.titleLabel?.lineBreakMode = .byTruncatingTail
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: closeButton.leadingAnchor, constant: -8),
            
            closeButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            closeButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            closeButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 60),
            closeButton.heightAnchor.constraint(equalToConstant: Constants.Size.closeButtonSize.height),
            
            separatorView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            separatorView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: Constants.Size.separatorHeight),
            
            descriptionLabel.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: Constants.Size.descriptionTopPadding),
            descriptionLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
        ])
        
        if pageData.totalPages > 1 {
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
    }
    
    func configureContent() {
        titleLabel.text = pageData.title
        descriptionLabel.text = pageData.description
        actionButton.setTitle(pageData.actionTitle, for: .normal)
        
        if pageData.totalPages > 1 {
            pageControl.numberOfPages = pageData.totalPages
            pageControl.currentPage = pageData.pageIndex
        }
    }
    
    func configureActions() {
        closeButton.addAction { [weak self] in
            guard let self = self else { return }
            self.delegate?.closeTapped(on: self)
        }
        
        actionButton.addAction { [weak self] in
            guard let self = self else { return }
            self.delegate?.actionTapped(on: self, pageIndex: self.pageData.pageIndex)
        }
    }
    
    func setupTriangleView() {
        let originX = pageData.triangleMidX - Constants.Size.defaultPadding - Constants.Size.triangleSize.width / 2
        let triangleFrame = CGRect(origin: CGPoint(x: originX, y: 0), size: Constants.Size.triangleSize)
        
        let triangleView = UIView(frame: triangleFrame)
        triangleView.backgroundColor = .clear
        triangleView.isUserInteractionEnabled = false
        triangleView.tag = 999 
        clearView.addSubview(triangleView)

        drawTriangle(in: triangleView, direction: pageData.direction)
    }

    func drawTriangle(in view: UIView, direction: IRCoachmarkDirection) {
        let shapeLayer = CAShapeLayer()
        let path = UIBezierPath()
        let rect = view.bounds
        let pointingUp = (direction == .top)

        if pointingUp {
            path.move(to: CGPoint(x: rect.minX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
        } else {
            path.move(to: CGPoint(x: rect.minX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
        }
        path.close()

        shapeLayer.path = path.cgPath
        shapeLayer.fillColor = UIColor.green.cgColor
        view.layer.addSublayer(shapeLayer)
    }
}

// MARK: - Constants

extension IRCoachmarkView {
    enum Constants {
        enum Size {
            static let separatorHeight: CGFloat = 1
            static let clearViewHeight: CGFloat = 12
            static let cornerRadius: CGFloat = 4
            static let triangleSize = CGSize(width: 24, height: 12)
            static let defaultPadding: CGFloat = 16
            static let closeButtonSize = CGSize(width: 24, height: 24)
            static let descriptionTopPadding: CGFloat = 16
        }
        
        enum Color {
            static let backgroundColor = UIColor.green.withAlphaComponent(0.2)
            static let titleLabelColor = UIColor.black
            static let descriptionLabelColor = UIColor.darkGray
            static let pageIndicatorTintColor: UIColor = .lightGray
        }
        
        enum Font {
            static let titleLabelFont = UIFont.systemFont(ofSize: 17, weight: .medium)
            static let descriptionLabelFont = UIFont.systemFont(ofSize: 14)
        }
    }
}
