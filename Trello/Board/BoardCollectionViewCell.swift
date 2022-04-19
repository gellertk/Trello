//
//  BoardCollectionViewCell.swift
//  Trello
//
//  Created by Кирилл  Геллерт on 19.04.2022.
//

import UIKit
import UniformTypeIdentifiers

class BoardCollectionViewCell: UICollectionViewCell {
    
    private var board: Board?
    
    static let reuseId = "BoardCollectionViewCell"
    
    weak var delegate: BoardViewController? {
        didSet {
            cardCollectionView.delegate = delegate
        }
    }
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        
        return label
    }()
    
    private lazy var cardDataSource: UICollectionViewDiffableDataSource<Board, Card>  = {
        UICollectionViewDiffableDataSource<Board, Card>(collectionView: cardCollectionView,
                                                        cellProvider: { [weak self] (collectionView, indexPath, card) -> UICollectionViewCell? in
            if let cardCell = self?.cardCollectionView.dequeueReusableCell(withReuseIdentifier: CardCollectionViewCell.reuseId,
                                                                           for: indexPath) as? CardCollectionViewCell {
                cardCell.setupContent(text: card.text)
                
                return cardCell
            }
            
            return nil
        })
    }()
    
    private let cardCollectionViewFlowLayout: UICollectionViewFlowLayout = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumInteritemSpacing = 5
        flowLayout.minimumLineSpacing = 5
        flowLayout.scrollDirection = .vertical
        
        return flowLayout
    }()
    
    private(set) lazy var cardCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: cardCollectionViewFlowLayout)
        collectionView.register(CardCollectionViewCell.self, forCellWithReuseIdentifier: CardCollectionViewCell.reuseId)
        collectionView.backgroundColor = .white
        collectionView.dragInteractionEnabled = true
        collectionView.dragDelegate = self
        collectionView.dropDelegate = self
        
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupContent(board: Board) {
        self.board = board
        titleLabel.text = board.title
        reloadData()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        cardCollectionViewFlowLayout.itemSize = CGSize(width: 270, height: 50)
    }
    
}

private extension BoardCollectionViewCell {
    
    func setupView() {
        layer.borderWidth = 2
        backgroundColor = .black
        [titleLabel,
         cardCollectionView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        setupConstraints()
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            
            cardCollectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            cardCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            cardCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            cardCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20)
        ])
    }
    
    func reloadData() {
        guard let board = board else {
            return
        }
        DispatchQueue.main.async {
            var snapshotCard = NSDiffableDataSourceSnapshot<Board, Card>()
            snapshotCard.appendSections([board])
            snapshotCard.appendItems(board.items, toSection: board)
            
            self.cardDataSource.apply(snapshotCard, animatingDifferences: false)
        }
    }
    
}

extension BoardCollectionViewCell: UICollectionViewDragDelegate {
    
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        guard let board = board, let stringData = board.items[indexPath.row].text.data(using: .utf8) else {
            return []
        }
        let itemProvider = NSItemProvider(item: stringData as NSData, typeIdentifier: UTType.plainText.identifier)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        session.localContext = (board, indexPath, collectionView)
        
        return [dragItem]
    }
    
}

extension BoardCollectionViewCell: UICollectionViewDropDelegate {
    
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        
        return UICollectionViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        if coordinator.session.hasItemsConforming(toTypeIdentifiers: [UTType.plainText.identifier]) {
            coordinator.session.loadObjects(ofClass: NSString.self) { (items) in
                guard let string = items.first as? String else {
                    return
                }
                
                switch (coordinator.items.first?.sourceIndexPath, coordinator.destinationIndexPath) {
                case (.some(let sourceIndexPath), .some(let destinationIndexPath)):
                    
                    self.board?.items.remove(at: sourceIndexPath.row)
                    self.board?.items.insert(Card(text: string), at: destinationIndexPath.row)
                    self.reloadData()
                default: break
                }
            }
        }
    }
    
}




