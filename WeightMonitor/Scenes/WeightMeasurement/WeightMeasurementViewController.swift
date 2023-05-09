//
//  WeightMeasurementViewController.swift
//  WeightMonitor
//
//  Created by Filosuf on 05.05.2023.
//

import UIKit

class WeightMeasurementViewController: UIViewController {

    // MARK: - Properties
    private var viewModel: WeightMeasurementViewModel
    private var saveButtonBottomConstraint: NSLayoutConstraint?
    private var firstDividerTopConstraint: NSLayoutConstraint?

    private let weightMeasurementTitle: UILabel = {
        let label = UILabel()
        label.text = "weightMonitor".localized
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.textColor = .Custom.black
        return label
    }()

    private let dateLabel: UILabel = {
        let label = UILabel()
        label.text = "date".localized
        label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        label.textColor = .Custom.black
        return label
    }()

    private let dateButton: UIButton = {
        let button = UIButton()
        button.setTitle("Сегодня", for: .normal)
        button.setTitleColor(.Custom.blueButtonDayDark, for: .normal)
        button.addTarget(self, action: #selector(showDatePicker), for: .touchUpInside)
        return button
    }()

    private let arrowImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.right")
        imageView.tintColor = .Custom.black
        return imageView
    }()

    private lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.datePickerMode = .date
        datePicker.isHidden = true
        datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        return datePicker
    }()

    private lazy var weightValueField: UITextField = {
        let textField = UITextField()
        textField.textColor = .Custom.black
        textField.font = UIFont.boldSystemFont(ofSize: 34)
        textField.placeholder = "weight".localized
        textField.autocapitalizationType = .none
        textField.keyboardType = .decimalPad
        textField.addTarget(self, action: #selector(weightValueChange), for: .editingChanged)
        textField.delegate = self
        return textField
    }()

    private let measurementValueLabel: UILabel = {
        let label = UILabel()
        label.text = "KG"
        label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        label.textColor = .Custom.grayText
        return label
    }()

    private let firstDividerImage = Divider(color: .Custom.grayBackground)
    private let secondDividerImage = Divider(color: .Custom.grayBackground)
    private let thirdDividerImage = Divider(color: .Custom.grayBackground)

    private let saveButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .Custom.blueButton
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(saveMeasurement), for: .touchUpInside)
        return button
    }()

    // MARK: - Initialiser
    init(viewModel: WeightMeasurementViewModel) {
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
        initialization()
        bind()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard (_:)))
        view.addGestureRecognizer(tapGesture)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    // MARK: - Methods
    @objc private func dateChanged() {
        viewModel.dateChanged(with: datePicker.date)
    }

    @objc private func weightValueChange() {
        viewModel.weightValueChange(with: weightValueField.text)
    }

    @objc private func showDatePicker() {
        view.endEditing(true)
        firstDividerTopConstraint?.constant = 16 + 216
        datePicker.isHidden = false
        view.setNeedsLayout()
    }

    private func hideDatePicker() {
        if !datePicker.isHidden {
            firstDividerTopConstraint?.constant = 16
            datePicker.isHidden = true
            view.setNeedsLayout()
        }
    }

    @objc private func keyboardWillShow(notification: NSNotification) {
        hideDatePicker()
        guard let userInfo = notification.userInfo else {return}
        guard let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }

        let keyboardHeight = keyboardSize.cgRectValue.height
        let window = UIApplication.shared.windows.first
        let bottomPadding = window?.safeAreaInsets.bottom ?? 0

        saveButtonBottomConstraint?.constant = -16 - keyboardHeight + bottomPadding
        view.setNeedsLayout()
    }

    @objc private func keyboardWillHide(notification: NSNotification) {
        saveButtonBottomConstraint?.constant = -16
        view.setNeedsLayout()
    }

    private func initialization() {

    }

    private func bind() {
        viewModel.dateStateDidChange = { [weak self] in
            self?.updateDateButton(title: self?.viewModel.dateString)
        }
    }

    private func updateDateButton(title: String?) {
        dateButton.setTitle(title, for: .normal)
    }

    @objc private func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        weightValueField.resignFirstResponder()
        hideDatePicker()
    }

    @objc private func saveMeasurement() {
        viewModel.saveMeasurement()
    }

    private func layout() {

        [weightMeasurementTitle,
         dateLabel,
         dateButton,
         arrowImage,
         firstDividerImage,
         thirdDividerImage,
         datePicker,
         weightValueField,
         measurementValueLabel,
         secondDividerImage,
         saveButton
        ].forEach { view in
            view.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(view)
        }

        saveButtonBottomConstraint = saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        saveButtonBottomConstraint?.isActive = true

        firstDividerTopConstraint = firstDividerImage.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 16)
        firstDividerTopConstraint?.isActive = true

        NSLayoutConstraint.activate([
            weightMeasurementTitle.topAnchor.constraint(equalTo: view.topAnchor, constant: 32),
            weightMeasurementTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            weightMeasurementTitle.heightAnchor.constraint(equalToConstant: 24),

            dateLabel.topAnchor.constraint(equalTo: weightMeasurementTitle.bottomAnchor, constant: 127),
            dateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            dateLabel.heightAnchor.constraint(equalToConstant: 22),

            dateButton.centerYAnchor.constraint(equalTo: dateLabel.centerYAnchor),
            dateButton.trailingAnchor.constraint(equalTo: arrowImage.leadingAnchor, constant: -8),

            arrowImage.centerYAnchor.constraint(equalTo: dateLabel.centerYAnchor),
            arrowImage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            arrowImage.heightAnchor.constraint(equalToConstant: 20),
            arrowImage.widthAnchor.constraint(equalToConstant: 20),

            firstDividerImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            firstDividerImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            firstDividerImage.heightAnchor.constraint(equalToConstant: 1),

            thirdDividerImage.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 16),
            thirdDividerImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            thirdDividerImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            thirdDividerImage.heightAnchor.constraint(equalToConstant: 1),

            datePicker.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            datePicker.topAnchor.constraint(equalTo: thirdDividerImage.bottomAnchor),

            weightValueField.topAnchor.constraint(equalTo: firstDividerImage.bottomAnchor, constant: 16),
            weightValueField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            weightValueField.trailingAnchor.constraint(equalTo: measurementValueLabel.leadingAnchor, constant: -4),
            weightValueField.heightAnchor.constraint(equalToConstant: 40),

            measurementValueLabel.centerYAnchor.constraint(equalTo: weightValueField.centerYAnchor),
            measurementValueLabel.heightAnchor.constraint(equalToConstant: 22),
            measurementValueLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            secondDividerImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            secondDividerImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            secondDividerImage.topAnchor.constraint(equalTo: weightValueField.bottomAnchor, constant: 16),
            secondDividerImage.heightAnchor.constraint(equalToConstant: 1),

            saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            saveButton.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
}

//MARK: - UITextFieldDelegate
extension WeightMeasurementViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
}
