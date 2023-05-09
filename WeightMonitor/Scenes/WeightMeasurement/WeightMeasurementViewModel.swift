//
//  WeightMeasurementViewModel.swift
//  WeightMonitor
//
//  Created by Filosuf on 08.05.2023.
//

import Foundation

struct WeightMeasurementForView {
    let weight: String?
    let date: String?
}

protocol WeightMeasurementViewModel {

    var weightString: String? { get }
    var dateString: String? { get }

    //methods
    func dateChanged(with date: Date)
    func weightValueChange(with weight: String?)
    func saveMeasurement()

    //binding
    var weightStateDidChange: (() -> Void)? { get set }
    var dateStateDidChange: (() -> Void)? { get set }
}

final class WeightMeasurementViewModelImpl: WeightMeasurementViewModel {

    // MARK: - Properties
    private let coordinator: MainCoordinator
    private let settingsStorage: SettingsStorageProtocol
    private let convertor: MeasurementConvertor
    private let dateFormatter: DateTimeFormatter

    private var weightMeasurement: WeightMeasurement?

    var metricSystem = false

    var modelForView: WeightMeasurementForView?

    private var weightState: Double? {
        didSet {
            weightString = convertWeightToString(value: weightState)
            weightStateDidChange?()
        }
    }

    private var dateState = Date() {
        didSet {
            dateString = convertDateToString(date: dateState)
            dateStateDidChange?()
        }
    }

    var weightString: String? = nil
    var dateString: String? = nil

    var weightStateDidChange: (() -> Void)?
    var dateStateDidChange: (() -> Void)?

    // MARK: - Initialiser
    init(coordinator: MainCoordinator, settingsStorage: SettingsStorageProtocol, convertor: MeasurementConvertor, dateFormatter: DateTimeFormatter, weightMeasurement: WeightMeasurement? = nil) {
        self.coordinator = coordinator
        self.settingsStorage = settingsStorage
        self.convertor = convertor
        self.dateFormatter = dateFormatter
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
        let weightKg = metricSystem ? weight : convertor.convertLbToKg(value: weight)
        let newMeasurement = WeightMeasurement(weight: weightKg, date: dateState)
        coordinator.dismiss()
        print("save \(newMeasurement)")
    }

    private func convertWeightToString(value: Double?) -> String? {
        convertor.convertWeightToString(value: value, valueIsMetric: metricSystem)
    }

    private func convertDateToString(date: Date) -> String {
        return dateFormatter.dateToString(date: date)
//        let relativeDateFormatter = DateFormatter()
//        relativeDateFormatter.timeStyle = .none
//        relativeDateFormatter.dateStyle = .medium
//        relativeDateFormatter.locale = .current
//        relativeDateFormatter.doesRelativeDateFormatting = true
//
//        let dateString = relativeDateFormatter.string(from: date)
//        return dateString
    }
}
