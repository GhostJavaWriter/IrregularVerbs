//
//  ViewController.swift
//  IrregularVerbs
//
//  Created by Bair Nadtsalov on 19.05.2023.
//

import UIKit

final class ViewController: UIViewController {

    // MARK: - UI
    
    private lazy var countLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = true
        label.font = UIFont.preferredFont(forTextStyle: .title1)
        label.textColor = .darkGray
        label.text = "\(currentCardIndex+1)/\(learningCardsCount)"
        return label
    }()
    
    private var customView: CustomView?
    
    // MARK: - Properties
    
    private var loader = Loader()
    
    private lazy var defaultDeck: [FlashCardModel] = {
        let defaultDeck = loader.getFlashCards()
        return defaultDeck
    }()
    
    private var learnedCards = [FlashCardModel]()
    private var learningCards = [FlashCardModel]()
    
    private var currentCardIndex = 0 {
        didSet {
            countLabel.text = "\(currentCardIndex+1)/\(learningCardsCount)"
        }
    }
    
    private lazy var learningCardsCount = learningCards.count {
        didSet {
            countLabel.text = "\(currentCardIndex+1)/\(learningCardsCount)"
        }
    }
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Irregular Verbs"
        view.backgroundColor = .white
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Learned", style: .plain, target: self, action: #selector(didTapRightBarButton))
        
        separateDeck()
        learningCards.shuffle()
        
        let initialCard = learningCards[currentCardIndex]
        customView = CustomView(with: initialCard)
        customView?.showNextCard = { [weak self] in self?.showNextCard() }
        customView?.updateCardState = { [weak self] card in self?.updateCardState(for: card) }
        configureView()
    }
    
    private func configureView() {
        guard let customView = customView else { return }
        
        view.addSubview(countLabel)
        view.addSubview(customView)
        
        let guide = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            
            countLabel.topAnchor.constraint(equalToSystemSpacingBelow: guide.topAnchor, multiplier: 2),
            countLabel.centerXAnchor.constraint(equalTo: guide.centerXAnchor),
            
            customView.topAnchor.constraint(equalToSystemSpacingBelow: countLabel.bottomAnchor, multiplier: 2),
            customView.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
            customView.trailingAnchor.constraint(equalTo: guide.trailingAnchor),
            customView.bottomAnchor.constraint(equalTo: guide.bottomAnchor),
        ])
    }
    
    private func separateDeck() {
        
        for card in defaultDeck {
            
            if let isLearned = card.isLearned {
                if isLearned {
                    learnedCards.append(card)
                } else {
                    learningCards.append(card)
                }
            } else {
                learningCards.append(card)
            }
        }
    }
    
    // MARK: - Actions

    @objc private func didTapRightBarButton() {
        
        let vc = LearnedCardsViewController()
        vc.learnedFlashCards = learnedCards
        vc.removeCardFromLearned = { [weak self] card in
            self?.removeCardFromLearned(card: card)
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func showNextCard() {
        currentCardIndex = (currentCardIndex + 1) % learningCardsCount
        let nextCard = learningCards[currentCardIndex]
        customView?.configureView(with: nextCard)
    }
    
    private func updateCardState(for flashCard: FlashCardModel) {
        loader.updateFlashCard(flashCard)
        learnedCards.append(flashCard)
        learningCardsCount -= 1
    }
    
    private func removeCardFromLearned(card: FlashCardModel) {
        var newStateCard = card
        newStateCard.isLearned = false
        loader.updateFlashCard(newStateCard)
    }
    
}

