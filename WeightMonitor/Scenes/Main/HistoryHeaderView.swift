//
//  HistoryHeaderView.swift
//  WeightMonitor
//
//  Created by Filosuf on 04.05.2023.
//

import UIKit

final class HistoryHeaderView: UIView {

    // MARK: - Properties
    private let weightLabel: UILabel = {
        let label = UILabel()
        label.text = "weight".localized
        label.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        label.textColor = .Custom.lightGrayText
        return label
    }()

    private let changesLabel: UILabel = {
        let label = UILabel()
        label.text = "changes".localized
        label.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        label.textColor = .Custom.lightGrayText
        return label
    }()

    private let dateLabel: UILabel = {
        let label = UILabel()
        label.text = "date".localized
        label.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        label.textColor = .Custom.lightGrayText
        return label
    }()

    private let dividerImage: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .Custom.divider
        return imageView
    }()

    // MARK: - Initialiser
       init() {
           super.init(frame: CGRect.zero)
           backgroundColor = .systemBackground
           layout()
       }

       required init?(coder aDecoder: NSCoder)
       {
           fatalError("init(coder:) has not been implemented")
       }

    // MARK: - Methods
    private func layout() {
        [weightLabel,
         changesLabel,
         dateLabel,
         dividerImage
        ].forEach { view in
            view.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(view)
        }

        NSLayoutConstraint.activate([
            weightLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            weightLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            weightLabel.heightAnchor.constraint(equalToConstant: 18),
            weightLabel.widthAnchor.constraint(equalToConstant: 116),

            changesLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            changesLabel.leadingAnchor.constraint(equalTo: weightLabel.trailingAnchor, constant: 8),
            changesLabel.trailingAnchor.constraint(equalTo: dateLabel.leadingAnchor, constant: 8),

            dateLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            dateLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            dateLabel.widthAnchor.constraint(equalToConstant: 95),

            dividerImage.heightAnchor.constraint(equalToConstant: 1),
            dividerImage.bottomAnchor.constraint(equalTo: bottomAnchor),
            dividerImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            dividerImage.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
    }
}
