//
//  HistoryTableViewCell.swift
//  WeightMonitor
//
//  Created by Filosuf on 04.05.2023.
//

import UIKit

final class HistoryTableViewCell: UITableViewCell {
    static let identifier = "HistoryTableViewCell"

    // MARK: - Properties
    private let weightLabel: UILabel = {
        let label = UILabel()
        label.text = "weight".localized
        label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        label.textColor = .Custom.black
        return label
    }()

    private let changesLabel: UILabel = {
        let label = UILabel()
        label.text = "changes".localized
        label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        label.textColor = .Custom.grayText
        return label
    }()

    private let dateLabel: UILabel = {
        let label = UILabel()
        label.text = "date".localized
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.textColor = .Custom.lightGrayText
        return label
    }()

    private let arrowImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "chevron.right")
        imageView.tintColor = .Custom.black
        return imageView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .systemBackground
        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupCell(with model: HistoryCellModel) {
        weightLabel.text = model.weight
        changesLabel.text = model.change
        dateLabel.text = model.date
    }

    private func layout() {
            [weightLabel,
             changesLabel,
             dateLabel,
             arrowImage
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
                changesLabel.trailingAnchor.constraint(equalTo: dateLabel.leadingAnchor, constant: -8),


                dateLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
                dateLabel.trailingAnchor.constraint(equalTo: arrowImage.leadingAnchor, constant: -4),
                dateLabel.widthAnchor.constraint(equalToConstant: 71),

                arrowImage.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
                arrowImage.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
                arrowImage.heightAnchor.constraint(equalToConstant: 20),
                arrowImage.widthAnchor.constraint(equalToConstant: 20),
            ])
        }
}
