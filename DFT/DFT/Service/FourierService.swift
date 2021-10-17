//
// FourierService.swift
// DFT
//
// Created by Ilya Baryko on 17.10.21.
// 
//


import Foundation

final class FourierService {
    
    // MARK: - Delegate
    var delegate: ChartDelegate?
    
    // MARK: - Properties
    private let fd = Double(ConstantSignal.nCount) / 2.0
    private let initPhase = [Double.pi / 6, Double.pi / 4, Double.pi / 3, Double.pi / 2, 3 * Double.pi / 4, Double.pi]
    private let initAmplitude = [1.0, 3.0, 5.0, 8.0, 10.0, 12.0, 16.0]
    
    private var data = [Double]()
    
    // MARK: - Init
    init() {
        self.data = self.signalValues()
    }
    
    // MARK: - Methods
    func getValues() -> [Double] {
        return self.data
    }
    
    func getDFT(with inData: [Double]) -> [FourierOutput] {
        var fourierData = [FourierOutput]()
        for j in 1..<inData.count {
            fourierData.append(Fourier.dftBSUIR(j: j, inData: inData))
        }
        return fourierData
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
        var output = [Double]()
        
        for i in 0..<ConstantSignal.nCount {
            var x = 0.0
            for j in 1...30 {
                guard let amplitude = self.initAmplitude.randomElement(),
                      let phase = self.initPhase.randomElement() else { continue }
                
                let angle = 2.0 * Double.pi * Double(j) * Double(i) / Double(ConstantSignal.frameCount)
                x += amplitude * cos(angle - phase)
            }
            output.append(x)
        }
        
        return output
    }

    func restoreSpectrumPolySignal(values: [FourierOutput], shouldUsePhase: Bool = false) -> [Double] {
        let halfLength = (values.count / 2) - 1
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
    
    private func signalValues() -> [Double] {
        var data = [Double]()
        let amplitude = 15.0
        let frequency = 7.0
        for i in 0..<ConstantSignal.nCount {
            let angle = 2 * Double.pi * Double(i) * frequency / Double(ConstantSignal.nCount)
            let value = amplitude * cos(angle)
            data.append(value)
        }
        return data
    }
}
