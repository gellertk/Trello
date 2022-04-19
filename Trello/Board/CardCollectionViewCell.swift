//
//  CardCollectionViewCell.swift
//  Trello
//
//  Created by Кирилл  Геллерт on 19.04.2022.
//

import UIKit

class CardCollectionViewCell: UICollectionViewCell {
    
    static let reuseId = "CardCollectionViewCell"
    
    private let textLabel: UILabel = {
        let label = UILabel()
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupContent(text: String) {
        textLabel.text = text
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = 5
    }
    
}

private extension CardCollectionViewCell {
    
    func setupView() {
        backgroundColor = .systemGreen
        [textLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        setupConstraints()
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            textLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            textLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
}
