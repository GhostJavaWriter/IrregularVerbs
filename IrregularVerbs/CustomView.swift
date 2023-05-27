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
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(flashCardTapped))
        view.addGestureRecognizer(tapGestureRecognizer)
        
        view.addSubview(wordLabel)
        return view
    }()
    
    private lazy var swipeGestureRecognizer: UISwipeGestureRecognizer = {
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(flashCardViewSwiped))
        swipeGesture.direction = UISwipeGestureRecognizer.Direction.left
        return swipeGesture
    }()
    
    private lazy var swipeToUpGestureRecognizer: UISwipeGestureRecognizer = {
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(flashCardViewSwipedToUp))
        swipeGesture.direction = UISwipeGestureRecognizer.Direction.up
        return swipeGesture
    }()
    
    // MARK: - Properties
    
    private var cardModel: FlashCardModel
    var showNextCard: (() -> Void)?
    var learnCardAction: ((FlashCardModel) -> Void)?
    private var isFrontSideShown = true
    
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
        cardModel = model
        wordLabel.text = model.baseForm
        isFrontSideShown = true
        switch cardModel.group {
        case 1: flashCardView.backgroundColor = Colors.groupOne
        case 2: flashCardView.backgroundColor = Colors.groupTwo
        case 3: flashCardView.backgroundColor = Colors.groupThree
        default: flashCardView.backgroundColor = .white
        }
    }
    
    // MARK: - Private methods
    
    private func setupView() {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(flashCardView)
        
        let margins = layoutMarginsGuide
        
        NSLayoutConstraint.activate([
            
            flashCardView.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            flashCardView.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            flashCardView.heightAnchor.constraint(equalTo: margins.heightAnchor, multiplier: 1/3),
            flashCardView.centerYAnchor.constraint(equalTo: margins.centerYAnchor),
            
            wordLabel.centerXAnchor.constraint(equalTo: flashCardView.centerXAnchor),
            wordLabel.centerYAnchor.constraint(equalTo: flashCardView.centerYAnchor),
        ])
    }
    
    @objc private func flashCardTapped() {
        
        if isFrontSideShown {
            showBackSide()
        } else {
            showFrontSide()
        }
    }
    
    private func showFrontSide() {
        
        UIView.transition(with: flashCardView, duration: 0.3, options: .transitionFlipFromTop, animations: {
            self.wordLabel.text = String("\(self.cardModel.baseForm)")
        }, completion: {_ in
            self.isFrontSideShown = true
        })
    }
    
    private func showBackSide() {
        
        UIView.transition(with: flashCardView, duration: 0.3, options: .transitionFlipFromTop, animations: {
            self.wordLabel.text = String("Base: \(self.cardModel.baseForm)\nPast: \(self.cardModel.pastTense)\nParticiple: \(self.cardModel.pastParticiple)")
        }, completion: {_ in
            self.flashCardView.addGestureRecognizer(self.swipeGestureRecognizer)
            self.flashCardView.addGestureRecognizer(self.swipeToUpGestureRecognizer)
            self.isFrontSideShown = false
        })
    }
    
    @objc private func flashCardViewSwiped() {
        animateSwipeLeft()
        flashCardView.removeGestureRecognizer(swipeGestureRecognizer)
        flashCardView.removeGestureRecognizer(swipeToUpGestureRecognizer)
    }
    
    @objc private func flashCardViewSwipedToUp() {
        
        let animator = UIViewPropertyAnimator(duration: 0.3, curve: .easeIn) {
            self.flashCardView.transform = CGAffineTransform(translationX: 0, y: -self.frame.height)
            self.flashCardView.alpha = 0
        }
        animator.addCompletion { position in
            if position == .end {
                self.cardModel.isLearned = true
                self.learnCardAction?(self.cardModel)
                self.animateSlideIn()
            }
        }
        animator.startAnimation()
        flashCardView.removeGestureRecognizer(swipeToUpGestureRecognizer)
        flashCardView.removeGestureRecognizer(swipeGestureRecognizer)
    }
    
    private func animateSwipeLeft() {
        let animator = UIViewPropertyAnimator(duration: 0.5, curve: .easeIn) {
            self.flashCardView.transform = CGAffineTransform(translationX: -self.frame.size.width, y: 0)
            self.flashCardView.alpha = 0
        }
        animator.addCompletion { position in
            if position == .end {
                self.animateSlideIn()
            }
        }
        animator.startAnimation()
    }
    
    private func animateSlideIn() {
        showNextCard?()
        flashCardView.transform = CGAffineTransform(translationX: frame.size.width * 2, y: 0)
        let animator = UIViewPropertyAnimator(duration: 0.3, curve: .easeIn) {
            self.flashCardView.transform = .identity
            self.flashCardView.alpha = 1
        }
        animator.startAnimation()
    }
    
}
