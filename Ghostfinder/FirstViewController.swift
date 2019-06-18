//
//  FirstViewController.swift
//  Ghostfinder
//
//  Created by Bruno Omella Mainieri on 14/06/19.
//  Copyright © 2019 Bruno Omella Mainieri. All rights reserved.
//

import UIKit
import CoreMotion

class FirstViewController: UIViewController {

    @IBOutlet weak var emptyBar: MeterView!
    @IBOutlet weak var filledBar: UIView!
    
    @IBOutlet weak var label: UILabel!
    
    let motion = CMMotionManager()
    var initialFillPosition:CGFloat = 0
    var fillBarLength:CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        filledBar.mask = emptyBar
        initialFillPosition = filledBar.frame.origin.x
        fillBarLength = filledBar.frame.width
        startDeviceMotion()
    }

    func startDeviceMotion() {
        if motion.isDeviceMotionAvailable {
            self.motion.deviceMotionUpdateInterval = 1.0 / 60.0
            self.motion.showsDeviceMovementDisplay = true
            self.motion.startDeviceMotionUpdates(using: .xMagneticNorthZVertical)
            
            var timer = Timer(fire: Date(), interval: (1.0 / 60.0), repeats: true,
                              block: { (timer) in
                                if let data = self.motion.deviceMotion {
                                    let magField = abs(data.magneticField.field.x) + abs(data.magneticField.field.y) + abs(data.magneticField.field.z)
                                    
                                    var percent = CGFloat(magField) / CGFloat(2500)
                                    percent = percent > 1 ? 1 : percent
                                    percent = percent < 0 ? 0 : percent
                                    self.updateBarFill(to: percent)
                                    
                                }
            })
            
            RunLoop.current.add(timer, forMode: RunLoop.Mode.default)
        }
    }
    
    func updateBarFill(to percent: CGFloat){
        var color:UIColor = #colorLiteral(red: 0.9725490212, green: 0.8775172205, blue: 0, alpha: 1)
        switch (percent*100) {
        case ..<10:
            self.label.text = "THERE ARE NO GHOSTS NEARBY"
            break
        case 10..<25:
            self.label.text = "THERE MIGHT BE SOME GHOSTS NEARBY"
            break
        case 25..<50:
            self.label.text = "THERE ARE A FEW GHOSTS NEARBY"
            break
        case 50..<75:
            self.label.text = "THERE ARE MANY GHOSTS NEARBY"
            break
        default:
            self.label.text = "THERE IS A GHOST RIGHT BEHIND YOU"
            color = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
            break
        }
        self.label.textColor = color
        UIView.animateKeyframes(withDuration: 1.0/60.0, delay: 0.0, options: UIView.KeyframeAnimationOptions(rawValue: 7), animations: {
            self.filledBar.frame.origin.x = self.initialFillPosition + (percent * self.fillBarLength)
            
        },completion: nil)
    }

}

