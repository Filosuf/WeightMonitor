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

    //MARK: - Initialiser
    init(controllersFactory: ViewControllersFactory, settingsStorage: SettingsStorageProtocol) {
        self.controllersFactory = controllersFactory
        self.settingsStorage = settingsStorage
    }

    // MARK: - Methods
    func startApplication() -> UIViewController {
        let vc = controllersFactory.makeMainViewController(coordinator: self, settingsStorageService: settingsStorage)
        navCon = UINavigationController(rootViewController: vc)
        navCon?.isNavigationBarHidden = true
        return navCon!
    }

    func showWeightMeasurement() {
        let vc = controllersFactory.makeWeightMeasurementViewController(coordinator: self, settingsStorageService: settingsStorage, weightMeasurement: nil)
        navCon?.present(vc, animated: true)
    }
}
