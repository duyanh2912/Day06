//
//  UIButton.swift
//  Hackathon
//
//  Created by Developer on 12/8/16.
//  Copyright © 2016 Developer. All rights reserved.
//
import UIKit
import Foundation

@IBDesignable
public class CustomUIButton: UIButton {
    @IBInspectable var cornerCircle: Bool = false {didSet{configCornerCircle()}}
    
    func configCornerCircle() {
        if cornerCircle {
            cornerRadius = (self.bounds.width + self.bounds.height) / 4
        }
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        configCornerCircle()
    }
}
