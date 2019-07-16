//
//  ViewController.swift
//  JakartaLearningProject
//
//  Created by Andi Ikhsan Eldrian on 13/07/19.
//  Copyright © 2019 Andi Ikhsan Eldrian. All rights reserved.
//

import UIKit
import AVKit
import Vision
import Photos


class ViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {

    let identifierLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    var captured = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupIdentifierConfidenceLabel()
        startCamera()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        captured = false
    }
    
    fileprivate func setupIdentifierConfidenceLabel() {
        view.addSubview(identifierLabel)
        identifierLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -32).isActive = true
        identifierLabel.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        identifierLabel.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        identifierLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    func startCamera() {
        let captureSession = AVCaptureSession()
        captureSession.sessionPreset = .hd4K3840x2160
        
        guard let captureDevice = AVCaptureDevice.default(for: .video) else { return }
        guard let input = try? AVCaptureDeviceInput(device: captureDevice) else { return }
        captureSession.addInput(input)
        
        captureSession.startRunning()
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        view.layer.addSublayer(previewLayer)
        previewLayer.frame = view.frame
        
        let dataOutput = AVCaptureVideoDataOutput()
        dataOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
        captureSession.addOutput(dataOutput)
    }
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
    
        guard let pixelBuffer: CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        
        
        guard let model = try? VNCoreMLModel(for: MLKotaTuaV3().model) else { return }
        
        let request = VNCoreMLRequest(model: model) { (finishedReq, err) in

            guard let results = finishedReq.results as? [VNClassificationObservation] else { return }
            guard let firstObservation = results.first else { return }
            
            DispatchQueue.main.async {
                if firstObservation.confidence >= 0.99{
                    switch firstObservation.identifier {
                    case "Café Batavia":
                        if !self.captured {
                            self.performSegue(withIdentifier:" cafebatavia", sender: self)
                            print("berhasil")
                            self.captured = true
                        }
                        print(self.captured)
                    case "The Wayang Museum":
                        if !self.captured {
                            self.performSegue(withIdentifier:"wayangmuseum", sender: self)
                            print("berhasil")
                            self.captured = true
                        }
                        print(self.captured)
                    case "The Bank Indonesia Museum":
                        if !self.captured {
                            self.performSegue(withIdentifier:"bankindomuseum", sender: self)
                            print("berhasil")
                            self.captured = true
                        }
                        print(self.captured)
                    case "The Bank Mandiri Museum":
                        if !self.captured {
                            self.performSegue(withIdentifier:"bankmandirimuseum", sender: self)
                            print("berhasil")
                            self.captured = true
                        }
                        print(self.captured)
                    case "Jakarta History Museum":
                      if !self.captured {
                        self.performSegue(withIdentifier:"jkthistorymuseum", sender: self)
                        print("berhasil")
                        self.captured = true
                      }
                      print(self.captured)
                    case "The Fine Arts and Ceramic Museum":
                        if !self.captured {
                            self.performSegue(withIdentifier:"ancmuseum", sender: self)
                            print("berhasil")
                            self.captured = true
                            
                        }
                        print(self.captured)
                    case "The Red Shop":
                        if !self.captured {
                            self.performSegue(withIdentifier:"redshop", sender: self)
                            print("berhasil")
                            self.captured = true
                        }
                        print(self.captured)
                    default:
                        return
                    }
                } else {
                    self.identifierLabel.text = "Please point to an object!"
                }
                

            }
            
        }
        
        try? VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:]).perform([request])
    }


  
}

