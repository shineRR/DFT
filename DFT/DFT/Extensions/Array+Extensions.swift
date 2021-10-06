//
// Array+Extensions.swift
// DFT
//
// Created by Ilya Baryko on 6.10.21.
// 
//


import Foundation

extension Array where Element == FourierOutput {
    func getAmplitudeSpectrum() -> [Double] {
        return self.map({ hypot($0.acos, $0.asin) })
    }
    
    func getPhaseSpectrum() -> [Double] {
        return self.map({ atan2($0.asin, $0.acos) })
    }
}
