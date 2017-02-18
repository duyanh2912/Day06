//
//  Animator.swift
//  Day06
//
//  Created by Duy Anh on 2/19/17.
//  Copyright © 2017 Duy Anh. All rights reserved.
//

import UIKit

class CustomAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    let duration: Double = 0.3
    var presenting: Bool = true
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let toView = transitionContext.view(forKey: .to)!
        let fromView = transitionContext.view(forKey: .from)!
        
        if presenting {
            present(fromView: fromView, toView: toView, context: transitionContext)
        } else {
            dismiss(fromView: fromView, toView: toView, context: transitionContext)
        }
    }
    
    func present(fromView: UIView, toView: UIView, context: UIViewControllerContextTransitioning) {
        let container = context.containerView
        container.addSubview(toView)
        
        let mask = UIImageView(image: #imageLiteral(resourceName: "Triangle"))
        mask.center = container.center
        toView.mask = mask
        
        mask.transform = .init(scaleX: 0.1, y: 0.1)
        UIView.animate(withDuration: duration, animations: {
            mask.transform = .init(scaleX: 7, y: 7)
        }) { _ in
            context.completeTransition(true)
        }
    }
    
    func dismiss(fromView: UIView, toView: UIView, context: UIViewControllerContextTransitioning) {
        let container = context.containerView
        container.addSubview(toView)
        container.bringSubview(toFront: fromView)
        
        let mask = UIImageView(image: #imageLiteral(resourceName: "Triangle"))
        mask.center = container.center
        fromView.mask = mask
        
        mask.transform = .init(scaleX: 7, y: 7)
        UIView.animate(withDuration: duration, animations: {
            mask.transform = .init(scaleX: 0.1, y: 0.1)
        }) { _ in
            context.completeTransition(true)
        }
    }
}
