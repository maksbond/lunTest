//
//  PersonListTableViewController.swift
//  LunTest
//
//  Created by Maksym Bondar on 2/24/19.
//

import UIKit
import CoreLocation

class PersonListTableViewController: UITableViewController {
    /// Results of JSON parsing.
    private var json: JSONParser?
    
    /// Selected person name.
    private var selectedPersonName: String?
    
    // MARK: View Controller lifecycle
    /// Setup all data.
    override func viewDidLoad() {
        super.viewDidLoad()
        json = JSONParser()
        
        DispatchQueue.global().async {
            guard let json = self.json else { return }
            let documentsDirectoryPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first! as String
            let urlToAvatar = URL(fileURLWithPath: documentsDirectoryPath).appendingPathComponent(json.personAvatarName)
            let fileManager = FileManager.default
            if !fileManager.fileExists(atPath: urlToAvatar.path), let imagePath = json.personAvatarUrl {
                do {
                    let imageData = try Data(contentsOf: imagePath)
                    print("Image is loaded")
                    try imageData.write(to: urlToAvatar, options: .atomic)
                    DispatchQueue.main.async {
                        print("Reload data")
                        let visibleCells = self.tableView.visibleCells
                        let indexPaths = visibleCells.compactMap({ self.tableView.indexPath(for: $0)})
                        self.tableView.reloadRows(at: indexPaths, with: .automatic)
                    }
                } catch {
                    print("Error: Unable to load data")
                }
            }
        }
    }
    
    /// Setup initial value for MapInfoViewController during segue.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == MapInfoViewController.segueIdentifier, let destinatioVC = segue.destination as? MapInfoViewController {
            guard let json = json else { return }
            destinatioVC.initialLocation = CLLocation(latitude: json.latitude, longitude: json.longitude)
            destinatioVC.personName = selectedPersonName
        }
    }
    
    // MARK: UITableViewDataSource
    /// Return number of persons in list.
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    
    /// Setup Table view cells.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let personCell = tableView.dequeueReusableCell(withIdentifier: PersonTableViewCell.reuseIdentifier, for: indexPath) as? PersonTableViewCell
        
        if let cell = personCell, let json = self.json {
            cell.personNameLabel.text = json.personName
            cell.personPhoneNumberButton.setTitle(json.personPhoneNumber, for: .normal)
            if let image = self.avatarImage() {
                if cell.imageLoadIndicator.isAnimating {
                    DispatchQueue.main.async {
                        UIView.animate(withDuration: 0.5, animations: {
                            cell.imageLoadIndicator.alpha = 0
                        }, completion: { _ in
                            cell.imageLoadIndicator.stopAnimating()
                            cell.imageLoadIndicator.isHidden = true
                        })
                    }
                } else {
                    DispatchQueue.main.async {
                        cell.personAvatarImageView.alpha = 0
                        UIView.animate(withDuration: 0.5, animations: {
                            cell.personAvatarImageView.alpha = 1
                            cell.imageLoadIndicator.alpha = 0
                        }, completion: { _ in
                            cell.imageLoadIndicator.isHidden = true
                        })
                    }
                }
                cell.personAvatarImageView.image = image
            } else {
                cell.imageLoadIndicator.startAnimating()
            }
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    // MARK: UITableViewDelegate
    /// Perform segue for show of user coordinates.
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let personCell = tableView.cellForRow(at: indexPath) as? PersonTableViewCell
        if let personCell = personCell {
            selectedPersonName = personCell.personNameLabel.text
        }
        self.performSegue(withIdentifier: MapInfoViewController.segueIdentifier, sender: self)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    // MARK: Extra methods.
    /// Get avatar image if it's possible.
    private func avatarImage() -> UIImage? {
        var image: UIImage? = nil
        guard let json = json else {
            return nil
        }
        let documentsDirectoryPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first! as String
        let urlToAvatar = URL(fileURLWithPath: documentsDirectoryPath).appendingPathComponent(json.personAvatarName)
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: urlToAvatar.path) {
            image = UIImage(contentsOfFile: urlToAvatar.path)
        }
        return image
    }
}

