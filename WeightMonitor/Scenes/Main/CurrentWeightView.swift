//
//  CurrentWeightView.swift
//  WeightMonitor
//
//  Created by Filosuf on 04.05.2023.
//

import UIKit

final class CurrentWeightView: UIView {

    // MARK: - Properties
    var metricSystemChange: ((Bool) -> Void)?

    private let scalesImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "scales")
        return imageView
    }()

    private let currentWeightTitle: UILabel = {
        let label = UILabel()
        label.text = "currentWeight".localized
        label.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        label.textColor = .Custom.lightGrayText
        return label
    }()

    private let currentWeightValueLabel: UILabel = {
        let label = UILabel()
        label.text = "58,5 kg"
        label.font = UIFont.systemFont(ofSize: 22)
        label.textColor = .Custom.black
        return label
    }()

    private let changingCurrentWeightLabel: UILabel = {
        let label = UILabel()
        label.text = "-0,5 kg"
        label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        label.textColor = .Custom.grayText
        return label
    }()

    private let metricSystemLabel: UILabel = {
        let label = UILabel()
        label.text = "metricSystem".localized
        label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        label.textColor = .Custom.black
        return label
    }()

    private let metricSystemSwitch: UISwitch = {
        let switchButton = UISwitch()
        switchButton.onTintColor = .Custom.blueButtonDayDark
        switchButton.addTarget(self, action: #selector(switchHandle), for: .valueChanged)
        return switchButton
    }()

    // MARK: - Initialiser
    init() {
        super.init(frame: CGRect.zero)
        backgroundColor = .Custom.grayBackground
        layout()
        layer.cornerRadius = 12
        layer.masksToBounds = true
    }

    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Methods
    func updateMetricSystemSwitch(isOn: Bool) {
        metricSystemSwitch.isOn = isOn
    }

    func setupView(with model: HistoryCellModel) {
        currentWeightValueLabel.text = model.weight
        changingCurrentWeightLabel.text = model.change
    }
    
    @objc private func switchHandle() {
        metricSystemChange?(metricSystemSwitch.isOn)
    }

    private func layout() {
        [scalesImage,
         currentWeightTitle,
         currentWeightValueLabel,
         changingCurrentWeightLabel,
         metricSystemSwitch,
         metricSystemLabel
        ].forEach { view in
            view.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(view)
        }

        NSLayoutConstraint.activate([
            scalesImage.trailingAnchor.constraint(equalTo: trailingAnchor),
            scalesImage.topAnchor.constraint(equalTo: topAnchor),
            scalesImage.heightAnchor.constraint(equalToConstant: 69),
            scalesImage.widthAnchor.constraint(equalToConstant: 106),

            currentWeightTitle.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            currentWeightTitle.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            currentWeightTitle.heightAnchor.constraint(equalToConstant: 18),

            currentWeightValueLabel.topAnchor.constraint(equalTo: currentWeightTitle.bottomAnchor, constant: 6),
            currentWeightValueLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            currentWeightValueLabel.heightAnchor.constraint(equalToConstant: 26),

            changingCurrentWeightLabel.bottomAnchor.constraint(equalTo: currentWeightValueLabel.bottomAnchor),
            changingCurrentWeightLabel.leadingAnchor.constraint(equalTo: currentWeightValueLabel.trailingAnchor, constant: 8),

            metricSystemSwitch.topAnchor.constraint(equalTo: currentWeightValueLabel.bottomAnchor, constant: 16),
            metricSystemSwitch.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),

            metricSystemLabel.centerYAnchor.constraint(equalTo: metricSystemSwitch.centerYAnchor),
            metricSystemLabel.leadingAnchor.constraint(equalTo: metricSystemSwitch.trailingAnchor, constant: 16)
        ])
    }

}
