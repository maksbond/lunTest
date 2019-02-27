//
//  Error.swift
//  LunTest
//
//  Created by Maksym Bondar on 2/27/19.
//

import UIKit

/// Error domain for JSON errors.
let JSONErrorDomain: String = "JSONErrorDomain"

/// Error description key for JSON errors.
let JSONErrorDescription: String = "JSONErrorDescription"

/// Error code
enum JSONParserError: Int {
    /// File is not exist error key.
    case fileNotExistError = 0
    
    /// File read error key.
    case fileReadError = 1
}
