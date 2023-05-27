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
    
    private var flashCardManager = FlashCardManager()
    
    private lazy var defaultDeck: [FlashCardModel] = {
        let defaultDeck = flashCardManager.getFlashCards()
        return defaultDeck
    }()
    
    private var learnedCards = [FlashCardModel]()
    private var learningCards = [FlashCardModel]() {
        didSet {
            learningCardsCount = learningCards.count
        }
    }
    
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
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAddBarButton))
        
        separateDeck()
        learningCards.shuffle()
        
        let initialCard = learningCards[currentCardIndex]
        customView = CustomView(with: initialCard)
        customView?.fontName = "NotoSerifDisplay-Regular"
        customView?.showNextCard = { [weak self] in self?.showNextCard() }
        customView?.learnCardAction = { [weak self] card in self?.learnCard(card) }
        configureView()
    }
    
    private func configureView() {
        
        view.backgroundColor = Colors.mainBackgound
        
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
        vc.unlearnCardAction = { [weak self] card in
            self?.unlearnCard(card)
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func didTapAddBarButton() {
        showAddNewCardAlertController()
    }
    
    private func addNewCard(_ card: FlashCardModel) {
        learningCards.append(card)
        flashCardManager.addNewFlashCard(card)
    }
    
    private func learnCard(_ card: FlashCardModel) {
        learningCards.removeAll { $0.baseForm == card.baseForm }
        learnedCards.append(card)
        
        var updatedCard = card
        updatedCard.isLearned = true
        flashCardManager.updateFlashCard(updatedCard)
    }
    
    private func unlearnCard(_ card: FlashCardModel) {
        learnedCards.removeAll { $0.baseForm == card.baseForm }
        learningCards.append(card)
        
        var updatedCard = card
        updatedCard.isLearned = true
        flashCardManager.updateFlashCard(card)
    }
    
    private func showNextCard() {
        currentCardIndex = (currentCardIndex + 1) % learningCardsCount
        let nextCard = learningCards[currentCardIndex]
        customView?.configureView(with: nextCard)
    }
    
    private func showAddNewCardAlertController() {
        
        let alertController = UIAlertController(title: "New Verb", message: "Enter details for the new verb.", preferredStyle: .alert)

        // Add text fields
        alertController.addTextField { (textField) in
            textField.placeholder = "Base Form"
            textField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        }
        alertController.addTextField { (textField) in
            textField.placeholder = "Past Tense"
            textField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        }
        alertController.addTextField { (textField) in
            textField.placeholder = "Past Participle"
            textField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        }

        // Create an action for the button
        let addAction = UIAlertAction(title: "Add", style: .default) { [weak alertController, self] _ in
            guard let alertController = alertController,
                  let baseFormTextField = alertController.textFields?[0],
                  let pastTenseTextField = alertController.textFields?[1],
                  let pastParticipleTextField = alertController.textFields?[2]
            else { return }

            let base = baseFormTextField.text
            let pastTense = pastTenseTextField.text
            let pastParticiple = pastParticipleTextField.text
            var group = 3
            if (base == pastTense) && (base == pastParticiple) {
                group = 1
            }
            else if (pastTense == pastParticiple) {
                group = 2
            }
            
            let newFlashCard = FlashCardModel(baseForm: base ?? "",
                                              pastTense: pastTense ?? "",
                                              pastParticiple: pastParticiple ?? "",
                                              group: group)
            
            self.addNewCard(newFlashCard)
        }
        
        addAction.isEnabled = false // Initially disable the Add action
        alertController.addAction(addAction)

        // Add a cancel action
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)

        // Present the alert controller
        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        guard let alertController = self.presentedViewController as? UIAlertController,
              let addAction = alertController.actions.first,
              let textFields = alertController.textFields
        else { return }

        // Enable the action when all text fields have text
        addAction.isEnabled = textFields.allSatisfy { textField in
            guard let text = textField.text else { return false }
            return !text.isEmpty
        }
    }
    
}

