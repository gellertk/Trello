//
//  Card.swift
//  Trello
//
//  Created by Кирилл  Геллерт on 19.04.2022.
//

import Foundation

struct Card: Hashable {
    let id = UUID()
    let text: String
}
