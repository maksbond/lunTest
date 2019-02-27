//
//  PersonListTableViewController+UI.swift
//  LunTest
//
//  Created by Maksym Bondar on 2/27/19.
//

import UIKit

extension PersonListTableViewController {
    /// Shows alert according to error.
    func show(_ error: NSError) {
        var message = "Unknown error."
        if error.domain == JSONErrorDomain, let errorDescription = error.userInfo[JSONErrorDescription] as? String {
            message = errorDescription
        }
        
        showAlert("Error", message)
    }
    
    /// Shows alert with title and message.
    func showAlert(_ title: String, _ message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
}
