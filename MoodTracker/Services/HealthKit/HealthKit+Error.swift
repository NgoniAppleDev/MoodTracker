//
//  HealthKit+Error.swift
//  MoodTracker
//
//  Created by Ngoni Katsidzira  on 25/8/2026.
//

import Foundation

enum HealthKitError: LocalizedError {
    
    case healthKitNotAvailable
    case permissionDenied
    case saveFailed(underlying: Error)
    case deviceLocked
    case invalidSample
    
    var errorDescription: String {
        switch self {
        case .healthKitNotAvailable:
            "The Apple Health app is not available on this device."
        case .permissionDenied:
            "This device is denied permission to access Apple Health app."
        case .saveFailed(_), .deviceLocked, .invalidSample:
            "Failed to save your state of mind to Apple Health app."
        }
    }
    
    var failureReason: String {
        switch self {
        case .healthKitNotAvailable:
            "This device may be an older model or does not support Apple Health app yet."
        case .permissionDenied:
            "Permission may have been not allowed or turned off in the app's settings."
        case .saveFailed(let underlyingError):
            "\(underlyingError.localizedDescription)"
        case .deviceLocked:
            "The device is locked."
        case .invalidSample:
            "The data supplied was corrupt."
        }
    }
    
    var recoverySuggestion: String {
        switch self {
        case .healthKitNotAvailable:
            "Check if the device has the Apple Health app installed."
        case .permissionDenied:
            "Go to Apple Health app settings > Data Access & Devices > Mood Tracker."
        case .saveFailed(_):
            "Make sure you have given Mood Tracker permission to write to Apple Health app."
        case .deviceLocked:
            "Unlock the device and try again."
        case .invalidSample:
            "Try again."
        }
    }
}
