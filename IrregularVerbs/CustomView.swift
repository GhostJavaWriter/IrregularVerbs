//
//  CustomView.swift
//  IrregularVerbs
//
//  Created by Bair Nadtsalov on 19.05.2023.
//

import UIKit

final class CustomView: UIView {
    
    // MARK: - UI
    
    private lazy var wordLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = true
        label.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var flashCardView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 20
        view.backgroundColor = .systemYellow
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(flashCardTapped))
        view.addGestureRecognizer(tapGestureRecognizer)
        view.addSubview(wordLabel)
        return view
    }()
    
    private lazy var wrongButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.plain()
        config.background.backgroundColor = .systemRed
        config.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20)
        config.baseForegroundColor = .white
        button.setTitle("Wrong", for: .normal)
        button.configuration = config
        return button
    }()
    
    private lazy var rightButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.plain()
        config.background.backgroundColor = .systemGreen
        config.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20)
        config.baseForegroundColor = .white
        button.setTitle("Right", for: .normal)
        button.configuration = config
        button.addTarget(self, action: #selector(rightButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [wrongButton, rightButton])
        stack.alignment = .fill
        stack.spacing = UIStackView.spacingUseSystem
        stack.distribution = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.isHidden = true
        return stack
    }()
    
    // MARK: - Properties
    
    private var areButtonsHidden = true
    var cardModel: FlashCardModel
    var rightButtonAction: (() -> Void)?
    
    // MARK: - Init
    
    init(with model: FlashCardModel) {
        self.cardModel = model
        super.init(frame: .zero)
        configureView(with: model)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public methods
    
    func configureView(with model: FlashCardModel) {
        wordLabel.text = model.word
    }
    
    // MARK: - Private methods
    
    private func setupView() {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(flashCardView)
        addSubview(stackView)
        
        let margins = layoutMarginsGuide
        
        NSLayoutConstraint.activate([
            
            flashCardView.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            flashCardView.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            flashCardView.heightAnchor.constraint(equalTo: margins.heightAnchor, multiplier: 1/4),
            flashCardView.centerYAnchor.constraint(equalTo: margins.centerYAnchor),
            
            wordLabel.centerXAnchor.constraint(equalTo: flashCardView.centerXAnchor),
            wordLabel.centerYAnchor.constraint(equalTo: flashCardView.centerYAnchor),
            
            stackView.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: margins.bottomAnchor)
        ])
    }
    
    @objc private func flashCardTapped() {
        
        UIView.transition(with: flashCardView, duration: 0.3, options: .transitionFlipFromTop, animations: {
            self.wordLabel.text = self.cardModel.answer
            self.flashCardView.backgroundColor = self.cardModel.cardColor
            self.stackView.isHidden = false
        }, completion: nil)
    }
    
    @objc private func rightButtonTapped() {
        
        rightButtonAction?()
    }
    
}
