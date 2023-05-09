//
//  ViewControllersFactory.swift
//  WeightMonitor
//
//  Created by Filosuf on 05.05.2023.
//

import Foundation

final class ViewControllersFactory {

    func makeMainViewController(coordinator: MainCoordinator, settingsStorageService: SettingsStorageProtocol, dateFormatter: DateTimeFormatter) -> MainViewController {
        let viewModel = MainViewModelImpl(coordinator: coordinator, settingsStorage: settingsStorageService, dateFormatter: dateFormatter)
        let viewController = MainViewController(viewModel: viewModel)
        return viewController
    }

    func makeWeightMeasurementViewController(coordinator: MainCoordinator, settingsStorageService: SettingsStorageProtocol, convertor: MeasurementConvertor, dateFormatter: DateTimeFormatter, weightMeasurement: WeightMeasurement?) -> WeightMeasurementViewController {
        let viewModel = WeightMeasurementViewModelImpl(coordinator: coordinator, settingsStorage: settingsStorageService, convertor: convertor,dateFormatter: dateFormatter, weightMeasurement: weightMeasurement)
        let viewController = WeightMeasurementViewController(viewModel: viewModel)
        return viewController
    }
}
