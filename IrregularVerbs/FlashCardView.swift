//
//  FlashCardView.swift
//  IrregularVerbs
//
//  Created by Bair Nadtsalov on 19.05.2023.
//

import UIKit

final class FlashCardView: UIView {
    
    // MARK: - UI
    
    private lazy var wordLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupView()
    }
    
    // MARK: - Public methods
    
    func configureView(with model: FlashCardModel) {
        wordLabel.text = model.word
    }
    
    // MARK: - Private methods
    
    private func setupView() {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(wordLabel)
        
        NSLayoutConstraint.activate([
            wordLabel.centerXAnchor.constraint(equalTo: layoutMarginsGuide.centerXAnchor),
            wordLabel.centerYAnchor.constraint(equalTo: layoutMarginsGuide.centerYAnchor)
        ])
    }
}
