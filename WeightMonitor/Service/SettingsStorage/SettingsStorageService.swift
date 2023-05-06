//
//  SettingsStorageService.swift
//  WeightMonitor
//
//  Created by Filosuf on 05.05.2023.
//

import Foundation

protocol SettingsStorageProtocol {
    var metricSystemIsOn: Bool { get set }
}

final class SettingsStorageService: SettingsStorageProtocol {

    // MARK: - Properties
    private let storage = UserDefaults.standard
    private let metricSystemKey = "metricSystem"

    var metricSystemIsOn: Bool {
        get {
            storage.bool(forKey: metricSystemKey)
        }
        set {
            storage.set(newValue, forKey: metricSystemKey)
        }
    }
}
