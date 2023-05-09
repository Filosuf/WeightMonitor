//
//  MainViewModel.swift
//  WeightMonitor
//
//  Created by Filosuf on 06.05.2023.
//

import Foundation

struct HistoryCellModel {
    let weight: String
    let change: String
    let date: String
}

protocol MainViewModel {

    var metricSystemState: Bool { get }
    var numberOfRowsInSection: Int { get }
    func fetchViewModelForCell(with indexPath: IndexPath) -> HistoryCellModel
    func changeMetricSystem(isOn: Bool)
    func showNewWeightMeasurement()
    func showEditWeightMeasurement(indexPath: IndexPath)

    //binding
    var metricSystemStateDidChange: ((Bool) -> Void)? { get set }
}

final class MainViewModelImpl: MainViewModel {

    // MARK: - Properties
    private let coordinator: MainCoordinator
    private let settingsStorage: SettingsStorageProtocol
    private let dateFormatter: DateTimeFormatter

    var numberOfRowsInSection: Int { weightMeasurements.count }
    var metricSystemState = false {
        didSet {
            metricSystemStateDidChange?(metricSystemState)
        }
    }
    var weightMeasurements: [WeightMeasurement] = []

    var metricSystemStateDidChange: ((Bool) -> Void)?

    // MARK: - Initialiser
    init(coordinator: MainCoordinator, settingsStorage: SettingsStorageProtocol, dateFormatter: DateTimeFormatter) {
        self.coordinator = coordinator
        self.settingsStorage = settingsStorage
        self.dateFormatter = dateFormatter
        initialization()
    }

    // MARK: - Methods
    private func initialization() {
        metricSystemState = settingsStorage.fetchMetricSystem()
        let date: Date = Date()
        let weight = WeightMeasurement(weight: 45, date: date)
        weightMeasurements = [weight, weight, weight, weight, weight, weight]
    }

    func fetchViewModelForCell(with indexPath: IndexPath) -> HistoryCellModel {
        guard weightMeasurements.count > indexPath.row else { return HistoryCellModel(weight: "", change: "", date: "") }

        let weightMeasurement = weightMeasurements[indexPath.row]

        let weight = convertWeightToString(value: weightMeasurement.weight)
        let date = convertDateToString(date: weightMeasurement.date)

        let cellViewModel = HistoryCellModel(weight: weight, change: "0,5", date: date)
        return cellViewModel
    }

    func changeMetricSystem(isOn: Bool) {
        settingsStorage.saveMetricSystem(isOn: isOn)
        metricSystemState = isOn
    }

    func showNewWeightMeasurement() {
        coordinator.showWeightMeasurement()
    }

    func showEditWeightMeasurement(indexPath: IndexPath) {
        if weightMeasurements.count > indexPath.row {
            let weightMeasurement = weightMeasurements[indexPath.row]
            coordinator.showWeightMeasurement(weightMeasurement: weightMeasurement)
        }
    }

    private func convertWeightToString(value: Double) -> String {
        let weightKg = Measurement(value: value, unit: UnitMass.kilograms)
        let weightLb = weightKg.converted(to: .pounds)
        let weightKgRound = Double(round(10 * weightKg.value) / 10)

        //Используя 'MeasurementFormatter()' не удалось получить Фунт на русском языке
        let weightString = metricSystemState ? "\(weightKgRound) " + "kg".localized : String(format: "pounds".localized, weightLb.value)
        return weightString
    }

    private func convertDateToString(date: Date) -> String {
        let components = Calendar.current.dateComponents([.year], from: Date(), to: date)
        let thisYear = components.year == 0
        let dateString = dateFormatter.dateToString(date: date, isShort: thisYear)
        return dateString
    }
}
