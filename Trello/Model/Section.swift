//
//  Board.swift
//  Trello
//
//  Created by Кирилл  Геллерт on 19.04.2022.
//

import Foundation

class Board {
//    static func == (lhs: Board, rhs: Board) -> Bool {
//        <#code#>
//    }
//
    
    var title: String
    var items: [String]
    
    init(title: String, items: [String]) {
        self.title = title
        self.items = items
    }
}
