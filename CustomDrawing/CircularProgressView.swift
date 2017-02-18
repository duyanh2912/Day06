//
//  CircularProgressView.swift
//  Day06
//
//  Created by Duy Anh on 1/18/17.
//  Copyright © 2017 Duy Anh. All rights reserved.
//

import Utils
import RxCocoa
import RxSwift

@IBDesignable
public class CircularProgressView: UIView {
    @IBInspectable public var progressPercentage: CGFloat = 30
    @IBInspectable public var unfilledColor: UIColor = .darkGray
    @IBInspectable public var filledColor: UIColor = .lightGray
    
    override public func draw(_ rect: CGRect) {
        progressPercentage = progressPercentage < 0 ? 0 : progressPercentage
        progressPercentage = progressPercentage > 100 ? 100 : progressPercentage
        
        let edge = (rect.width > rect.height) ? rect.height : rect.width
        var drawRect = CGRect(x: 0, y: 0, width: edge, height: edge)
        drawRect = drawRect.move(point: drawRect.center, to: rect.center)
        
        let circle = UIBezierPath(ovalIn: drawRect)
        unfilledColor.setFill()
        circle.fill()
        
        let arc = UIBezierPath()
        arc.move(to: rect.center)
        arc.addArc(withCenter: rect.center, radius: edge / 2, startAngle: -CGFloat.pi/2, endAngle: progressPercentage / 100 * CGFloat.pi * 2 - CGFloat.pi/2, clockwise: true)
        filledColor.setFill()
        arc.fill()
    }
}

extension Reactive where Base: CircularProgressView {
    public var percent: UIBindingObserver<Base, CGFloat> {
        return UIBindingObserver(UIElement: self.base) { view, percent in
            view.progressPercentage = percent
            view.setNeedsDisplay()
        }
    }
}
