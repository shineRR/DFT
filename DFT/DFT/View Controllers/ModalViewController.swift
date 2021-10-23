//
// ModalViewController.swift
// DFT
//
// Created by Ilya Baryko on 23.10.21.
// 
//


import Cocoa

class ModalViewController: NSViewController {

    // MARK: - Outlets
    @IBOutlet weak var amplitudeTextField: NSTextField!
    @IBOutlet weak var frequencyTextField: NSTextField!
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
    }
    
    // MARK: - IBAction
    @IBAction func didTapOnSave(_ sender: NSButton) {
        Constants.amplitude = self.amplitudeTextField.doubleValue
        Constants.frequency = self.frequencyTextField.doubleValue
        self.dismiss(self)
    }
    
    // MARK: - Methods
    private func setupUI() {
        self.amplitudeTextField.doubleValue = Constants.amplitude
        self.frequencyTextField.doubleValue = Constants.frequency
    }
}
