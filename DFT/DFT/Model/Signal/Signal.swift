//
// Signal.swift
// DFT
//
// Created by Ilya Baryko on 22.10.21.
// 
//


import Foundation

protocol RestorableSignal {
    var values: [Double] { get }
    
    func getDFT() -> Spectrum
    func getFFT() -> Spectrum
    func restoreSignal(with spectrum: Spectrum, shouldUsePhase: Bool) -> [Double]
}

class Signal: RestorableSignal {
    
    // MARK: - Properties
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
        var restoredSignal = [Double]()
        
        for i in 0..<length {
            var temp = 0.0
            for j in 0...halfLength {
                let angle = 2.0 * Double.pi * Double(j) * Double(i) / Double(length)
                temp += spectrum.amplitude[j] * cos(angle - spectrum.phase[j])
            }
            restoredSignal.append(temp)
        }
        
        return restoredSignal
    }
    
    private func createSignal() -> [Double] {
        var data = [Double]()
        for i in 0..<Constants.nCount {
            let angle = 2 * Double.pi * Double(i) * Constants.frequency / Double(Constants.nCount)
            let value = Constants.amplitude * cos(angle)
            data.append(value)
        }
        return data
    }
}
