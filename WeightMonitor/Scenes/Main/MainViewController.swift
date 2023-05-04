//
//  MainViewController.swift
//  WeightMonitor
//
//  Created by Filosuf on 04.05.2023.
//

import UIKit

class MainViewController: UIViewController {

    // MARK: - Properties
    private let weightMonitorTitle: UILabel = {
        let label = UILabel()
        label.text = "weightMonitor".localized
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.textColor = .Custom.black
        return label
    }()

    private let currentWeightView = CurrentWeightView()

    private let historyTitle: UILabel = {
        let label = UILabel()
        label.text = "history".localized
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.textColor = .Custom.black
        return label
    }()

    // MARK: - Initialiser
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        layout()
        setupAction()
    }

    // MARK: - Methods
    private func setupAction() {
        currentWeightView.metricSystemChange = { [weak self] isOn in
            self?.metricSystemChange(isOn: isOn)
        }
    }

    private func metricSystemChange(isOn: Bool) {
        print("metric System Change")
    }

    private func layout() {
        [weightMonitorTitle,
        currentWeightView,
        historyTitle,
        ].forEach { view in
            view.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(view)
        }

        NSLayoutConstraint.activate([
            weightMonitorTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            weightMonitorTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            weightMonitorTitle.heightAnchor.constraint(equalToConstant: 24),

            currentWeightView.topAnchor.constraint(equalTo: weightMonitorTitle.bottomAnchor, constant: 24),
            currentWeightView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            currentWeightView.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -16),
            currentWeightView.heightAnchor.constraint(equalToConstant: 129),

            historyTitle.topAnchor.constraint(equalTo: currentWeightView.bottomAnchor, constant: 16),
            historyTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            historyTitle.heightAnchor.constraint(equalToConstant: 24),

        ])
    }
}
