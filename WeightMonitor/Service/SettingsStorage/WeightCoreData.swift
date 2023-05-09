//
//  WeightCoreData.swift
//  WeightMonitor
//
//  Created by Filosuf on 09.05.2023.
//

import Foundation

extension WeightCoreData {

    func toWeightMeasurement() -> WeightMeasurement {
        WeightMeasurement(
            id: id ?? "",
            weight: weight,
            date: date ?? Date()
        )
    }
}
