//
//  Job.swift
//  App1
//
//  Created by Gabriel Castillo on 6/10/24.
//

import UIKit

struct Job {
    let jobUID: String?
    let dateAdded: Date
    let kind: String
    let description: String
    let dateTime: Date
    let expectedHours: Int
    let location: String // change later
    let payment: Int
    let helper: String?
}
