//
// ViewController.swift
// DFT
//
// Created by Ilya Baryko on 3.10.21.
// 
//


import Cocoa
import Numerics

class ViewController: NSViewController {

    // MARK: - Properties
    private let fd = Double(ConstantSignal.nCount) / 2.0
    private let initPhase = [Double.pi / 6, Double.pi / 4, Double.pi / 3, Double.pi / 2, 3 * Double.pi / 4, Double.pi]
    private let initAmplitude = [1.0, 3.0, 5.0, 8.0, 10.0, 12.0, 16.0]
    
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
}
