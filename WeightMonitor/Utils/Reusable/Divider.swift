//
//  Divider.swift
//  WeightMonitor
//
//  Created by Filosuf on 09.05.2023.
//

import UIKit

final class Divider: UIView {

    init(color: UIColor? = .black) {
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        setDivider(color: color)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setDivider(color: UIColor?) {
        self.backgroundColor = color
        translatesAutoresizingMaskIntoConstraints = false
    }
}
