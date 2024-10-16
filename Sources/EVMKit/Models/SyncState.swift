//
//  SyncState.swift
//  EVMKit
//
//  Created by Sun on 2019/11/26.
//

import Foundation

// MARK: - SyncState

public enum SyncState {
    case synced
    case syncing(progress: Double?)
    case notSynced(error: Error)

    // MARK: Computed Properties

    public var notSynced: Bool {
        if case .notSynced = self {
            true
        } else {
            false
        }
    }

    public var syncing: Bool {
        if case .syncing = self {
            true
        } else {
            false
        }
    }

    public var synced: Bool {
        self == .synced
    }
}

// MARK: Equatable

extension SyncState: Equatable {
    public static func == (lhs: SyncState, rhs: SyncState) -> Bool {
        switch (lhs, rhs) {
        case (.synced, .synced): true
        case let (.syncing(lhsProgress), .syncing(rhsProgress)): lhsProgress == rhsProgress
        case let (.notSynced(lhsError), .notSynced(rhsError)): "\(lhsError)" == "\(rhsError)"
        default: false
        }
    }
}

// MARK: CustomStringConvertible

extension SyncState: CustomStringConvertible {
    public var description: String {
        switch self {
        case .synced: "synced"
        case let .syncing(progress): "syncing \(progress ?? 0)"
        case let .notSynced(error): "not synced: \(error)"
        }
    }
}
