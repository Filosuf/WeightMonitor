//
//  DateFormatter.swift
//  WeightMonitor
//
//  Created by Filosuf on 06.05.2023.
//

import Foundation

protocol DateTimeFormatter {

    func dateToString(date: Date, isShort: Bool) -> String
    func dateToString(date: Date) -> String
}

final class DateTimeFormatterImp: DateTimeFormatter {

    private let dateFormatter = DateFormatter()

    func dateToString(date: Date, isShort: Bool) -> String {

        let dateFormat = isShort ? "dMMM" : "dd.MM.yy"
        dateFormatter.locale = .current
        dateFormatter.setLocalizedDateFormatFromTemplate(dateFormat)
        dateFormatter.doesRelativeDateFormatting = false
        return dateFormatter.string(from: date)
    }

    func dateToString(date: Date) -> String {
        dateFormatter.timeStyle = .none
        dateFormatter.dateStyle = .medium
        dateFormatter.locale = .current
        dateFormatter.doesRelativeDateFormatting = true
        return dateFormatter.string(from: date)
    }

}
