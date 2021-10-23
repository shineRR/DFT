//
// ViewController.swift
// DFT
//
// Created by Ilya Baryko on 3.10.21.
// 
//


import Cocoa
import Charts

protocol ChartDelegate {
    func drawSignal(with values: [Double], color: CGColor, label: String)
    func compareSignals(with initValues: [Double], and restoredValues: [Double])
}

class ViewController: NSViewController {

    enum FourierType : Int {
        case dft = 0
        case fft
    }
    
    // MARK: - Outlets
    @IBOutlet private weak var lineChartView: LineChartView!
    @IBOutlet private weak var segmentControl: NSSegmentedControl!
    @IBOutlet private weak var filterSettingsView: NSView!
    @IBOutlet private weak var shouldUsePhaseRadioButton: NSButton!
    
    /// Signal radio buttons
    @IBOutlet private weak var signalRadioButton: NSSignalRadioButton!
    @IBOutlet private weak var polyharmonicSignalRadioButton: NSSignalRadioButton!
    
    /// Low - High Filter
    @IBOutlet private weak var freqTextField: NSTextField!
    @IBOutlet private weak var signLabel: NSTextField!
    
    /// Band pass Filter
    @IBOutlet private weak var lowerBoundTextField: NSTextField!
    @IBOutlet private weak var upperBoundTextField: NSTextField!
    
    /// Filter radio buttons
    @IBOutlet private weak var shouldUseFilterRadioButton: NSButton!
    @IBOutlet private weak var lowFilterRadioButton: NSFilterRadioButton!
    @IBOutlet private weak var highFilterRadioButton: NSFilterRadioButton!
    @IBOutlet private weak var bandPassFilterRadioButton: NSFilterRadioButton!
    @IBOutlet private weak var bandPassRangeView: NSView!
    
    // MARK: - Properties
    private var recognizer: SignalRecognizer?
    private var signal: RestorableSignal = Signal()
    private var selectedSignal: SignalType = .signal
    private var fourierType: FourierType = .dft
    private var selectedFilter: FilterType = .low
    private var shouldUsePhase: Bool {
        return self.shouldUsePhaseRadioButton.state == .on
    }
    private var shouldUseFilter: Bool {
        return self.shouldUseFilterRadioButton.state == .on
    }
    private var filterValue: Int {
        return Int(self.freqTextField.intValue)
    }
    private var lowerBound: Int {
        return Int(self.lowerBoundTextField.intValue)
    }
    private var upperBound: Int {
        return Int(self.upperBoundTextField.intValue)
    }
    
    // MARK: - Override
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
        self.setupChart()
        self.execute()
    }
    
    // MARK: - IBAction
    @IBAction func reproduceSignal(_ sender: NSSignalRadioButton) {
        guard let signal = ReproducingSignal(rawValue: sender.signalType.rawValue) else { return }
        self.recognizer?.setSignal(signal)
        self.recognizer?.reproduceSignal()
    }
    
    @IBAction private func redrawChart(_ sender: Any) {
        self.execute()
    }
    
    @IBAction private func didChooseSignal(_ sender: NSSignalRadioButton) {
        self.selectedSignal = sender.signalType
        self.signal = (self.selectedSignal == .signal) ? Signal() : PolyharmonicSignal()
        self.changeRadionButtonState(for: [self.signalRadioButton, self.polyharmonicSignalRadioButton],
                                     to: .off, except: sender)
        self.execute()
    }
    
    @IBAction private func didChooseFilter(_ sender: NSFilterRadioButton) {
        self.selectedFilter = sender.filterType
        self.changeRadionButtonState(for: [self.lowFilterRadioButton, self.highFilterRadioButton, self.bandPassFilterRadioButton],
                                     to: .off, except: sender)
        self.setupFilterView()
        self.execute()
    }
    
    @IBAction private func didTapOnUseFilter(_ sender: NSButton) {
        let alpha: CGFloat = (sender.state == .on) ? 1.0 : 0.0
        NSAnimationContext.runAnimationGroup({ [weak self] context in
            context.duration = 0.3
            self?.filterSettingsView.animator().alphaValue = alpha
        }, completionHandler: { [weak self] in
            self?.execute()
        })
    }
    
    @IBAction private func didSwitchSegment(_ sender: NSSegmentedControl) {
        guard let type = FourierType(rawValue: sender.indexOfSelectedItem) else { return }
        self.fourierType = type
        self.execute()
    }
    
    // MARK: - Methods
    private func execute() {
        self.clearPreviousSignal()
        
        var fourier: Spectrum = (self.fourierType == .dft) ? self.signal.getDFT() : self.signal.getFFT()
        if self.shouldUseFilter {
            let filter = self.createFilter(with: self.selectedFilter)
            fourier = FourierService.filterSignal(with: fourier, by: filter)
        }
        
        let initialData = self.signal.values
        let restoredData = self.signal.restoreSignal(with: fourier, shouldUsePhase: self.shouldUsePhase)
        
        DispatchQueue.main.async {
            self.recognizer = SignalRecognizer(initialData, restoredData)
            self.compareSignals(with: initialData, and: restoredData)
        }
    }
    
    private func clearPreviousSignal() {
        self.recognizer = nil
        self.lineChartView.clearValues()
    }
    
    private func reproduceSignal() {
        self.recognizer?.reproduceSignal()
    }
    
    private func createFilter(with type: FilterType) -> ((Int) -> Bool) {
        switch type {
        case .low:
            return { $0 < self.filterValue }
        case .high:
            return { $0 > self.filterValue }
        case .bandPass:
            return { $0 >= self.lowerBound && $0 <= self.upperBound }
        }
    }
    
    private func setupFilterView() {
        switch self.selectedFilter {
        case .low:
            self.setupRange(sign: "<")
        case .high:
            self.setupRange(sign: ">")
        case .bandPass:
            self.setupRange(isBandPass: true)
        }
    }
    
    private func setupRange(sign: String = "", isBandPass: Bool = false) {
        self.signLabel.stringValue = sign
        self.signLabel.isHidden = isBandPass
        self.freqTextField.isHidden = isBandPass
        self.bandPassRangeView.isHidden = !isBandPass
    }
    
    private func setupUI() {
        self.filterSettingsView.alphaValue = 0
    }
    
    private func setupChart() {
        self.lineChartView.rightAxis.enabled = false
        self.lineChartView.dragEnabled = true
        self.lineChartView.doubleTapToZoomEnabled = false
        
        let yAxis =  self.lineChartView.leftAxis
        yAxis.drawGridLinesEnabled = false
        yAxis.labelFont = .boldSystemFont(ofSize: 12)
        yAxis.setLabelCount(6, force: false)
        yAxis.valueFormatter = DefaultAxisValueFormatter(decimals: 100)
        
        let xAxis =  self.lineChartView.xAxis
        xAxis.drawGridLinesEnabled = false
        xAxis.drawLabelsEnabled = false
        xAxis.labelPosition = .bottom
        
//        self.lineChartView.animate(xAxisDuration: 1.0, easingOption: .linear)
    }
    
    private func setData(with set: LineChartDataSet) {
        let data = LineChartData(dataSet: set)
        data.setDrawValues(false)
        self.lineChartView.data = data
    }
    
    private func getDataSet(color: CGColor, label: String, alpha: Double) -> LineChartDataSet {
        let set = LineChartDataSet(label: label)
        set.mode = .linear
        set.drawCirclesEnabled = false
        set.drawFilledEnabled = true
        set.drawHorizontalHighlightIndicatorEnabled = false
        set.fill = Fill(color: (NSUIColor(cgColor: color) ?? .blue))
        set.fillAlpha = CGFloat(alpha)
        set.highlightColor = .clear
        set.lineWidth = 2
        set.setColor(NSUIColor(cgColor: color) ?? .blue)
        return set
    }
}

extension ViewController: ChartDelegate {
    func drawSignal(with values: [Double], color: CGColor, label: String) {
        let set = getDataSet(color: color, label: label, alpha: 0.3)
        for (i, value) in values.enumerated() {
            set.append(ChartDataEntry(x: Double(i), y: value))
        }
        self.setData(with: set)
    }
    
    func compareSignals(with initValues: [Double], and restoredValues: [Double]) {
        func addEntries(for set: LineChartDataSet, values: [Double]) {
            for (i, value) in values.enumerated() {
                set.append(ChartDataEntry(x: Double(i), y: value))
            }
        }
        
        let initSet = self.getDataSet(color: Constants.chartColor, label: "Initial Signal", alpha: 0.3)
        let restoredSet = self.getDataSet(color: Constants.chartRestoredColor, label: "Restored Signal", alpha: 0.3)
        
        addEntries(for: initSet, values: initValues)
        addEntries(for: restoredSet, values: restoredValues)
    
        self.lineChartView.data = LineChartData(dataSets: [initSet, restoredSet])
    }
}
