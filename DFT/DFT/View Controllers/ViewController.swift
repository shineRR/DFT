//
// ViewController.swift
// DFT
//
// Created by Ilya Baryko on 3.10.21.
// 
//


import Cocoa
import Numerics

class ViewController: NSViewController {

    // MARK: - Properties
    private let fd = Double(ConstantSignal.nCount) / 2.0
    
    // MARK: - Override
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.execute()
    }
    
    // MARK: - Methods
    private func execute() {
        // MARK: - DFT
        var compexData = [Complex<Double>]()
        
        for _ in 0..<ConstantSignal.nCount {
            let value = 10 * cos(2 * Double.pi / Double(ConstantSignal.nCount))
            compexData.append(Complex<Double>(value))
        }
        
        let four = Fourier.dft(in: compexData)
//        let inv = Fourier.idft(in: four)
        
        self.amplitude(data: four)
        self.phase(data: four)
    }
    
    private func amplitude(data: [Complex<Double>]) {
        var array = [Double]()
        data.forEach {
            array.append(sqrt(pow($0.real, 2) + pow($0.imaginary, 2)))
        }
    }
    
    private func phase(data: [Complex<Double>]) {
        var array = [Double]()
        data.forEach {
            array.append(atan($0.imaginary / $0.real))
        }
    }
}
