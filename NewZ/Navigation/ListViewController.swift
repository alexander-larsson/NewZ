//
//  ViewController.swift
//  NewZ
//
//  Created by Alexander Larsson on 2019-05-13.
//  Copyright © 2019 Alexander Larsson. All rights reserved.
//

import UIKit

class ListViewController: UIViewController {

    private lazy var tableView: UITableView = { [unowned self] in
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()

    override func loadView() {
        view = tableView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "NewZ"
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

