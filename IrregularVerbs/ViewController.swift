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
        label.text = "\(currentCardIndex+1)/\(defaultDeck.count)"
        return label
    }()
    
    private var customView: CustomView?
    
    // MARK: - Properties
    
    private var loader = Loader()
    
    private lazy var defaultDeck: [FlashCardModel] = {
        let defaultDeck = loader.getFlashCards()
        return defaultDeck
    }()
    
    private var currentCardIndex = 0 {
        didSet {
            countLabel.text = "\(currentCardIndex+1)/\(defaultDeck.count)"
        }
    }
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        defaultDeck.shuffle()
        
        let initialCard = defaultDeck[currentCardIndex]
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
    
    func showNextCard() {
        currentCardIndex = (currentCardIndex + 1) % defaultDeck.count
        let nextCard = defaultDeck[currentCardIndex]
        customView?.configureView(with: nextCard)
    }
    
    func updateCardState(for flashCard: FlashCardModel) {
        loader.updateFlashCard(flashCard)
    }
    
}

