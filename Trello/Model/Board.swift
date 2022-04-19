//
//  Board.swift
//  Trello
//
//  Created by Кирилл  Геллерт on 19.04.2022.
//

import Foundation

struct Board: Hashable {
    let id = UUID()
    let title: String
    var items: [Card]
    
    static func getBoards() -> [Board] {
        return [
            Board(title: "Сделать", items: [Card(text: "Сделать задачку"), Card(text: "Сделать 2 задачку"), Card(text: "Сделать 5 задачку"), Card(text: "Сделать 1 задачку"), Card(text: "Сделать 4 задачку"), Card(text: "Сделать 6 задачку"), Card(text: "Сделать 7 задачку"), Card(text: "Сделать 7 задачку"), Card(text: "Сделать 10 задачку"), Card(text: "Сделать 9 задачку"), Card(text: "Сделать 11 задачку"), Card(text: "Сделать 14 задачку"), Card(text: "Сделать 13 задачку"), Card(text: "Сделать 12 задачку"), Card(text: "Сделать 15 задачку"), Card(text: "Сделать 16 задачку"), Card(text: "Сделать 17 задачку")]),
            Board(title: "В процессе", items: [Card(text: "Купить собаку"), Card(text: "Купить кошку"), Card(text: "Купить собаке дом")]),
            Board(title: "Сделано", items: [Card(text: "Куплен слон"), Card(text: "Куплен пес")])
        ]
    }
    
}
