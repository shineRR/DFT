//
// Fourier.swift
// DFT
//
// Created by Ilya Baryko on 3.10.21.
// 
//


import Foundation

typealias FourierOutput = (acos: Double, asin: Double)

class Fourier {
    
    static func dftBSUIR(j: Int, inData: [Double]) -> FourierOutput {
        let length = inData.count
        let mul = 2.0 / Double(length)
        
        var acos = 0.0
        var asin = 0.0
        
        for i in 0..<length {
            let angle = 2.0 * Double.pi * Double(j) * Double(i) / Double(length)
            acos += inData[i] * cos(angle)
            asin += inData[i] * sin(angle)
        }
        
        return (acos: acos * mul, asin: asin * mul)
    }
    
    
//    static func getW(for k: Int, with n: Int) -> Complex<Double> {
//        guard k % n != 0 else { return  Complex<Double>(1.0) }
//        let arg = -2.0 * Double.pi * Double(k) / Double(n)
//        return Complex(cos(arg), sin(arg))
//    }
//    
//    static func fft(x: [Complex<Double>]) -> [Complex<Double>] {
//        let xLength = x.count
//        if xLength == 1 { return x }
//        if xLength % 2 != 0 { return x }
//        
//        var newX = [Complex<Double>]()
//        if (xLength == 2) {
//            newX.append(x[0] + x[1])
//            newX.append(x[0] - x[1])
//        } else {
//            let halfLength = xLength / 2
//            
//            var xEven = [Complex<Double>]()
//            var xOdd = [Complex<Double>]()
//            
//            for i in 0..<halfLength {
//                xEven.append(x[2 * i])
//                xOdd.append(x[2 * i + 1])
//            }
//            
//            let xEvenNext = fft(x: xEven)
//            let xOddNext = fft(x: xOdd)
//            
//            newX.removeAll()
//            newX.append(contentsOf: Array.init(repeating: Complex<Double>(1.0), count: xLength))
//            
//            for i in 0..<halfLength {
//                newX[i] = xEvenNext[i] + getW(for: i, with: xLength) * xOddNext[i]
//                newX[i + halfLength] = xEvenNext[i] - getW(for: i, with: xLength) * xOddNext[i]
//            }
//        }
//        
//        return newX
//    }
//    
//    static func dft(in x: [Complex<Double>]) -> [Complex<Double>] {
//        var output = [Complex<Double>]()
//        let length = x.count
//
//        for i in 0..<length {
//            var re = 0.0
//            var im = 0.0
//
//            for j in 0..<length {
//                let angle = 2.0 * Double.pi * Double(j) * Double(i) / Double(length)
//                re += x[j].real * cos(angle) - x[j].imaginary * sin(angle)
//                im += -x[j].real * sin(angle) + x[j].imaginary * cos(angle);
//            }
//            output.append(Complex<Double>(re, im))
//        }
//
//        return output
//    }
//
//    static func idft(in x: [Complex<Double>]) -> [Complex<Double>] {
//        var output = [Complex<Double>]()
//        let length = x.count
//
//        for i in 0..<length {
//            var re = 0.0
//            var im = 0.0
//
//            for j in 0..<length {
//                let angle = 2.0 * Double.pi * Double(j) * Double(i) / Double(length)
//                re += x[j].real * cos(angle) + x[j].imaginary * sin(angle)
//                im += x[j].real * sin(angle) + x[j].imaginary * cos(angle);
//            }
//            output.append(Complex<Double>(re / Double(length), im / Double(length)))
//        }
//
//        return output
//    }
    
//    static func halfReverse(in x: [Complex<Double>]) -> [Complex<Double>] {
//        var output = Array.init(repeating: Complex<Double>(1.0), count: x.count)
//        for i in 0..<(x.count / 2) {
//            output[x.count / 2 - 1 - i] = x[i]
//            output[x.count - 1 - i] = x[x.count / 2 + i]
//        }
//        return output
//    }
}
