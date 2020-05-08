//
//  ConfigurationViewController.swift
//  AllNews
//
//  Created by Alexander Lopez Cedillo on 13/04/20.
//  Copyright © 2020 Alexander Lopez Cedillo. All rights reserved.
//

import UIKit

class ConfigurationViewController: UITableViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var selectedLanguageLabel: UILabel!
    
    // MARK: - Private properties
    private let configurationContent = [
        "Language",
    ]
    private var language: Language {
        return UserSettings.shared.language
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setup()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = .clear
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(forIndexPath: indexPath)
    }
    
    private func performSegue(forIndexPath indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            performSegue(withIdentifier: "toLanguageSelection", sender: self)
        default:
            break
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

// MARK: - Setup
extension ConfigurationViewController {
    private func setup(){
        let languageDescription = LanguageDescription(forValue: language.rawValue)
        selectedLanguageLabel.text = languageDescription?.rawValue
    }
}
