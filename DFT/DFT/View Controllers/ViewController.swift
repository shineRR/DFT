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
    private let N = 32
    
    // MARK: - Override
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.execute()
    }
    
    // MARK: - Methods
    private func execute() {
        var inData = [Complex<Double>]()
        
        for i in 0..<N {
            inData.append(Complex(Math.cos(3 * i * 0.125) + Math.sin(2 * i * 0.125), 0.0))
        }
        
        // MARK: - DFT
        let outData = Fourier.dft(in: inData)
    }
}
