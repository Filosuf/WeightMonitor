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
    func deleteWeightMeasurement(with indexPath: IndexPath)

    //binding
    var metricSystemStateDidChange: ((Bool) -> Void)? { get set }
    var weightMeasurementsDidChange: (() -> Void)? { get set }
    var toastMessageGenerated: ((String) -> Void)? { get set }
}

final class MainViewModelImpl: MainViewModel {

    // MARK: - Properties
    private let coordinator: MainCoordinator
    private let settingsStorage: SettingsStorageProtocol
    private let dateFormatter: DateTimeFormatter
    private let weightDataStore: WeightDataStore
    private let converter: MeasurementConverter

    var numberOfRowsInSection: Int { weightMeasurements.count }
    private(set) var metricSystemState = false {
        didSet {
            metricSystemStateDidChange?(metricSystemState)
        }
    }
    private(set) var weightMeasurements: [WeightMeasurement] = [] {
        didSet {
            weightMeasurementsDidChange?()
        }
    }
    private(set) var toastMessage = "" {
        didSet {
            toastMessageGenerated?(toastMessage)
        }
    }

    var metricSystemStateDidChange: ((Bool) -> Void)?
    var weightMeasurementsDidChange: (() -> Void)?
    var toastMessageGenerated: ((String) -> Void)?

    // MARK: - Initialiser
    init(coordinator: MainCoordinator,
         settingsStorage: SettingsStorageProtocol,
         dateFormatter: DateTimeFormatter,
         weightDataStore: WeightDataStore,
         converter: MeasurementConverter
    ) {
        self.coordinator = coordinator
        self.settingsStorage = settingsStorage
        self.dateFormatter = dateFormatter
        self.weightDataStore = weightDataStore
        self.converter = converter
        initialization()
    }

    // MARK: - Methods
    private func initialization() {
        metricSystemState = settingsStorage.fetchMetricSystem()
        updateWeightMeasurements()
        addObserverContextCoreData()
    }

    func fetchViewModelForCell(with indexPath: IndexPath) -> HistoryCellModel {
        guard weightMeasurements.count > indexPath.row else { return HistoryCellModel(weight: "", change: "", date: "") }

        let weightMeasurement = weightMeasurements[indexPath.row]

        let weight = convertWeightToString(value: weightMeasurement.weight)
        let change = calcChange(with: indexPath.row)
        let date = convertDateToString(date: weightMeasurement.date)

        let cellViewModel = HistoryCellModel(weight: weight, change: change, date: date)
        return cellViewModel
    }

    func changeMetricSystem(isOn: Bool) {
        settingsStorage.saveMetricSystem(isOn: isOn)
        metricSystemState = isOn
    }

    func showNewWeightMeasurement() {
        coordinator.showWeightMeasurement(delegate: self)
    }

    func showEditWeightMeasurement(indexPath: IndexPath) {
        if weightMeasurements.count > indexPath.row {
            let weightMeasurement = weightMeasurements[indexPath.row]
            coordinator.showWeightMeasurement(delegate: self, weightMeasurement: weightMeasurement)
        }
    }

    func deleteWeightMeasurement(with indexPath: IndexPath) {
        guard weightMeasurements.count > indexPath.row else { return }
        let weightMeasurement = weightMeasurements[indexPath.row]
        weightDataStore.delete(weightMeasurement)
    }

    private func calcChange(with index: Int) -> String {
        guard weightMeasurements.count > index + 1 else { return ""}
        let changeKg = weightMeasurements[index].weight - weightMeasurements[index + 1].weight
        var change = convertWeightToString(value: changeKg)
        if changeKg > 0 {
            change = "+" + change
        }
        return change
    }

    private func updateWeightMeasurements() {
        weightMeasurements = weightDataStore.fetchWeightMeasurements()
    }

    private func convertWeightToString(value: Double) -> String {
        converter.convertWeightToString(value: value, valueIsMetric: metricSystemState) ?? ""
    }

    private func convertDateToString(date: Date) -> String {
        let components = Calendar.current.dateComponents([.year], from: Date(), to: date)
        let thisYear = components.year == 0
        let dateString = dateFormatter.dateToString(date: date, isShort: thisYear)
        return dateString
    }

    private func addObserverContextCoreData() {
        NotificationCenter.default
            .addObserver(
                forName: weightDataStore.notificationName,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                self?.updateWeightMeasurements()
            }
    }
}

extension MainViewModelImpl: WeightMeasurementViewModelDelegate {
    func editingOfWeightMeasurementIsCompleted(isNewWeightMeasurement: Bool) {
        toastMessage = isNewWeightMeasurement ? "addedNewMeasurement".localized : "measurementChanged".localized
    }
}
