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
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var flashCardView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemYellow
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(flashCardTapped))
        view.addGestureRecognizer(tapGestureRecognizer)
        view.addSubview(wordLabel)
        return view
    }()
    
    private lazy var estimateButtonsView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemOrange
        
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
        return button
    }()
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [wrongButton, rightButton])
        stack.alignment = .fill
        stack.spacing = UIStackView.spacingUseSystem
        stack.distribution = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.backgroundColor = .systemOrange
        stack.isHidden = true
        return stack
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupView()
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
            flashCardView.heightAnchor.constraint(equalTo: margins.heightAnchor, multiplier: 1/5),
            flashCardView.centerYAnchor.constraint(equalTo: margins.centerYAnchor),
            
            wordLabel.centerXAnchor.constraint(equalTo: flashCardView.centerXAnchor),
            wordLabel.centerYAnchor.constraint(equalTo: flashCardView.centerYAnchor),
            
            stackView.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: margins.bottomAnchor)
        ])
    }
    
    @objc private func flashCardTapped() {
        
        let backSideModel = FlashCardModel(word: "Write\nWrote\nWritten")
        
        UIView.transition(with: flashCardView, duration: 0.3, options: .transitionFlipFromTop, animations: {
            self.wordLabel.text = backSideModel.word
            self.flashCardView.backgroundColor = .systemBlue
            self.stackView.isHidden = false
        }, completion: nil)
    }
    
}
