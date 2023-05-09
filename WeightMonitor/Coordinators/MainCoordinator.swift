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
    private let convertor: MeasurementConvertor
    private let dateFormatter: DateTimeFormatter

    private var weightMeasurementVC: WeightMeasurementViewController?

    //MARK: - Initialiser
    init(controllersFactory: ViewControllersFactory, settingsStorage: SettingsStorageProtocol, convertor: MeasurementConvertor, dateFormatter: DateTimeFormatter) {
        self.controllersFactory = controllersFactory
        self.settingsStorage = settingsStorage
        self.convertor = convertor
        self.dateFormatter = dateFormatter
    }

    // MARK: - Methods
    func startApplication() -> UIViewController {
        let vc = controllersFactory.makeMainViewController(coordinator: self, settingsStorageService: settingsStorage, dateFormatter: dateFormatter)
        navCon = UINavigationController(rootViewController: vc)
        navCon?.isNavigationBarHidden = true
        return navCon!
    }

    func showWeightMeasurement(weightMeasurement: WeightMeasurement? = nil) {
        let vc = controllersFactory.makeWeightMeasurementViewController(coordinator: self, settingsStorageService: settingsStorage, convertor: convertor, dateFormatter: dateFormatter, weightMeasurement: nil)
        weightMeasurementVC = vc
        navCon?.present(vc, animated: true)
    }

    func dismiss() {
        weightMeasurementVC?.dismiss(animated: true, completion: nil)
    }
}
