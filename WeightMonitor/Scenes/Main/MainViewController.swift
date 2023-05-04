//
//  MainViewController.swift
//  WeightMonitor
//
//  Created by Filosuf on 04.05.2023.
//

import UIKit

final class MainViewController: UIViewController {

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

    private let historyHeader = HistoryHeaderView()

    private lazy var historyTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.register(HistoryTableViewCell.self, forCellReuseIdentifier: HistoryTableViewCell.identifier)
        tableView.layer.cornerRadius = 16
        tableView.clipsToBounds = true
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
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
         historyHeader,
         historyTableView
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

            historyHeader.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            historyHeader.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            historyHeader.topAnchor.constraint(equalTo: historyTitle.bottomAnchor, constant: 8),
            historyHeader.heightAnchor.constraint(equalToConstant: 35),

            historyTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            historyTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            historyTableView.topAnchor.constraint(equalTo: historyHeader.bottomAnchor),
            historyTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

// MARK: - UITableViewDataSource
extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        presenter.friends.count
        10
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HistoryTableViewCell.identifier, for: indexPath) as! HistoryTableViewCell
        cell.setupCell()
        return cell
    }

}

// MARK: - UITableViewDelegate
extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 46
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        presenter.didSelectRow(index: indexPath)
    }
}
