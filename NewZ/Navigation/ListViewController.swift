//
//  ViewController.swift
//  NewZ
//
//  Created by Alexander Larsson on 2019-05-13.
//  Copyright © 2019 Alexander Larsson. All rights reserved.
//

import UIKit

class ListViewController: UIViewController {

    private lazy var newsService = NewsService()

    private lazy var tableView: UITableView = { [unowned self] in
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()

    let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.hidesWhenStopped = true
        spinner.style = .gray
        return spinner
    }()

    override func loadView() {
        view = tableView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "NewZ"

        render()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        spinner.startAnimating()
        newsService.updatePrograms { [spinner] result in

            defer {
                DispatchQueue.main.async {
                    spinner.stopAnimating()
                }
            }

            switch result {
            case .success(let response):

                for program in response.programs {
                    print(program.name)
                }

            case .failure(let error):
                fatalError("Epic fail: \(error.localizedDescription)")
            }
        }
    }

    private func render() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: spinner)
    }

}

extension ListViewController: UITableViewDelegate {

}

extension ListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}

