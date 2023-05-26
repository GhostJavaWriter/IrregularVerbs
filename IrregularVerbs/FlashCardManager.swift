//
//  FlashCardManager.swift
//  IrregularVerbs
//
//  Created by Bair Nadtsalov on 23.05.2023.
//

import Foundation

class FlashCardManager {
    
    private var flashCards = [FlashCardModel]()
    
    private let flashCardsFileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("flashcards.json")
    
    init() {
        loadFlashCards()
    }
    
    func loadFlashCards() {
        // Attempt to load from file
        if let data = try? Data(contentsOf: flashCardsFileURL),
           let savedFlashCards = try? JSONDecoder().decode([FlashCardModel].self, from: data) {
            flashCards = savedFlashCards
        } else {
            // Load default flashcards from JSON
            if let url = Bundle.main.url(forResource: "verbs", withExtension: "json") {
                do {
                    let data = try Data(contentsOf: url)
                    let decoder = JSONDecoder()
                    flashCards = try decoder.decode([FlashCardModel].self, from: data)
                } catch {
                    print("Error loading or parsing verbs.json: \(error)")
                }
            }
        }
    }
    
    func getFlashCards() -> [FlashCardModel] {
        return flashCards
    }
    
    func saveFlashCards() {
        if let data = try? JSONEncoder().encode(flashCards) {
            try? data.write(to: flashCardsFileURL)
        }
    }
    
    func updateFlashCard(_ flashCard: FlashCardModel) {
        if let index = flashCards.firstIndex(where: { $0.baseForm == flashCard.baseForm }) {
            flashCards[index] = flashCard
            saveFlashCards()
        }
    }
    
    func addNewFlashCard(_ flashCard: FlashCardModel) {
        flashCards.append(flashCard)
        saveFlashCards()
    }
}
