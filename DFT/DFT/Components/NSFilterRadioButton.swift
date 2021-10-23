//
// NSFilterRadioButton.swift
// DFT
//
// Created by Ilya Baryko on 23.10.21.
// 
//


import Cocoa

enum FilterType: Int {
    case low = 0
    case high
    case bandPass
}

class NSFilterRadioButton: NSButton {
    
    // MARK: - IBInspectable
    
    /// Low - 0, High - 1, Band pass - 2
    @IBInspectable private var filter: Int = 0 {
        didSet {
            self.filterType = FilterType(rawValue: filter)
        }
    }
    
    // MARK: - Properties
    var filterType: FilterType!
}
