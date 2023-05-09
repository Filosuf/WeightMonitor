//
//  MeasurementConverter.swift
//  WeightMonitor
//
//  Created by Filosuf on 09.05.2023.
//

import Foundation

protocol MeasurementConverter {

    func convertWeightToString(value: Double?, valueIsMetric: Bool) -> String?
    func convertKgToLb(value: Double) -> Double
    func convertLbToKg(value: Double) -> Double
}

final class MeasurementConverterImp: MeasurementConverter {

    func convertWeightToString(value: Double?, valueIsMetric: Bool) -> String? {
        guard let value = value else { return nil }

        let weightKg = Measurement(value: value, unit: UnitMass.kilograms)
        let weightLb = weightKg.converted(to: .pounds)
        let weightKgRound = Double(round(10 * weightKg.value) / 10)

        //Используя 'MeasurementFormatter()' не удалось получить Фунт на русском языке
        let weightString = valueIsMetric ? "\(weightKgRound) " + "kg".localized : String(format: "pounds".localized, weightLb.value)
        return weightString
    }

    func convertKgToLb(value: Double) -> Double {
        let weightKg = Measurement(value: value, unit: UnitMass.kilograms)
        let weightLb = weightKg.converted(to: .pounds)
        return weightLb.value
    }

    func convertLbToKg(value: Double) -> Double {
        let weightLb = Measurement(value: value, unit: UnitMass.pounds)
        let weightKg = weightLb.converted(to: .kilograms)
//        let weightKgRound = Double(round(10 * weightKg.value) / 10)
        return weightKg.value
    }

    func formatNumber(number: Double) -> String? {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 2

        let formattedNumberString = formatter.string(from: NSNumber(value: number))
        return formattedNumberString?.replacingOccurrences(of: ".00", with: "")
    }
}
