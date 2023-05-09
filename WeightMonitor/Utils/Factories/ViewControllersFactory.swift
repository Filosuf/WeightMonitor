//
//  ViewControllersFactory.swift
//  WeightMonitor
//
//  Created by Filosuf on 05.05.2023.
//

import Foundation

final class ViewControllersFactory {

    func makeMainViewController(
        coordinator: MainCoordinator,
        settingsStorageService: SettingsStorageProtocol,
        dateFormatter: DateTimeFormatter,
        weightDataStore: WeightDataStore,
        converter: MeasurementConverter
    ) -> MainViewController {

        let viewModel = MainViewModelImpl(
            coordinator: coordinator,
            settingsStorage: settingsStorageService,
            dateFormatter: dateFormatter,
            weightDataStore: weightDataStore,
            converter: converter
        )
        let viewController = MainViewController(viewModel: viewModel)
        return viewController
    }

    func makeWeightMeasurementViewController(
        coordinator: MainCoordinator,
        settingsStorageService: SettingsStorageProtocol,
        converter: MeasurementConverter,
        dateFormatter: DateTimeFormatter,
        weightDataStore: WeightDataStore,
        delegate: WeightMeasurementViewModelDelegate?,
        weightMeasurement: WeightMeasurement?
    ) -> WeightMeasurementViewController {

        let viewModel = WeightMeasurementViewModelImpl(
            coordinator: coordinator,
            settingsStorage: settingsStorageService,
            converter: converter,
            dateFormatter: dateFormatter,
            weightDataStore: weightDataStore,
            weightMeasurement: weightMeasurement
        )
        viewModel.delegate = delegate
        let viewController = WeightMeasurementViewController(viewModel: viewModel)
        return viewController
    }
}
