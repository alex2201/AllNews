//
//  LanguageSelectionTableViewController.swift
//  AllNews
//
//  Created by Alexander Lopez Cedillo on 04/05/20.
//  Copyright © 2020 Alexander Lopez Cedillo. All rights reserved.
//

import UIKit

class LanguageSelectionTableViewController: UITableViewController {
    
    // MARK: - Private properties
    private let languages = Language.allCases
    private var language: Language {
        return UserSettings.shared.language
    }

    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return languages.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        let cellLanguage: Language = languages[indexPath.row]
        
        cell.textLabel?.text = LanguageDescription(forValue: cellLanguage.rawValue)?.rawValue
        cell.textLabel?.textColor = UIColor(named: "TextPrimaryColor")
        cell.tintColor = UIColor(named: "TextPrimaryMutedColor")
        
        if language == cellLanguage {
            cell.accessoryType = .checkmark
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = .clear
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cellLanguage: Language = languages[indexPath.row]
        UserDefaults.standard.setValue(cellLanguage.rawValue, forKey: "language")
        UserSettings.shared.set(language: cellLanguage)
        tableView.reloadData()
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
