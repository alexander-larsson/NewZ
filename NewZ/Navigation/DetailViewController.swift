//
//  DetailViewController.swift
//  NewZ
//
//  Created by Alexander Larsson on 2019-05-15.
//  Copyright © 2019 Alexander Larsson. All rights reserved.
//

import UIKit
import Nuke

class DetailViewController: UIViewController {

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    public lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0 // Unlimited number of lines
        return label
    }()

    private lazy var responsibleEditorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var openWebsiteButton: UIButton = { [unowned self] in
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.black, for: .normal)
        button.setTitle("Läs mer på weben", for: .normal)
        button.addTarget(self, action: #selector(didPressOpenInWebButton), for: .touchUpInside)
        return button
    }()

    private lazy var toggleFavouriteButton: UIButton = { [unowned self] in
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.black, for: .normal)
        updateToggleButtonTitle(for: button)
        button.addTarget(self, action: #selector(didPressToggleFavouriteButton), for: .touchUpInside)
        return button
        }()

   private let program: Program

    init(program: Program) {
        self.program = program
        super.init(nibName: nil, bundle: nil)
        setup(with: program)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        render()
    }

    private func setup(with program: Program) {
        title = program.name
        descriptionLabel.text = program.programDescription
        responsibleEditorLabel.text = "Ansvarig utgivare: \(program.responsibleEditor!)"
        if let imageUrl = URL(string: program.programImageUrlString!) { // There is always a string
            Nuke.loadImage(with: imageUrl, into: imageView)
        }
    }

    private func updateToggleButtonTitle(for button: UIButton) {
        if program.isFavourite {
            button.setTitle("Ta bort favorit", for: .normal)
        } else {
            button.setTitle("Lägg till som favorit", for: .normal)
        }
    }

    private func render() {
        view.backgroundColor = .white

        // Scroll view setup
        scrollView.addSubview(contentView)
        view.addSubview(scrollView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
        ])

        // Setup of remaining views
        contentView.addSubview(imageView)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(responsibleEditorLabel)
        contentView.addSubview(openWebsiteButton)
        contentView.addSubview(toggleFavouriteButton)

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor),

            descriptionLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 20).with(priority: .defaultHigh),

            responsibleEditorLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 20),
            responsibleEditorLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            responsibleEditorLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 20),

            openWebsiteButton.topAnchor.constraint(equalTo: responsibleEditorLabel.bottomAnchor, constant: 20),
            openWebsiteButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),

            toggleFavouriteButton.topAnchor.constraint(equalTo: openWebsiteButton.bottomAnchor, constant: 20),
            toggleFavouriteButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            toggleFavouriteButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }

    @objc private func didPressOpenInWebButton() {
        guard let url = URL(string: program.programUrlString!) else { return } // There is always a string
        guard UIApplication.shared.canOpenURL(url) else { return }
        UIApplication.shared.open(url)
    }

    @objc private func didPressToggleFavouriteButton() {
        program.toggleFavourite()
        updateToggleButtonTitle(for: toggleFavouriteButton)
    }

}
