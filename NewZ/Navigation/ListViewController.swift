//
//  ViewController.swift
//  NewZ
//
//  Created by Alexander Larsson on 2019-05-13.
//  Copyright © 2019 Alexander Larsson. All rights reserved.
//

import UIKit
import CoreData

class ListViewController: UIViewController {

    let model: Model

    private lazy var tableView: UITableView = { [unowned self] in
        let tableView = UITableView()
        tableView.register(ProgramCell.self, forCellReuseIdentifier: String(describing: ProgramCell.self))
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

    fileprivate lazy var fetchedResultsController: NSFetchedResultsController<Program> = {
        let fetchRequest: NSFetchRequest<Program> = Program.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: #keyPath(Program.name), ascending: true)]
        let fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: model.persistentContainer.viewContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        fetchedResultsController.delegate = self

        return fetchedResultsController
    }()

    init(model: Model) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

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

        // Perform fetch
        do {
            try self.fetchedResultsController.performFetch()
            tableView.reloadData()
        } catch {
            let fetchError = error as NSError
            print("Unable to Perform Fetch Request")
            print("\(fetchError), \(fetchError.localizedDescription)")
        }

        spinner.startAnimating()

        model.updatePrograms { [weak self] success in
            DispatchQueue.main.async {
                self?.spinner.stopAnimating()
            }
        }
    }

    private func render() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: spinner)
    }

}

extension ListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.fetchedObjects?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ProgramCell.self))
        guard let programCell = cell as? ProgramCell else {
            fatalError("Unsupported cell type")
        }

        let program = fetchedResultsController.object(at: indexPath)
        programCell.update(with: program)
        
        return programCell
    }
}

extension ListViewController: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.reloadData()
    }
}
