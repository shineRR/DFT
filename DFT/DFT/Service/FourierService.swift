//
// FourierService.swift
// DFT
//
// Created by Ilya Baryko on 17.10.21.
// 
//


import Foundation

final class FourierService {
    
    private static let zeroSpectrum = (amplitude: 0.0, phase: 0.0)

    // MARK: - Static Methods
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
    
    static func filterSignal(with spectrum: Spectrum, by filter: ((Int) -> Bool)) -> Spectrum {
        let length = spectrum.count
        let halfLength = length / 2
        
        let result = Spectrum()
        for (i, value) in spectrum.enumerated() {
            var index = i
            if index > halfLength {
                index = length - index
            }
            result.append(filter(index) ? value : self.zeroSpectrum)
        }
        
        return result
    }
}
