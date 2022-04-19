//
//  ViewController.swift
//  Trello
//
//  Created by Кирилл  Геллерт on 19.04.2022.
//

import UIKit

class BoardViewController: UIViewController {
    
    private var dataSource: UICollectionViewDiffableDataSource<Board, String>?
    
    private let boards: [Board] = [
        Board(title: "Todo", items: [Card(text: "Database Migration"), Card(text: "Schema Design"), Card(text: "Storage Management"), Card(text: "Model Abstraction")]),
        Board(title: "In Progress", items: [Card(text: "Push Notification"), Card(text: "Analytics"), Card(text: "Machine Learning")]),
        Board(title: "Done", items: [Card(text: "System Architecture"), Card(text: "Alert & Debugging")])
    ]
    
    private let boardView = BoardView()

    override func loadView() {
        view = boardView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDataSource()
        reloadData()
    }
    
}

private extension BoardViewController {
    
//    func createCompositionalLayout() {
//        let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
//            <#code#>
//        }
//    }
    
    func setupDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Board, String>(collectionView: boardView.boardCollectionView,
                                                                       cellProvider: { [weak self] (collectionView, indexPath, board) -> UICollectionViewCell? in
            if let cell = self?.boardView.boardCollectionView.dequeueReusableCell(withReuseIdentifier: BoardCollectionViewCell.reuseId, for: indexPath) as? BoardCollectionViewCell {
                //cell.setupContent(title: board.title)
                
                return cell
            }
            
            return nil
        })
    }
    
    func reloadData() {
        var snapshot = NSDiffableDataSourceSnapshot<Board, String>()
        snapshot.appendSections(boards)
        
        for board in boards {
            snapshot.appendItems(board.items, toSection: board)
        }
        
        dataSource?.apply(snapshot)
    }
    
}

extension BoardViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: view.frame.width - 50, height: view.frame.height - 100)
    }
    
}

extension BoardViewController {
    fileprivate enum Section {
        case main
    }
}

