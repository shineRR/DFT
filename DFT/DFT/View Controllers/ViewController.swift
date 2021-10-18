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
    private let service = FourierService()
    
    // MARK: - Override
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupChart()
        self.service.delegate = self
        self.execute()
    }
    
    // MARK: - Methods
    private func execute() {
        
        let signalData = self.service.getValues()
        
        // MARK: - DFT
//        let dft = service.getDFT(with: signalData)
//        let amplitude = dft.getAmplitudeSpectrum()
//        let phase = dft.getPhaseSpectrum()
//        let restoredData = service.restoreSignal(amplitudeSpectrum: amplitude, phaseSpectrum: phase)
        
        // MARK: - FFT
        let fft = self.service.getFFT(with: signalData)
        let amplitude = fft.getAmplitudeSpectrum()
        let phase = fft.getPhaseSpectrum()
        let restoredData = service.restoreSignal(amplitudeSpectrum: amplitude, phaseSpectrum: phase)

        self.compareSignals(with: signalData, and: restoredData)
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
        
        let initSet = self.getDataSet(color: ConstantSignal.chartColor, label: "Initial Signal", alpha: 0.3)
        let restoredSet = self.getDataSet(color: ConstantSignal.chartRestoredColor, label: "Restored Signal", alpha: 0.3)
        
        addEntries(for: initSet, values: initValues)
        addEntries(for: restoredSet, values: restoredValues)
    
        self.lineChartView.data = LineChartData(dataSets: [initSet, restoredSet])
    }
}
