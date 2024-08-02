//
//  Enums.swift
//  Kogyo
//
//  Created by Gabriel Castillo on 8/1/24.
//

import Foundation

enum UserKind {
    case user
    case helper
    case other
}

enum DataCollection {
    case helpers
    case users
    case tasks
}

enum CompletionStatus {
    case complete
    case notComplete
    case inReview
}

enum StorageFolder {
    case completion
    case jobs
    case profile
}
