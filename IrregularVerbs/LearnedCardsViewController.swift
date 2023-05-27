//
//  LearnedCardsViewController.swift
//  IrregularVerbs
//
//  Created by Bair Nadtsalov on 23.05.2023.
//

import UIKit

final class LearnedCardsViewController: UITableViewController {
    
    var learnedFlashCards = [FlashCardModel]()
    var unlearnCardAction: ((FlashCardModel) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.mainBackgound
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return learnedFlashCards.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        var content = cell.defaultContentConfiguration()
        content.text = learnedFlashCards[indexPath.row].baseForm
        content.textProperties.font = UIFont(name: "NotoSerifDisplay-Regular", size: 20) ?? UIFont.systemFont(ofSize: 20)
        content.textProperties.color = Colors.groupOne ?? .black
        cell.contentConfiguration = content
        cell.backgroundColor = UIColor.clear
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Remove the model from your data array
            unlearnCardAction?(learnedFlashCards[indexPath.row])
            learnedFlashCards.remove(at: indexPath.row)
            // Then remove the associated cell from the table view
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }

    
}
