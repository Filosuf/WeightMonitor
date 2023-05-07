//
//  DateFormatter.swift
//  WeightMonitor
//
//  Created by Filosuf on 06.05.2023.
//

import Foundation

final class DateTimeFormatter {

    let dateFormatter = DateFormatter()

    func dateToString(date: Date, isShort: Bool) -> String {

        let dateFormat = isShort ? "dMMM" : "dd.MM.yy"
        dateFormatter.locale = .current
        dateFormatter.setLocalizedDateFormatFromTemplate(dateFormat)
        return dateFormatter.string(from: date)
    }
}
