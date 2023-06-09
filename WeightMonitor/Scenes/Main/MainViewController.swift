//
//  MainViewController.swift
//  WeightMonitor
//
//  Created by Filosuf on 04.05.2023.
//

import UIKit

final class MainViewController: UIViewController {

    // MARK: - Properties
    private var viewModel: MainViewModel

    private var historyTableViewHeightConstraint: NSLayoutConstraint?

    private enum Constants {
        static let heightCell = 46
    }

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
    init(viewModel: MainViewModel) {
        self.viewModel = viewModel
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
        initialization()
        bind()
    }

    // MARK: - Methods
    private func initialization() {
        updateMetricSystemState(isOn: viewModel.metricSystemState)
        updateView()
    }

    private func bind() {
        viewModel.metricSystemStateDidChange = { [weak self] isOn in
            self?.updateMetricSystemState(isOn: isOn)
            self?.updateView()
        }
        viewModel.weightMeasurementsDidChange = { [weak self] in
            self?.updateView()
        }
        viewModel.toastMessageGenerated = { [weak self] message in
            self?.showToast(message: message)
        }
    }

    private func updateView() {
        updateHeightHistoryTableView()
        historyTableView.reloadData()
        let indexPath = IndexPath(row: 0, section: 0)
        let modelForView = viewModel.fetchViewModelForCell(with: indexPath)
        currentWeightView.setupView(with: modelForView)
    }

    private func updateHeightHistoryTableView() {
        historyTableViewHeightConstraint?.constant = CGFloat(viewModel.numberOfRowsInSection * Constants.heightCell)
        view.setNeedsLayout()
    }

    private func setupAction() {
        currentWeightView.metricSystemChange = { [weak self] isOn in
            self?.changeMetricSystem(isOn: isOn)
        }
    }

    @objc private func addMeasurement() {
        viewModel.showNewWeightMeasurement()
    }

    private func changeMetricSystem(isOn: Bool) {
        viewModel.changeMetricSystem(isOn: isOn)
    }

    private func updateMetricSystemState(isOn: Bool) {
        currentWeightView.updateMetricSystemSwitch(isOn: isOn)
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

        historyTableViewHeightConstraint = historyTableView.heightAnchor.constraint(equalToConstant: CGFloat(viewModel.numberOfRowsInSection * Constants.heightCell))
        historyTableViewHeightConstraint?.isActive = true

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
        viewModel.numberOfRowsInSection
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HistoryTableViewCell.identifier, for: indexPath) as! HistoryTableViewCell
        let model = viewModel.fetchViewModelForCell(with: indexPath)
        cell.setupCell(with: model)
        return cell
    }

}

// MARK: - UITableViewDelegate
extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(Constants.heightCell)
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.showEditWeightMeasurement(indexPath: indexPath)
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            viewModel.deleteWeightMeasurement(with: indexPath)
        }
    }
}

// MARK: - Toasts
extension MainViewController {
    func showToast(message: String?) {

        let toastLabel: UILabel = {
            let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
            label.textAlignment = .center
            label.textColor = .Custom.whiteTextTost
            label.backgroundColor = .Custom.black
            label.layer.cornerRadius = 12
            label.clipsToBounds = true
            label.alpha = 0
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()

        toastLabel.text = message

        view.addSubview(toastLabel)

        NSLayoutConstraint.activate([
            toastLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24),
            toastLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            toastLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            toastLabel.heightAnchor.constraint(equalToConstant: 52)
            ])

        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseIn, animations: {
            toastLabel.alpha = 1.0
        }, completion: { _ in
            UIView.animate(withDuration: 0.5, delay: 1.5, options: .curveEaseOut, animations: {
                toastLabel.alpha = 0.0
            }, completion: {_ in
                toastLabel.removeFromSuperview()
            })
        })
    }
}
