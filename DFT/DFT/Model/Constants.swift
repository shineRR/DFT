//
// Constants.swift
// DFT
//
// Created by Ilya Baryko on 22.09.21.
// 
//


import Foundation

struct Constants {
    
    // MARK: - General properties
    static let frameCount = 512
    static let nCount = 512
    static let harmonicCount = 512
    
    // MARK: - Signal Properties
    static var amplitude = 10.0
    static var frequency = 5.0
    
    // MARK: - Chart Helpers
    static let chartColor = CGColor(red: 255/255, green: 80/255, blue: 0/255, alpha: 1)
    static let chartRestoredColor = CGColor(red: 255/255, green: 0/255, blue: 0/255, alpha: 1)
}
