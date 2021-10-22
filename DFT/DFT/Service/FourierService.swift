//
// FourierService.swift
// DFT
//
// Created by Ilya Baryko on 17.10.21.
// 
//


import Foundation

final class FourierService {

    // MARK: - Static
    static func getFFT(with inData: [Double], invert: Bool = false) -> Spectrum {
        return Spectrum(with: Fourier.fft(with: inData, invert: invert))
    }
    
    static func getDFT(with inData: [Double]) -> Spectrum {
        var fourierData = [DFTFourierOutput]()
        for j in 0..<inData.count {
            fourierData.append(Fourier.dft(j: j, inData: inData))
        }
        return Spectrum(with: fourierData)
    }
    
    static func filterSignal<T: FourierOutput>(with spectrum: Spectrum, by filter: ((Double) -> Bool)) -> [T] {
        return []
    }
}
