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

class Spectrum {
    
    // MARK: - Properties
    var amplitude = [Double]()
    var phase = [Double]()
    var count: Int {
        return amplitude.count > phase.count ? phase.count
                                             : amplitude.count
    }
    
    // MARK: - Init
    init(with spectrum: [SpectrumProtocol]) {
        self.amplitude = spectrum.map({ $0.getAmplitude() })
        self.phase = spectrum.map({ $0.getPhase() })
    }
}
