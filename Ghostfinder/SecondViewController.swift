//
//  SecondViewController.swift
//  Ghostfinder
//
//  Created by Bruno Omella Mainieri on 14/06/19.
//  Copyright © 2019 Bruno Omella Mainieri. All rights reserved.
//

import UIKit
import CoreMotion

class SecondViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var instructionLabel: UILabel!
    @IBOutlet weak var buttonOutlet: UIButton!
    
    let images:[UIImage] = [#imageLiteral(resourceName: "phone"),#imageLiteral(resourceName: "white outline"),#imageLiteral(resourceName: "red outline")]
    
    var isPhoneSet = false
    var phoneHasMoved = false
    
    let motion = CMMotionManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buttonOutlet.layer.cornerRadius = 5
        startDeviceMotion()
    }

    var updatesSinceMovement = 0
    
    func startDeviceMotion() {
        if motion.isDeviceMotionAvailable {
            self.motion.deviceMotionUpdateInterval = 1.0 / 60.0
            self.motion.showsDeviceMovementDisplay = true
            self.motion.startDeviceMotionUpdates(using: .xMagneticNorthZVertical)
            
            var timer = Timer(fire: Date(), interval: (1.0 / 60.0), repeats: true,
                              block: { (timer) in
                                self.updatesSinceMovement += 1
                                if let data = self.motion.deviceMotion {
                                    let xAcc = data.userAcceleration.x
                                    let yAcc = data.userAcceleration.y
                                    let zAcc = data.userAcceleration.z
                                    let totalAcc = abs(xAcc) + abs(yAcc) + abs (zAcc)
                                    if self.isPhoneSet{
                                        if !self.phoneHasMoved{
                                            if totalAcc > 0.04 {
                                                self.didDetectPoltergeist()
                                            }
                                        }
                                    } else {
                                        if totalAcc > 0.04{
                                            self.buttonOutlet.isEnabled = false
                                            self.updatesSinceMovement = 0
                                        } else {
                                            if self.updatesSinceMovement > 30 {
                                                self.buttonOutlet.isEnabled = true
                                            }
                                        }
                                    }
                                }
            })
            
            RunLoop.current.add(timer, forMode: RunLoop.Mode.default)
        }
    }
    
    func didSet(){
        isPhoneSet = true
        imageView.image = images[1]
        buttonOutlet.setTitle("RESET", for: .normal)
        instructionLabel.text = "THE PHONE HAS NOT BEEN MOVED"
        instructionLabel.textColor = #colorLiteral(red: 0.9725490212, green: 0.8775172205, blue: 0, alpha: 1)
        phoneHasMoved = false
    }
    
    func didReset(){
        isPhoneSet = false
        imageView.image = images[0]
        buttonOutlet.setTitle("SET", for: .normal)
        instructionLabel.text = "SET PHONE ON TABLE"
        instructionLabel.textColor = #colorLiteral(red: 0.9725490212, green: 0.8775172205, blue: 0, alpha: 1)
        phoneHasMoved = false
    }
    
    func didDetectPoltergeist(){
        if isPhoneSet{
            imageView.image = images[2]
            instructionLabel.text = "THE PHONE HAS BEEN MOVED!"
            instructionLabel.textColor = #colorLiteral(red: 0.8211487532, green: 0.003459738102, blue: 0.1056461111, alpha: 1)
            phoneHasMoved = true
        }
    }
    
    @IBAction func buttonAction(_ sender: Any) {
        if isPhoneSet{
            didReset()
        } else {
            didSet()
        }
    }
    

    
}

