//
// PolyharmonicSignal.swift
// DFT
//
// Created by Ilya Baryko on 22.10.21.
// 
//


import Foundation

class PolyharmonicSignal: RestorableSignal {
    
    // MARK: - Properties
    private let initPhase = [Double.pi / 6, Double.pi / 4, Double.pi / 3, Double.pi / 2, 3 * Double.pi / 4, Double.pi]
    private let initAmplitude = [1.0, 3.0, 5.0, 8.0, 10.0, 12.0, 16.0]
    
    private(set) var values = [Double]()
    
    // MARK: - Init
    init() {
        self.values = self.createSignal()
    }
    
    // MARK: - Methods
    func getDFT() -> Spectrum {
        return FourierService.getDFT(with: self.values)
    }
    
    func getFFT() -> Spectrum {
        return FourierService.getFFT(with: self.values)
    }
    
    func restoreSignal(with spectrum: Spectrum, shouldUsePhase: Bool = false) -> [Double] {
        let length = spectrum.count
        let halfLength = (length / 2) - 1
        var yValues = [Double]()
        for i in 0..<length{
            var y = spectrum.amplitude[0] / 2
            for j in 1...halfLength {
                let angle = 2.0 * Double.pi * Double(j) * Double(i) / Double(length)
                let phase = shouldUsePhase ? spectrum.phase[j] : 0.0
                y += spectrum.amplitude[j] * cos(angle - phase)
            }
            yValues.append(y)
        }
        
        return yValues
    }
    
    private func createSignal() -> [Double] {
        guard let amplitude = self.initAmplitude.randomElement(),
              let phase = self.initPhase.randomElement() else { return [] }
        
        var output = [Double]()
        
        for i in 0..<Constants.nCount {
            var x = 0.0
            for j in 1...30 {
                let angle = 2.0 * Double.pi * Double(j) * Double(i) / Double(Constants.nCount)
                x += amplitude * cos(angle - phase)
            }
            output.append(x)
        }
        
        return output
    }
}
