//
//  WeightMeasurementViewModel.swift
//  WeightMonitor
//
//  Created by Filosuf on 08.05.2023.
//

import Foundation

protocol WeightMeasurementViewModelDelegate: AnyObject {
    func editingOfWeightMeasurementIsCompleted(isNewWeightMeasurement: Bool)
}

protocol WeightMeasurementViewModel {

    var dateState: Date { get }
    var metricSystem: Bool { get }
    var isNewWeightMeasurement: Bool { get }
    var weightValue: String? { get }
    var measurementValue: String? { get }
    var dateString: String? { get }

    //methods
    func dateChanged(with date: Date)
    func weightValueChange(with weight: String?)
    func saveMeasurement()

    //binding
    var dateStateDidChange: (() -> Void)? { get set }
}

final class WeightMeasurementViewModelImpl: WeightMeasurementViewModel {

    // MARK: - Properties
    private let coordinator: MainCoordinator
    private let settingsStorage: SettingsStorageProtocol
    private let converter: MeasurementConverter
    private let dateFormatter: DateTimeFormatter
    private let weightDataStore: WeightDataStore

    weak var delegate: WeightMeasurementViewModelDelegate?

    private var weightMeasurement: WeightMeasurement?

    private(set) var metricSystem = false

    private var weightState: Double? {
        didSet {
            let weightString = convertWeightToString(value: weightState)
            if let words = weightString?.components(separatedBy: " "), words.count == 2 {
                weightValue = words[0]
                measurementValue = words[1]
            }
        }
    }

    private(set) var dateState = Date() {
        didSet {
            dateString = convertDateToString(date: dateState)
            dateStateDidChange?()
        }
    }

    var isNewWeightMeasurement: Bool { weightMeasurement == nil }
    private(set) var weightValue: String? = nil
    private(set) var measurementValue: String? = nil
    private(set) var dateString: String? = nil

    var dateStateDidChange: (() -> Void)?

    // MARK: - Initialiser
    init(
        coordinator: MainCoordinator,
        settingsStorage: SettingsStorageProtocol,
        converter: MeasurementConverter,
        dateFormatter: DateTimeFormatter,
        weightDataStore: WeightDataStore,
        weightMeasurement: WeightMeasurement? = nil
    ) {
        self.coordinator = coordinator
        self.settingsStorage = settingsStorage
        self.converter = converter
        self.dateFormatter = dateFormatter
        self.weightDataStore = weightDataStore
        self.weightMeasurement = weightMeasurement
        initialization()
    }

    // MARK: - Methods
    private func initialization() {
        metricSystem = settingsStorage.fetchMetricSystem()

        weightState = weightMeasurement?.weight
        dateState = weightMeasurement?.date ?? Date()
    }

    func dateChanged(with date: Date) {
        dateState = date
    }

    func weightValueChange(with weightString: String?) {
        guard let text = weightString, let weight = Double(text) else { return }
        weightState = weight
    }

    func saveMeasurement() {
        guard let weight = weightState else { return }
        let weightKg = metricSystem ? weight : converter.convertLbToKg(value: weight)
        let id = weightMeasurement?.id ?? UUID().uuidString.lowercased()
        let newMeasurement = WeightMeasurement(id: id, weight: weightKg, date: dateState)
        weightDataStore.save(newMeasurement)
        delegate?.editingOfWeightMeasurementIsCompleted(isNewWeightMeasurement: isNewWeightMeasurement)
        coordinator.dismiss()
    }

    private func convertWeightToString(value: Double?) -> String? {
        converter.convertWeightToString(value: value, valueIsMetric: metricSystem)
    }

    private func convertDateToString(date: Date) -> String {
        return dateFormatter.dateToString(date: date)
    }
}
