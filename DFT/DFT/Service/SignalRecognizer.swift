//
// SignalRecognizer.swift
// SignalProcessing
//
// Created by Ilya Baryko on 18.09.21.
// 
//


import Foundation
import AVFoundation

protocol AudioSignal {
    func reproduceSignal()
    func setSignal(_ type: ReproducingSignal)
    func stopEngine()
}

enum ReproducingSignal {
    case initial = 0
    case restored
}

class SignalRecognizer: AudioSignal {
    
    // MARK: - Properties
    
    private let engine = AVAudioEngine()
    private var srcNode: AVAudioSourceNode!
    private var mainMixer: AVAudioMixerNode!
    private var output: AVAudioOutputNode!
    private var outputFormat: AVAudioFormat!
    private var inputFormat: AVAudioFormat!
    private var sampleRate: Float!
    
    private let duration: Int = 2
    private var signalForReproducing = [Double]()
    private var initSignal = [Double]()
    private var restoredSignal = [Double]()
    
    // MARK: - Init
    init(_ initSignal: [Double], _ restoredSignal: [Double]) {
        self.initSignal = initSignal
        self.restoredSignal = restoredSignal
        self.signalForReproducing = initSignal
        
        self.setupEngine()
    }
    
    // MARK: - Methods
    func setSignal(_ type: ReproducingSignal) {
        self.signalForReproducing = (type == .initial ? self.initSignal : self.restoredSignal)
    }
    
    func reproduceSignal() {
        self.saveFile()
        do {
            try engine.start()
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(duration)) {
                self.engine.stop()
            }
        } catch {
            print("Could not start engine: \(error)")
        }
    }
    
    func stopEngine() {
        self.engine.stop()
    }
    
    private func saveFile() {
        var samplesWritten: AVAudioFrameCount = 0
        var outputFormatSettings = srcNode.outputFormat(forBus: 0).settings
        outputFormatSettings[AVLinearPCMIsNonInterleaved] = false
       
        let outFile = try? AVAudioFile(forWriting: URL(fileURLWithPath: "file.wav"), settings: outputFormatSettings)
        let samplesToWrite = AVAudioFrameCount(duration * Int(sampleRate))
        srcNode.installTap(onBus: 0, bufferSize: 1024, format: inputFormat) { buffer, _ in
            if samplesWritten + buffer.frameLength > samplesToWrite {
                buffer.frameLength = samplesToWrite - samplesWritten
            }
            
            do {
                try outFile?.write(from: buffer)
            } catch {
                print("Error writing file \(error)")
            }
            
            samplesWritten += buffer.frameLength
            
            if samplesWritten >= samplesToWrite {
                return
            }
        }
    }
    
    private func getSourceNode() -> AVAudioSourceNode {
        return AVAudioSourceNode { _, _, frameCount, audioBufferList -> OSStatus in
            let ablPointer = UnsafeMutableAudioBufferListPointer(audioBufferList)
            for frame in 0..<Int(frameCount) {
                for buffer in ablPointer {
                    let buf: UnsafeMutableBufferPointer<Float> = UnsafeMutableBufferPointer(buffer)
                    buf[frame] = Float(self.signalForReproducing[frame])
                }
            }
            return noErr
        }
    }
    
    private func setupEngine() {
        self.mainMixer = engine.mainMixerNode
        self.output = engine.outputNode
        self.outputFormat = self.output.inputFormat(forBus: 0)
        self.sampleRate = Float(self.outputFormat.sampleRate)
        self.inputFormat = AVAudioFormat(commonFormat: outputFormat.commonFormat,
                                        sampleRate: outputFormat.sampleRate,
                                        channels: 1,
                                        interleaved: outputFormat.isInterleaved)
        self.srcNode = getSourceNode()
        engine.attach(self.srcNode)
        engine.connect(self.srcNode, to: mainMixer, format: inputFormat)
        engine.connect(mainMixer, to: output, format: outputFormat)
    }
}
