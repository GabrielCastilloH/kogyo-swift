//
//  Helper.swift
//  App1
//
//  Created by Gabriel Castillo on 6/14/24.
//

import UIKit

public struct Helper: Codable {
    let name: String
    let profileImageName: String
    let description: String

    enum CodingKeys: String, CodingKey {
        case name
        case profileImageName
        case description
    }
}
