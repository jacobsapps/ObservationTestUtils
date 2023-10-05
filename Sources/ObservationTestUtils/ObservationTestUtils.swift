//
//  ObservationTestUtils.swift
//  ObservationTestUtils
//
//  Created by Jacob Bartlett on 05/10/2023.
//

import Foundation
import Observation
import XCTest

public extension XCTestCase {
    
    /// Waits for changes to a property at a given key path of an `@Observable` entity.
    ///
    /// Uses the Observation framework's global `withObservationTracking` function to track changes to a specific property.
    /// By using wildcard assignment (`_ = ...`), we 'touch' the property without wasting CPU cycles.
    ///
    /// - Parameters:
    ///   - keyPath: The key path of the property to observe.
    ///   - parent: The observable view model that contains the property.
    ///   - timeout: The time (in seconds) to wait for changes before timing out. Defaults to `1.0`.
    ///
    func waitForChanges<T, U>(to keyPath: KeyPath<T, U>, on parent: T, timeout: Double = 1.0) {
        let exp = expectation(description: #function)
        withObservationTracking {
            _ = parent[keyPath: keyPath]
        } onChange: {
            exp.fulfill()
        }
        waitForExpectations(timeout: timeout)
    }
    
    /// Asynchronously awaits changes to a property at a given key path of an `@Observable` entity.
    ///
    /// Uses the Observation framework's global `withObservationTracking` function to track changes to a specific property.
    /// By using wildcard assignment (`_ = ...`), we 'touch' the property without wasting CPU cycles.
    ///
    /// - Parameters:
    ///   - keyPath: The key path of the property to observe.
    ///   - parent: The observable view model that contains the property.
    ///   - timeout: The time (in seconds) to wait for changes before timing out. Defaults to `1.0`.
    ///
    func awaitChanges<T, U>(to keyPath: KeyPath<T, U>, on parent: T, timeout: Double = 1.0) async {
        let exp = expectation(description: #function)
        withObservationTracking {
            _ = parent[keyPath: keyPath]
        } onChange: {
            exp.fulfill()
        }
        await fulfillment(of: [exp], timeout: timeout)
    }
}
