//
// NSViewController+Extensions.swift
// DFT
//
// Created by Ilya Baryko on 18.09.21.
// 
//


import Cocoa

// MARK: - NSViewController
extension NSViewController {
    func changeRadionButtonState(for buttons: [NSButton], to state: NSButton.StateValue, except button: NSButton) {
        buttons
            .filter({ $0 != button })
            .forEach { $0.state = state }
    }
}
