//
//  MainCoordinator.swift
//  WeightMonitor
//
//  Created by Filosuf on 05.05.2023.
//

import UIKit

final class MainCoordinator {

    // MARK: - Properties
    private var navCon: UINavigationController?
    private let controllersFactory: ViewControllersFactory
    private let settingsStorage: SettingsStorageProtocol
    private let converter: MeasurementConverter
    private let dateFormatter: DateTimeFormatter
    private let weightDataStore: WeightDataStore

    private var weightMeasurementVC: WeightMeasurementViewController?

    //MARK: - Initialiser
    init(
        controllersFactory: ViewControllersFactory,
        settingsStorage: SettingsStorageProtocol,
        converter: MeasurementConverter,
        dateFormatter: DateTimeFormatter,
        weightDataStore: WeightDataStore
    ) {
        self.controllersFactory = controllersFactory
        self.settingsStorage = settingsStorage
        self.converter = converter
        self.dateFormatter = dateFormatter
        self.weightDataStore = weightDataStore
    }

    // MARK: - Methods
    func startApplication() -> UIViewController {
        let vc = controllersFactory.makeMainViewController(
            coordinator: self,
            settingsStorageService: settingsStorage,
            dateFormatter: dateFormatter,
            weightDataStore: weightDataStore,
            converter: converter
        )
        navCon = UINavigationController(rootViewController: vc)
        navCon?.isNavigationBarHidden = true
        return navCon!
    }

    func showWeightMeasurement(weightMeasurement: WeightMeasurement? = nil) {
        let vc = controllersFactory.makeWeightMeasurementViewController(
            coordinator: self,
            settingsStorageService: settingsStorage,
            converter: converter,
            dateFormatter: dateFormatter,
            weightDataStore: weightDataStore,
            weightMeasurement: weightMeasurement
        )
        weightMeasurementVC = vc
        navCon?.present(vc, animated: true)
    }

    func dismiss() {
        weightMeasurementVC?.dismiss(animated: true, completion: nil)
    }
}
