//
//  MainViewController.swift
//  WeightMonitor
//
//  Created by Filosuf on 04.05.2023.
//

import UIKit

final class MainViewController: UIViewController {

    // MARK: - Properties
    private let coordinator: MainCoordinator

    private let scrollView = UIScrollView()
    private let contentView = UIView()

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
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()

    private let plusButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .Custom.blueButtonDayDark
        button.setImage(UIImage(named: "plus"), for: .normal)
        button.layer.cornerRadius = 48 / 2
        button.addTarget(self, action: #selector(addMeasurement), for: .touchUpInside)
        return button
    }()

    // MARK: - Initialiser
    init(coordinator: MainCoordinator) {
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

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

    @objc private func addMeasurement() {
        coordinator.showWeightMeasurement()
        print("add Measure")
    }

    private func metricSystemChange(isOn: Bool) {
        print("metric System Change")
    }

    private func layout() {
        contentView.translatesAutoresizingMaskIntoConstraints = false

        [weightMonitorTitle,
         currentWeightView,
         historyTitle,
         historyHeader,
         historyTableView
        ].forEach { view in
            view.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(view)
        }

        scrollView.addSubview(contentView)

        [scrollView,
         plusButton
        ].forEach { view in
            view.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(view)
        }

        NSLayoutConstraint.activate([
            weightMonitorTitle.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            weightMonitorTitle.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            weightMonitorTitle.heightAnchor.constraint(equalToConstant: 24),

            currentWeightView.topAnchor.constraint(equalTo: weightMonitorTitle.bottomAnchor, constant: 24),
            currentWeightView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            currentWeightView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -16),
            currentWeightView.heightAnchor.constraint(equalToConstant: 129),

            historyTitle.topAnchor.constraint(equalTo: currentWeightView.bottomAnchor, constant: 16),
            historyTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            historyTitle.heightAnchor.constraint(equalToConstant: 24),

            historyHeader.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            historyHeader.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            historyHeader.topAnchor.constraint(equalTo: historyTitle.bottomAnchor, constant: 8),
            historyHeader.heightAnchor.constraint(equalToConstant: 35),

            historyTableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            historyTableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            historyTableView.topAnchor.constraint(equalTo: historyHeader.bottomAnchor),
            historyTableView.heightAnchor.constraint(equalToConstant: 20*46),
            historyTableView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),

            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            plusButton.heightAnchor.constraint(equalToConstant: 48),
            plusButton.widthAnchor.constraint(equalToConstant: 48),
            plusButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            plusButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }
}

// MARK: - UITableViewDataSource
extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        presenter.friends.count
        20
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
