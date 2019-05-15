//
//  ProgramCell.swift
//  NewZ
//
//  Created by Alexander Larsson on 2019-05-15.
//  Copyright © 2019 Alexander Larsson. All rights reserved.
//

import UIKit
import Nuke

class ProgramCell: UITableViewCell {

    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = .black
        titleLabel.numberOfLines = 0
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        return titleLabel
    }()

    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.addSubview(logoImageView)
        contentView.addSubview(titleLabel)

        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            logoImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            logoImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            logoImageView.heightAnchor.constraint(equalToConstant: 60).with(priority: UILayoutPriority(rawValue: 999)),
            logoImageView.widthAnchor.constraint(equalTo: logoImageView.heightAnchor),

            titleLabel.leadingAnchor.constraint(equalTo: logoImageView.trailingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func update(with program: Program) {
        titleLabel.text = program.name

        if let imageUrl = URL(string: program.programImageUrlString!) { // There is always a string
            Nuke.loadImage(with: imageUrl, into: logoImageView)
        }

    }
}
