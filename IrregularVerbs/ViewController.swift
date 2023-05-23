//
//  ViewController.swift
//  IrregularVerbs
//
//  Created by Bair Nadtsalov on 19.05.2023.
//

import UIKit

final class ViewController: UIViewController {

    private var defaultDeck = [FlashCardModel(baseForm: "go", pastTense: "went", pastParticiple: "gone", group: 3)
    ]
    
    private var currentCardIndex = 0
    
    private var customView: CustomView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        loadDeck()
        defaultDeck.shuffle()
        
        currentCardIndex = Int.random(in: 0..<defaultDeck.count)
        let initialCard = defaultDeck[currentCardIndex]
        customView = CustomView(with: initialCard)
        customView?.showNextCard = { [weak self] in self?.showNextCard() }
        
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
    
    private func loadDeck() {
        if let url = Bundle.main.url(forResource: "verbs", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                self.defaultDeck = try decoder.decode([FlashCardModel].self, from: data)
            } catch {
                print("Error loading or parsing verbs.json: \(error)")
            }
        }
    }
    
    func showNextCard() {
        currentCardIndex = (currentCardIndex + 1) % defaultDeck.count
        let nextCard = defaultDeck[currentCardIndex]
        customView?.configureView(with: nextCard)
    }
    
}

