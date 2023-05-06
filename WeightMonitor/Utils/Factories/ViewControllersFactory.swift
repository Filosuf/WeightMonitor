//
//  ViewControllersFactory.swift
//  WeightMonitor
//
//  Created by Filosuf on 05.05.2023.
//

import Foundation

final class ViewControllersFactory {

    func makeMainViewController(coordinator: MainCoordinator, settingsStorageService: SettingsStorageProtocol) -> MainViewController {
        let viewController = MainViewController(coordinator: coordinator)
        return viewController
    }

    func makeWeightMeasurementViewController(coordinator: MainCoordinator, settingsStorageService: SettingsStorageProtocol, weightMeasurement: WeightMeasurement?) -> WeightMeasurementViewController {
        let viewController = WeightMeasurementViewController()
        return viewController
    }
}
