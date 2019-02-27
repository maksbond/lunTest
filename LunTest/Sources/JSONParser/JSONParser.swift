//
//  JSONResults.swift
//  LunTest
//
//  Created by Maksym Bondar on 2/24/19.
//

import UIKit
import CoreLocation
import os

/// Paste data from Data.json. Present model of application.
class JSONParser {
    /// Store parsed data.
    private var jsonResult: [String: Any]?
    
    /// Initialize parser and get data from Data.json from Bundle.
    init(resource: String, with fileExtension: String) throws {
        let fileUrl = Bundle.main.url(forResource: resource, withExtension: fileExtension)
        if let fileUrl = fileUrl {
            os_log(.info, "Successfully get url to %{public}@.%{public}@ file.", resource, fileExtension)
            do {
                if try fileUrl.checkResourceIsReachable() {
                    let jsonData = try Data(contentsOf: fileUrl)
                    os_log(.info, "Successfully get json data.")
                    do {
                        self.jsonResult = try JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as? [String: Any]
                        os_log(.info, "Successfully completed json serilication from data of file.")
                    }
                }
            } catch {
                throw NSError(domain: JSONErrorDomain, code: JSONParserError.fileReadError.rawValue, userInfo: [JSONErrorDescription: "Can't get data from \(resource).\(fileExtension) file."])
            }
        } else {
            throw NSError(domain: JSONErrorDomain, code: JSONParserError.fileNotExistError.rawValue, userInfo: [JSONErrorDescription: "File \(resource).\(fileExtension) doesn't exist."])
        }
    }
    
    /// Returns info about person.
    private var person: [String: Any]? {
        if let jsonResult = jsonResult {
            return jsonResult["person"] as? [String: Any]
        }
        return nil
    }
    
    /// Returns info about images.
    private var images: [[String: Any]]? {
        if let jsonResult = jsonResult {
            return jsonResult["images"] as? [[String: Any]]
        }
        return nil
    }
    
    /// Returns person name.
    var personName: String {
        get {
            var name = "Unavailable"
            if let person = person, let personName = person["name"] as? String {
                name = personName
            }
            return name
        }
    }
    
    /// Returns person phone.
    var personPhoneNumber: String {
        get {
            var phoneNumber = "Unavailable"
            if let person = person, let personPhone = person["phone"] as? String {
                phoneNumber = personPhone
            }
            return phoneNumber
        }
    }
    
    /// Returns person image id.
    private var personProfileImageId: Int {
        get {
            var imageId = -1
            if let person = person, let personImageId = person["profile_image_id"] as? Int {
                imageId = personImageId
            }
            return imageId
        }
    }
    
    /// Returns person avatar.
    var personAvatarUrl: URL? {
        get {
            var avatarUrl = "Unavailable"
            if let images = images, let profileInfo = images.first(where: {$0["image_id"] as! Int == personProfileImageId})
            {
                avatarUrl = profileInfo["link"] as! String
            }
            return URL(string: avatarUrl)
        }
    }
    
    /// Returns name of avatar.
    var personAvatarName: String {
        get {
            var avatarName = "Unavailable"
            if let avatarPath = personAvatarUrl?.lastPathComponent {
                avatarName = avatarPath
            }
            return avatarName
        }
    }
    
    /// Returns latitude of person.
    var latitude: CLLocationDegrees {
        get {
            var latitude = CLLocationDegrees(exactly: 50.3867581)!
            if let person = person, let lat = person["lat"] as? Double {
                latitude = CLLocationDegrees(exactly: lat)!
            }
            return latitude
        }
    }
    
    /// Returns longitude of person.
    var longitude: CLLocationDegrees {
        get {
            var longitude = CLLocationDegrees(exactly: 30.470813)!
            if let person = person, let lng = person["lng"] as? Double {
                longitude = CLLocationDegrees(exactly: lng)!
            }
            return longitude
        }
    }
}
