//
//  PersonTableViewCell.swift
//  LunTest
//
//  Created by Maksym Bondar on 2/24/19.
//

import UIKit

class PersonTableViewCell: UITableViewCell {
    /// Reuse identifier of cell.
    static public let reuseIdentifier = "personReuseIdentifier"
    
    /// Represent person name in cell.
    @IBOutlet var personNameLabel: UILabel!
    
    /// Represent person phone number.
    @IBOutlet var personPhoneNumberButton: UIButton!
    
    /// Represent person avatar.
    @IBOutlet var personAvatarImageView: UIImageView!
    
    /// Activiti indicator for image loading.
    @IBOutlet var imageLoadIndicator: UIActivityIndicatorView!
    
    /// Validate ukraininan phone number.
    private func validate(number: String) -> Bool {
        let PHONE_REGEX = "^380\\d{9}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result =  phoneTest.evaluate(with: number)
        return result
    }
    
    /// Calls by number.
    @IBAction func callToPerson(_ sender: UIButton) {
        let number = sender.titleLabel?.text?.filter("01234567890.".contains)
        if let number = number, validate(number: number) {
            guard let callUrl = URL(string: "tel://" + number) else { return }
            UIApplication.shared.open(callUrl)
        }
    }
    
}

// MARK: Extension for UIActivityIndicatorView and UIImageView cornerRadius.
@IBDesignable extension UIActivityIndicatorView {
    /// Set corner radius for layer of ActivityIndicator.
    @IBInspectable private var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            clipsToBounds = true
        }
    }
}

@IBDesignable extension UIImageView {
    /// Set corner radius for layer of ImageView.
    @IBInspectable private var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            clipsToBounds = true
        }
    }
}
