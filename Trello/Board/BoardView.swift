//
//  MainView.swift
//  Trello
//
//  Created by Кирилл  Геллерт on 19.04.2022.
//

import UIKit

class BoardView: UIView {
    
    lazy var boardCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(BoardCollectionViewCell.self, forCellWithReuseIdentifier: BoardCollectionViewCell.reuseId)
        collectionView.dragInteractionEnabled = true
        collectionView.isPagingEnabled = true
        
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        boardCollectionView.layer.cornerRadius = 5
    }
    
}

extension BoardView {
    
    func setupView() {
        backgroundColor = .white
        [boardCollectionView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
        setupConstraints()
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            boardCollectionView.centerXAnchor.constraint(equalTo: centerXAnchor),
            boardCollectionView.centerYAnchor.constraint(equalTo: centerYAnchor),
            boardCollectionView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 0.8),
            boardCollectionView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height * 0.8)
        ])
    }
    
}
