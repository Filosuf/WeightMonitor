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
//    private let newNavCon = UINavigationController()
//    private lazy var settingsFlowCoordinator = SettingsFlowCoordinator(navCon: newNavCon, controllersFactory: controllersFactory, dataStoreFactory: dataStoreFactory)

    //MARK: - Initialiser
    init(controllersFactory: ViewControllersFactory, settingsStorage: SettingsStorageProtocol) {
        self.controllersFactory = controllersFactory
        self.settingsStorage = settingsStorage
    }

    // MARK: - Methods
    func startApplication() -> UIViewController {
        let vc = controllersFactory.makeMainViewController(coordinator: self, settingsStorageService: settingsStorage)
        navCon = UINavigationController(rootViewController: vc)
        return navCon!
    }

    func showWeightMeasurement() {
        let vc = controllersFactory.makeWeightMeasurementViewController(coordinator: self, settingsStorageService: settingsStorage, weightMeasurement: nil)
        navCon?.present(vc, animated: true)
    }
}
