//
// NSSignalRadioButton.swift
// DFT
//
// Created by Ilya Baryko on 23.10.21.
// 
//


import Cocoa

enum SignalType: Int {
    case signal = 0
    case polyharmonic
}

class NSSignalRadioButton: NSButton {
    
    // MARK: - IBInspectable
    
    /// Signal - 0, PolyharmonicSignal - 1
    @IBInspectable private var signal: Int = 0 {
        didSet {
            self.signalType = SignalType(rawValue: signal)
        }
    }
    
    // MARK: - Properties
    var signalType: SignalType!
}
