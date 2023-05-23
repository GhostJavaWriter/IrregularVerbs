//
//  LearnedCardsViewController.swift
//  IrregularVerbs
//
//  Created by Bair Nadtsalov on 23.05.2023.
//

import UIKit

final class LearnedCardsViewController: UITableViewController {
    
    var learnedFlashCards: [FlashCardModel]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return learnedFlashCards?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        var content = cell.defaultContentConfiguration()
        if let cards = learnedFlashCards {
            content.text = cards[indexPath.row].baseForm
        }
        cell.contentConfiguration = content
        return cell
    }
}
