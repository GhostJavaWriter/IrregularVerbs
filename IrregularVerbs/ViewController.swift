//
//  ViewController.swift
//  IrregularVerbs
//
//  Created by Bair Nadtsalov on 19.05.2023.
//

import UIKit

final class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        let customView = CustomView()
        
        let model = FlashCardModel(word: "Write")
        customView.configureView(with: model)
        
        view.addSubview(customView)
        
        let guide = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            customView.topAnchor.constraint(equalTo: guide.topAnchor),
            customView.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
            customView.trailingAnchor.constraint(equalTo: guide.trailingAnchor),
            customView.bottomAnchor.constraint(equalTo: guide.bottomAnchor)
        ])
    }

}

