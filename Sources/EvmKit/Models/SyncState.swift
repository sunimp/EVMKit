//
//  SyncState.swift
//  EvmKit
//
//  Created by Sun on 2024/8/21.
//

import Foundation

// MARK: - SyncState

public enum SyncState {
    case synced
    case syncing(progress: Double?)
    case notSynced(error: Error)

    public var notSynced: Bool {
        if case .notSynced = self { true } else { false }
    }

    public var syncing: Bool {
        if case .syncing = self { true } else { false }
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
        case (.syncing(let lhsProgress), .syncing(let rhsProgress)): lhsProgress == rhsProgress
        case (.notSynced(let lhsError), .notSynced(let rhsError)): "\(lhsError)" == "\(rhsError)"
        default: false
        }
    }
}

// MARK: CustomStringConvertible

extension SyncState: CustomStringConvertible {
    public var description: String {
        switch self {
        case .synced: "synced"
        case .syncing(let progress): "syncing \(progress ?? 0)"
        case .notSynced(let error): "not synced: \(error)"
        }
    }
}
