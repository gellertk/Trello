//
//  ViewController.swift
//  Trello
//
//  Created by Кирилл  Геллерт on 19.04.2022.
//

import UIKit
import UniformTypeIdentifiers

class BoardViewController: UIViewController {
    
    private var boards: [Board] = Board.getBoards()
    
    private let boardView = BoardView()
    
    private lazy var boardDataSource: UICollectionViewDiffableDataSource<Section, Board>  = {
        UICollectionViewDiffableDataSource<Section, Board>(collectionView: boardView.boardCollectionView,
                                                           cellProvider: { [weak self]  (collectionView, indexPath, board) -> UICollectionViewCell? in
            if let cell = self?.boardView.boardCollectionView.dequeueReusableCell(withReuseIdentifier: BoardCollectionViewCell.reuseId,
                                                                                  for: indexPath) as? BoardCollectionViewCell {
                cell.setupContent(board: board)
                
                return cell
            }
            
            return nil
        })
    }()
    
    override func loadView() {
        view = boardView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDelegates()
        reloadData()
    }
    
}

private extension BoardViewController {
    
    func setupDelegates() {
        boardView.boardCollectionView.delegate = self
        boardView.boardCollectionView.dragDelegate = self
        boardView.boardCollectionView.dropDelegate = self
    }
    
    func reloadData() {
        DispatchQueue.main.async {
            var snapshotBoard = NSDiffableDataSourceSnapshot<Section, Board>()
            snapshotBoard.appendSections([.main])
            snapshotBoard.appendItems(self.boards)
            
            self.boardDataSource.apply(snapshotBoard, animatingDifferences: false)
        }
    }
    
}

extension BoardViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {

           return 10
       }

       func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

           let frameSize = collectionView.frame.size
           return CGSize(width: frameSize.width - 10, height: frameSize.height)
       }

       func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {

           return UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
    }
    
}

extension BoardViewController: UICollectionViewDragDelegate {
    
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        
        let board = boards[indexPath.item]
        let itemProvider = NSItemProvider(object: board.id.uuidString as NSString)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        return [dragItem]
        
    }
    
}

extension BoardViewController: UICollectionViewDropDelegate {
    
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        
        return UICollectionViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
                
        let itemProvider = coordinator.items[0].dragItem.itemProvider
        itemProvider.loadObject(ofClass: NSString.self) { string, error in
            if let string = string as? String {
                guard let currentBoard = self.boards.first(where: { $0.id.uuidString == string }) else {
                    return
                }

                switch (coordinator.items.first?.sourceIndexPath, coordinator.destinationIndexPath) {
                case (.some(let sourceIndexPath), .some(let destinationIndexPath)):
                    
                    self.boards.remove(at: sourceIndexPath.row)
                    self.boards.insert(Board(title: currentBoard.title, items: currentBoard.items), at: destinationIndexPath.row)
                    self.reloadData()
                default: break
                }
            }
        }
        
    }
    
}

extension BoardViewController {
    fileprivate enum Section {
        case main
    }
}

