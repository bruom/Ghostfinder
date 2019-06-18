//
//  MeterView.swift
//  Ghostfinder
//
//  Created by Bruno Omella Mainieri on 14/06/19.
//  Copyright © 2019 Bruno Omella Mainieri. All rights reserved.
//

import UIKit

@IBDesignable
class MeterView: UIView {

//    @IBInspectable var fillColor: UIColor? = .clear
//
//    @IBInspectable var strokeColor: UIColor? = .clear
//
//    @IBInspectable var strokeWidth: Float = 1
    
    override func draw(_ rect: CGRect) {
        var path:UIBezierPath = UIBezierPath()
        path.move(to: CGPoint(x: bounds.minX, y: bounds.maxY))
        path.addLine(to: CGPoint(x: bounds.maxX, y: bounds.minY))
        path.addLine(to: CGPoint(x: bounds.maxX, y: bounds.maxY))
        path.close()
        #colorLiteral(red: 0.1625983715, green: 0.3092048168, blue: 0.3636757135, alpha: 1).setFill()
//        fillColor?.setFill()
        path.fill()
//        strokeColor?.setStroke()
//        path.lineWidth = CGFloat(strokeWidth)
//        path.stroke()
        
    }

}
