//
//  SettingsStorageService.swift
//  WeightMonitor
//
//  Created by Filosuf on 05.05.2023.
//

import Foundation

protocol SettingsStorageProtocol {
    func saveMetricSystem(isOn: Bool)
    func fetchMetricSystem() -> Bool
}

final class SettingsStorageService: SettingsStorageProtocol {

    // MARK: - Properties
    private let storage = UserDefaults.standard
    private let metricSystemKey = "metricSystem"

    // MARK: - Methods
    func saveMetricSystem(isOn: Bool) {
        storage.set(isOn, forKey: metricSystemKey)
    }

    func fetchMetricSystem() -> Bool {
        storage.bool(forKey: metricSystemKey)
    }
}
