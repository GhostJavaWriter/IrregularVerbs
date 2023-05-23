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
    
    private var defaultDeck = [FlashCardModel(baseForm: "go", pastTense: "went", pastParticiple: "gone", group: 3)
    ]
    
    private var currentCardIndex = 0 {
        didSet {
            countLabel.text = "\(currentCardIndex+1)/\(defaultDeck.count)"
        }
    }
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        loadDeck()
        defaultDeck.shuffle()
        
//        currentCardIndex = Int.random(in: 0..<defaultDeck.count)
        let initialCard = defaultDeck[currentCardIndex]
        customView = CustomView(with: initialCard)
        customView?.showNextCard = { [weak self] in self?.showNextCard() }
        
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

