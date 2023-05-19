//
//  ViewController.swift
//  IrregularVerbs
//
//  Created by Bair Nadtsalov on 19.05.2023.
//

import UIKit

final class ViewController: UIViewController {

    private let defaultDeck = [
        FlashCardModel(word: "Write",
                       answer: "Write\nWrote\nWritten",
                       cardColor: .systemBlue),
        FlashCardModel(word: "Cost",
                       answer: "Cost\nCost\nCost",
                       cardColor: .systemPink)
    ]
    
    private var currentCardIndex = 0
    
    private var customView: CustomView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        currentCardIndex = Int.random(in: 0..<defaultDeck.count)
        let initialCard = defaultDeck[currentCardIndex]
        customView = CustomView(with: initialCard)
        customView?.rightButtonAction = { [weak self] in self?.showNextCard() }
        
        guard let customView = customView else { return }
        
        view.addSubview(customView)
        
        let guide = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            customView.topAnchor.constraint(equalTo: guide.topAnchor),
            customView.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
            customView.trailingAnchor.constraint(equalTo: guide.trailingAnchor),
            customView.bottomAnchor.constraint(equalTo: guide.bottomAnchor)
        ])
    }
    
    func showNextCard() {
        currentCardIndex = (currentCardIndex + 1) % defaultDeck.count
        let nextCard = defaultDeck[currentCardIndex]
        customView?.configureView(with: nextCard)
    }

}

