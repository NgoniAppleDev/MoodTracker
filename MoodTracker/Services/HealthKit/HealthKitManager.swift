//
//  HealthKitManager.swift
//  MoodTracker
//
//  Created by Ngoni Katsidzira  on 25/8/2026.
//

import Observation
import SwiftUI
import HealthKit
import os

@Observable
class HealthKitManager {
    
    static let shared: HealthKitManager = .init()
    
    let healthStore: HKHealthStore
    
    // MARK: - Initializer
    private init() {
        
        guard HKHealthStore.isHealthDataAvailable() else {
            fatalError("HealthKit is unavailable on this device.")
        }
        
        self.healthStore = HKHealthStore()
        
        self.startStateOfMindObservation()
    }
    
    
    // MARK: - Properties
    
    private static let StateOfMindType = HKObjectType.stateOfMindType()
    let allTypes: Set = [
        StateOfMindType
    ]
    
    private(set) var authenticated = false
    var isAuthenticated: Bool {
        authenticated == true
    }
    var trigger = false
    
    private var anchor: HKQueryAnchor?
    private var isObservingInTheBackground = false
    
    var stateOfMindData: [HKStateOfMind] = []
}


// MARK: - Methods

extension HealthKitManager {
    
    // MARK: authorizations
    
    private func requestAuthorization() async throws {
        
        do {
            if HKHealthStore.isHealthDataAvailable() {
                
                try await healthStore.requestAuthorization(toShare: allTypes, read: allTypes)
                self.authenticated = true
                self.startStateOfMindObservation()
                
            } else {
                throw HealthKitError.healthKitNotAvailable
            }
        } catch {
            
            throw HealthKitError.permissionDenied
        }
    }
    
    private func checkAuthorizationStatusForStateOfMind() -> HKAuthorizationStatus {
        healthStore.authorizationStatus(for: HealthKitManager.StateOfMindType)
    }
    
    
    // MARK: Saving State of Mind
    
    private func createHKStateOfMindSample(
        for kind: HKStateOfMind.Kind,
        onDate date: Date = .now,
        withValence valence: Double,
        labels: [HKStateOfMind.Label],
        associations: [HKStateOfMind.Association],
        andMetaData metaData: [String: Any]? = nil
    ) async throws -> HKStateOfMind {
        
        let authorizationStatus = self.checkAuthorizationStatusForStateOfMind()
        
        switch authorizationStatus {
        case .notDetermined:
            try await self.requestAuthorization()
            
            guard checkAuthorizationStatusForStateOfMind() == .sharingAuthorized else {
                throw HealthKitError.permissionDenied
            }
            
        case .sharingAuthorized:
            break
        case .sharingDenied:
            throw HealthKitError.permissionDenied
        @unknown default:
            throw HealthKitError.permissionDenied
        }
        
        return .init(
            date: date,
            kind: kind,
            valence: valence,
            labels: labels,
            associations: associations,
            metadata: metaData
        )
        
    }
    
    func save(
        for kind: HKStateOfMind.Kind,
        onDate date: Date = .now,
        withValence valence: Double,
        labels: [HKStateOfMind.Label],
        associations: [HKStateOfMind.Association],
        andMetaData metaData: [String: Any]? = nil
    ) async throws {
        
        let sample = try await self.createHKStateOfMindSample(for: kind, onDate: date, withValence: valence, labels: labels, associations: associations, andMetaData: metaData)
        
        do {
            try await healthStore.save(sample)
            
        } catch let error as HKError {
            
            switch error.code {case .errorAuthorizationDenied:
                throw HealthKitError.permissionDenied
            case .errorDatabaseInaccessible:
                throw HealthKitError.deviceLocked
            case .errorInvalidArgument:
                throw HealthKitError.invalidSample
            default:
                throw HealthKitError.saveFailed(underlying: error)
            }
        } catch {
            throw HealthKitError.saveFailed(underlying: error)
        }
    }
    
    
    // MARK: Reading State of Mind
    
    func startStateOfMindObservation() {
        
        guard !isObservingInTheBackground else { return }
        
        let type = HealthKitManager.StateOfMindType
        
        let observerQuery = HKObserverQuery(sampleType: type, predicate: nil) { [weak self] _, completion, error in
            
            defer { completion() }
            
            if let error = error {
                logger.error("Observer query failed: \(error.localizedDescription)")
                return
            }
            
            Task {
                do {
                    try await self?.fetchStateOfMindUpdates()
                } catch {
                    logger.error("Failed to fetch State of Mind updates: \(error.localizedDescription)")
                }
            }
        }
        
        healthStore.execute(observerQuery)
        
        Task {
            do {
                try await healthStore.enableBackgroundDelivery(for: type, frequency: .immediate)
                isObservingInTheBackground = true
            } catch {
                logger.error("Failed to enable background delivery: \(error.localizedDescription)")
                isObservingInTheBackground = false
            }
        }
    }
    
    private func fetchStateOfMindUpdates() async throws {
        
        let authorizationStatus = self.checkAuthorizationStatusForStateOfMind()
        
        if authorizationStatus == .notDetermined {
            try await self.requestAuthorization()
        }
        
        logger.info("\n\(#function): Authorization \(authorizationStatus == .sharingAuthorized ? "Success ✅" : "Failed ❌")")
        
        let descriptor = HKAnchoredObjectQueryDescriptor(
            predicates: [.stateOfMind()],
            anchor: anchor,
            limit: HKObjectQueryNoLimit
        )
        
        for try await result in descriptor.results(for: healthStore) {
            self.anchor = result.newAnchor
            
            let newSamples: [HKStateOfMind] = result.addedSamples
            let deletedSamples = result.deletedObjects
            
            logger.info("\n\(#function): newSamples: \(newSamples.count), First: \(newSamples.first)")
            logger.info("\n\(#function): deletedSamples: \(deletedSamples.count), First: \(deletedSamples.first)")
            
            await MainActor.run {
                stateOfMindData.removeAll { existing in
                    deletedSamples.contains { $0.uuid == existing.uuid }
                }
                stateOfMindData.append(contentsOf: newSamples)
            }
        }
    }
}


// MARK: - Register HealthKitManager to Environment

extension EnvironmentValues {
    
    @Entry var healthKitManager: HealthKitManager = .shared
}
