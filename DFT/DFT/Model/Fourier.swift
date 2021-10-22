//
// Fourier.swift
// DFT
//
// Created by Ilya Baryko on 3.10.21.
// 
//


import Foundation

class Fourier {
    
    static func dft(j: Int, inData: [Double]) -> DFTFourierOutput {
        let length = inData.count
        let mul = 2.0 / Double(length)
        
        var acos = 0.0
        var asin = 0.0
        
        for i in 0..<length {
            let angle = 2.0 * Double.pi * Double(j) * Double(i) / Double(length)
            acos += inData[i] * cos(angle)
            asin += inData[i] * sin(angle)
        }
        
        return DFTFourierOutput(acos: acos * mul, asin: asin * mul)
    }
    
    static func fft(with inData: [Double], invert: Bool = false) -> [FFTFourierOutput] {
        let length = inData.count
        
        guard length > 1 else { return [FFTFourierOutput(acos: inData[0], asin: 0.0)] }
        guard length % 2 <= 0 else { return [] }

        let halfLength = length / 2

        var result = Array.init(repeating: FFTFourierOutput(acos: 0.0, asin: 0.0), count: length)
        var xEven = [Double]()
        var xOdd = [Double]()

        for i in 0..<halfLength {
            xEven.append(inData[2 * i])
            xOdd.append(inData[2 * i + 1])
        }
        
        let xEvenNext = fft(with: xEven)
        let xOddNext = fft(with: xOdd)
        
        for i in 0..<halfLength {
            let t = getW(for: i, with: length) * xOddNext[i]
            result[i]              = FFTFourierOutput(xEvenNext[i] + t)
            result[i + halfLength] = FFTFourierOutput(xEvenNext[i] - t)
        }
        
        return result
    }
    
    static private func getW(for k: Int, with n: Int) -> FFTFourierOutput {
        let arg = -2.0 * Double.pi * Double(k) / Double(n)
        return FFTFourierOutput(acos: cos(arg), asin: sin(arg))
    }
}
