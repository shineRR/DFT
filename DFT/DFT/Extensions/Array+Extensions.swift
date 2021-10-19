//
// Array+Extensions.swift
// DFT
//
// Created by Ilya Baryko on 6.10.21.
// 
//


import Foundation

extension Array {
    func first(n elements: Int) -> [Element] {
        var result: [Element] = []
        for i in 0..<(elements <= self.count ? elements : self.count) {
            result.append(self[i])
        }
        return result
    }
}

extension Array where Element == FourierOutput {
    func getAmplitudeSpectrum() -> [Double] {
        return self.map({ $0.hypot() })
    }
    
    func getPhaseSpectrum() -> [Double] {
        return self.map({ $0.atan2() })
    }
}
