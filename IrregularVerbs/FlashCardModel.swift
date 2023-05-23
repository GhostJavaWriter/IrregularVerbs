//
//  FlashCardModel.swift
//  IrregularVerbs
//
//  Created by Bair Nadtsalov on 19.05.2023.
//

import UIKit

struct FlashCardModel: Codable {
    
    let baseForm: String
    let pastTense: String
    let pastParticiple: String
    let group: Int
    var isLearned: Bool?
}
