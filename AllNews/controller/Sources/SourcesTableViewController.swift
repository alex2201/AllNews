//
//  SourcesTableViewController.swift
//  AllNews
//
//  Created by Alexander Lopez Cedillo on 22/04/20.
//  Copyright © 2020 Alexander Lopez Cedillo. All rights reserved.
//

import UIKit
import CoreData

class SourcesTableViewController: UITableViewController {
    // MARK: - Outlets
    
    // MARK: - Private properties
    private let viewModel = SourceViewModel()
    
    // MARK: - Public properties
    var sourcesStatus: [(source: SourceElement, isSaved: Bool)] {
        return viewModel.sourcesStatus
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.setup()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sourcesStatus.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "sourceCell", for: indexPath) as! SourceTableViewCell
        let sourceStatus = sourcesStatus[indexPath.row]
        
        cell.sourceLabel.text = sourceStatus.source.name
        cell.accessoryType = sourceStatus.isSaved ? .checkmark : .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 75.0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let source = sourcesStatus[indexPath.row]
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = source.isSaved ? .none : .checkmark
        if source.1 {
            viewModel.removeSource(withId: source.0.id)
        } else {
            viewModel.insertSource(withId: source.0.id)
        }
        
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension SourcesTableViewController {
    private func setupTableView() {
        let loadingNib = UINib(nibName: "SourceTableViewCell", bundle: nil)
        tableView.register(loadingNib, forCellReuseIdentifier: "sourceCell")
    }
    
    private func setupViewModel() {
        viewModel.delegate = self
    }
}

extension SourcesTableViewController: SourceViewModelDelegate {
    
    func didFinishLoading(_ viewModel: SourceViewModel) {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}
