//
// FourierOutput.swift
// DFT
//
// Created by Ilya Baryko on 22.10.21.
// 
//


import Foundation

class FFTFourierOutput: FourierOutput, SpectrumProtocol {
    func getAmplitude() -> Double {
        let mul = 2.0 / Double(Constants.nCount)
        return self.hypot() * mul
    }
    
    func getPhase() -> Double {
        return -self.atan2()
    }
}

class DFTFourierOutput: FourierOutput, SpectrumProtocol {
    func getAmplitude() -> Double {
        return self.hypot()
    }
    
    func getPhase() -> Double {
        return self.atan2()
    }
}

class FourierOutput {
    
    // MARK: - Properties
    var acos: Double
    var asin: Double
    
    // MARK: - Init
    init(acos: Double = 0.0, asin: Double = 0.0) {
        self.acos = acos
        self.asin = asin
    }
    
    convenience init(_ data: FourierOutput) {
        self.init(acos: data.acos, asin: data.asin)
    }
    
    // MARK: - Methods
    func hypot() -> Double {
        return Darwin.hypot(asin, acos)
    }
    
    func atan2() -> Double {
        return Darwin.atan2(asin, acos)
    }
    
    // MARK: - Static
    static func + (_ lhs: FourierOutput, _ rhs: FourierOutput) -> FourierOutput {
        return FourierOutput(acos: lhs.acos + rhs.acos,
                             asin: lhs.asin + rhs.asin)
    }
    
    static func - (_ lhs: FourierOutput, _ rhs: FourierOutput) -> FourierOutput {
        return FourierOutput(acos: lhs.acos - rhs.acos,
                             asin: lhs.asin - rhs.asin)
    }
    
    static func * (_ lhs: FourierOutput, _ rhs: FourierOutput) -> FourierOutput {
        return FourierOutput(acos: (lhs.acos * rhs.acos - lhs.asin * rhs.asin),
                             asin: (lhs.acos * rhs.asin + lhs.asin * rhs.acos))
    }
}
