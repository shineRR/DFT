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

    // MARK: - Outlets
    @IBOutlet private weak var lineChartView: LineChartView!
    
    // MARK: - Properties
    
    // MARK: - Override
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupChart()
        self.execute()
    }
    
    // MARK: - Methods
    private func execute() {
        
        let signal = Signal()
        let polySignal = PolyharmonicSignal()
        
        let signalData = signal.values
        let polyData = polySignal.values

        // MARK: - DFT
        let dft = signal.getDFT()
//        let restoredData = signal.restoreSignal(with: dft)
        
        // MARK: - Polyharmonic
//        let dft = polySignal.getDFT()
        let freq1 = FourierService.filterSignal(with: dft, by: { $0 > 20 }) // Passes all >20 hz
        let freq = FourierService.filterSignal(with: dft, by: { $0 < 20 }) // Passes all <20 hz
        let restoredData1 = signal.restoreSignal(with: freq1, shouldUsePhase: true)
        let restoredData = signal.restoreSignal(with: freq, shouldUsePhase: true)
        
        // MARK: - FFT
//        let fft = signal.getFFT()
//        let restoredData = signal.restoreSignal(with: fft)

        // MARK: - Poly FFT
//        let fft = polySignal.getFFT()
//        let restoredData = polySignal.restoreSignal(with: fft, shouldUsePhase: true)
        
        self.compareSignals(with: restoredData1, and: restoredData)
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
        
        self.lineChartView.animate(xAxisDuration: 1.0, easingOption: .linear)
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
