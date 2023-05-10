//
//  MainViewTests.swift
//  WeightMonitorTests
//
//  Created by Filosuf on 10.05.2023.
//

@testable import WeightMonitor
import XCTest

final class MainViewTests: XCTestCase {

    let settingStorage = SettingsStorageSpy()
    var mainViewModel: MainViewModel!
    var referenceRecord = WeightMeasurement(id: "1", weight: 5.5, date: Date())

    override func setUpWithError() throws {
        mainViewModel = MainViewModelImpl(
            coordinator: MainCoordinatorMoc(),
            settingsStorage: settingStorage,
            dateFormatter: DateTimeFormatterImp(),
            weightDataStore: CoreDataManagerMoc(),
            converter: MeasurementConverterImp()
        )
    }

    func testFetchViewModelForCellWithIndexEqualToWeightMeasurementsCount() {
        //given
        let row = mainViewModel.numberOfRowsInSection
        let indexPath = IndexPath(row: row, section: 0)
        let emptyHistoryCellModel = HistoryCellModel(weight: "", change: "", date: "")

        //when
        let historyCellModel = mainViewModel.fetchViewModelForCell(with: indexPath)

        //then
        XCTAssertEqual(historyCellModel, emptyHistoryCellModel)
    }

    func testFetchViewModelForCellWithIndexLessThanWeightMeasurementsCount() {
        //given
        let row = mainViewModel.numberOfRowsInSection - 2
        let indexPath = IndexPath(row: row, section: 0)

        //when
        let historyCellModel = mainViewModel.fetchViewModelForCell(with: indexPath)

        //then
        XCTAssertFalse(historyCellModel.weight.isEmpty)
        XCTAssertFalse(historyCellModel.change.isEmpty)
        XCTAssertFalse(historyCellModel.date.isEmpty)
    }

    func testFetchViewModelForCellForFirstMeasurement() {
        //given
        let row = mainViewModel.numberOfRowsInSection - 1
        let indexPath = IndexPath(row: row, section: 0)

        //when
        let historyCellModel = mainViewModel.fetchViewModelForCell(with: indexPath)

        //then
        XCTAssertFalse(historyCellModel.weight.isEmpty)
        XCTAssertTrue(historyCellModel.change.isEmpty)
        XCTAssertFalse(historyCellModel.date.isEmpty)
    }

    func testChangeMetricSystemOn() {
        //given
        let isOn = true

        //when
        mainViewModel.changeMetricSystem(isOn: isOn)

        //then
        XCTAssertTrue(mainViewModel.metricSystemState)
    }

    func testChangeMetricSystemOff() {
        //given
        let isOn = false

        //when
        mainViewModel.changeMetricSystem(isOn: isOn)

        //then
        XCTAssertFalse(mainViewModel.metricSystemState)
    }

    func testMainViewModelCallsSettingsStorageSaveMetricSystem() {
        //given
        let isOn = false

        //when
        mainViewModel.changeMetricSystem(isOn: isOn)

        //then
        XCTAssertTrue(settingStorage.saveMetricSystemCalled)
    }
}

final class MainCoordinatorMoc: MainCoordinator {
    func startApplication() -> UIViewController { return UIViewController() }

    func showWeightMeasurement(delegate: WeightMeasurementViewModelDelegate?, weightMeasurement: WeightMeasurement?) { }

    func dismiss() { }
}

final class SettingsStorageSpy: SettingsStorageProtocol {

    var saveMetricSystemCalled = false

    private var metricSystem = true

    func saveMetricSystem(isOn: Bool) {
        metricSystem = isOn
        saveMetricSystemCalled = true
    }

    func fetchMetricSystem() -> Bool {
        return metricSystem
    }
}

final class CoreDataManagerMoc: WeightDataStore {
    var notificationName = Notification.Name(rawValue: "ContextDidChange")

    func fetchWeightMeasurements() -> [WeightMeasurement] {
        let record = WeightMeasurement(id: "1", weight: 5.5, date: Date())
        return [record, record, record, record, record]
    }

    func save(_ weight: WeightMeasurement) { }

    func delete(_ weight: WeightMeasurement) { }
}
