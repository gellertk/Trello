//
//  BoardCollectionViewCell.swift
//  Trello
//
//  Created by Кирилл  Геллерт on 19.04.2022.
//

import UIKit

class BoardCollectionViewCell: UICollectionViewCell {
    
    static let reuseId = "BoardCollectionViewCell"
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "КАРТОЧКА 1"
        label.textColor = .white
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

private extension BoardCollectionViewCell {
    
    func setupView() {
        [titleLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        setupConstraints()
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
}
