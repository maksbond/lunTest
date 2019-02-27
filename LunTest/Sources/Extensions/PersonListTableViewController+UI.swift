//
//  PersonListTableViewController+UI.swift
//  LunTest
//
//  Created by Maksym Bondar on 2/27/19.
//

import UIKit

extension PersonListTableViewController {
    /// Show alerts according to error.
    func show(_ error: NSError) {
        var message = "Unknown error."
        if error.domain == JSONErrorDomain, let errorDescription = error.userInfo[JSONErrorDescription] as? String {
            message = errorDescription
        }
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
}
