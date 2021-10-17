//
// ViewController.swift
// DFT
//
// Created by Ilya Baryko on 3.10.21.
// 
//


import Cocoa
import Charts

class ViewController: NSViewController {

    // MARK: - Outlets
    @IBOutlet private weak var lineChartView: LineChartView!
    
    // MARK: - Properties
    private let fd = Double(ConstantSignal.nCount) / 2.0
    private let initPhase = [Double.pi / 6, Double.pi / 4, Double.pi / 3, Double.pi / 2, 3 * Double.pi / 4, Double.pi]
    private let initAmplitude = [1.0, 3.0, 5.0, 8.0, 10.0, 12.0, 16.0]
    
    private let chartColor = CGColor(red: 255/255, green: 80/255, blue: 0/255, alpha: 1)
    private let chartRestoredColor = CGColor(red: 255/255, green: 40/255, blue: 0/255, alpha: 1)
    
    // MARK: - Override
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.execute()
    }
    
    // MARK: - Methods
    private func execute() {
        
        // MARK: - DFT
        var compexData = [Double]()
        
        for i in 0..<ConstantSignal.nCount {
            let value = 10 * cos(2 * Double.pi * Double(i) / Double(ConstantSignal.nCount))
            compexData.append(value)
        }
        
        // 2
        var testData = [FourierOutput]()
        for j in 1...ConstantSignal.nCount {
            testData.append(Fourier.dftBSUIR(j: j, inData: compexData))
        }
        
        let amplitude = testData.getAmplitudeSpectrum()
        let phase = testData.getPhaseSpectrum()
        
        let restored = restoreSignal(amplitudeSpectrum: amplitude, phaseSpectrum: phase)
        
        // 3
        let poly = polyharmonicSignal()
        var test2Data = [FourierOutput]()
        for j in 1...ConstantSignal.nCount {
            test2Data.append(Fourier.dftBSUIR(j: j, inData: poly))
        }
        
        let test = restoreSpectrumPolySignal(values: test2Data, shouldUsePhase: true)
        
        print(poly)
        print(test)
    }
    
    func restoreSignal(amplitudeSpectrum: [Double], phaseSpectrum: [Double]) -> [Double] {
        let length = amplitudeSpectrum.count
        let halfLength = (length / 2) - 1
        var restoredSignal = [Double]()
        
        for i in 0..<length {
            var temp = 0.0
            for j in 0...halfLength {
                let angle = 2.0 * Double.pi * Double(j) * Double(i) / Double(length)
                temp += amplitudeSpectrum[j] * cos(angle - phaseSpectrum[j])
            }
            restoredSignal.append(temp)
        }
        
        return restoredSignal
    }
    
    func polyharmonicSignal() -> [Double] {
        let N = 128
        var output = [Double]()
        
        for i in 0..<ConstantSignal.nCount {
            var x = 0.0
            for j in 1...30 {
                guard let amplitude = self.initAmplitude.randomElement(),
                      let phase = self.initPhase.randomElement() else { continue }
                
                let angle = 2.0 * Double.pi * Double(j) * Double(i) / Double(N)
                x += amplitude * cos(angle - phase)
            }
            output.append(x)
        }
        
        return output
    }

    func restoreSpectrumPolySignal(values: [FourierOutput], shouldUsePhase: Bool = false) -> [Double] {
        let halfLength = values.count / 2
        var yValues = [Double]()
        for (i, value) in values.enumerated() {
            var y = hypot(value.acos, value.asin) / 2
            for j in 1..<halfLength {
                let angle = 2.0 * Double.pi * Double(j) * Double(i) / Double(values.count)
                let phase = shouldUsePhase ? atan2(value.asin, value.acos) : 0.0
                y += hypot(values[j].acos, values[j].asin) * cos(angle - phase)
            }
            yValues.append(y)
        }
        
        return yValues
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

        self.lineChartView.animate(xAxisDuration: 1.5, easingOption: .linear)
    }
    
    private func setData() {
        let set = getDataSet(color: chartColor, label: "Signal", alpha: 0.3)
        
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
        set.fill = Fill(color: (NSUIColor(cgColor: chartColor) ?? .blue))
        set.fillAlpha = CGFloat(alpha)
        set.highlightColor = .clear
        set.lineWidth = 2
        set.setColor(NSUIColor(cgColor: chartColor) ?? .blue)
        return set
    }
}
