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
    func showWeightMeasurement()


    //binding
    var metricSystemStateDidChange: ((Bool) -> Void)? { get set }
}

final class MainViewModelImpl: MainViewModel {

    // MARK: - Properties
    private let coordinator: MainCoordinator
    private let settingsStorage: SettingsStorageProtocol

    var numberOfRowsInSection: Int { 10 }
    var metricSystemState = false {
        didSet {
            metricSystemStateDidChange?(metricSystemState)
        }
    }
    var weightMeasurements: [WeightMeasurement] = []

    var metricSystemStateDidChange: ((Bool) -> Void)?

    // MARK: - Initialiser
    init(coordinator: MainCoordinator, settingsStorage: SettingsStorageProtocol) {
        self.coordinator = coordinator
        self.settingsStorage = settingsStorage
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

    func showWeightMeasurement() {
        coordinator.showWeightMeasurement()
    }

    func finishEditing() {
//        delegate.scheduleDidUpdate(schedule: schedule)
//        coordinator.pop()
    }

    private func convertWeightToString(value: Double) -> String {
        let weightKg = Measurement(value: value, unit: UnitMass.kilograms)
        let weightLb = weightKg.converted(to: .pounds)
        let weightKgRound = Double(round(10 * weightKg.value) / 10)

        //Используя 'MeasurementFormatter()' не удалось получить Фунт на русском языке
        let weightString = metricSystemState ? "\(weightKgRound) " + "kg".localized : String(format: "pounds".localized, weightLb.value)
        return weightString
    }

    private func getPreferredLocale() -> Locale {
        guard let preferredIdentifier = Locale.preferredLanguages.first else {
            return Locale.current
        }
        return Locale(identifier: preferredIdentifier)
    }

    private func convertDateToString(date: Date) -> String {
        let formatter = DateTimeFormatter()
        let components = Calendar.current.dateComponents([.year], from: Date(), to: date)
        let thisYear = components.year == 0
        let dateString = formatter.dateToString(date: date, isShort: thisYear)
        return dateString
    }
}
