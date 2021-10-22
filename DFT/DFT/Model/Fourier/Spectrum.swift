//
// Spectrum.swift
// DFT
//
// Created by Ilya Baryko on 22.10.21.
// 
//


import Foundation

protocol SpectrumProtocol {
    func getAmplitude() -> Double
    func getPhase() -> Double
}

class Spectrum: Sequence {
    
    // MARK: - Properties
    var amplitude = [Double]()
    var phase = [Double]()
    var count: Int {
        return amplitude.count > phase.count ? phase.count
                                             : amplitude.count
    }
    
    // MARK: - Init
    init(with spectrum: [SpectrumProtocol] = []) {
        self.amplitude = spectrum.map({ $0.getAmplitude() })
        self.phase = spectrum.map({ $0.getPhase() })
    }
    
    // MARK: - Methods
    func append(_ newElement: (amplitude: Double, phase: Double)) {
        self.amplitude.append(newElement.amplitude)
        self.phase.append(newElement.phase)
    }
    
    func makeIterator() -> AnyIterator<(amplitude: Double, phase: Double)> {
        var index = 0
        return AnyIterator {
            defer { index += 1 }
            return self.count > index ? (amplitude: self.amplitude[index], phase: self.phase[index])
                                      : nil
        }
    }
}
