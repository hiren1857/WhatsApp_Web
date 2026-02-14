//
//  UIButton+Ext.swift
//  WhatsApp Web
//
//  Created by mac on 15/06/24.
//

import Foundation
import UIKit

extension UIButton {

    func flash() {
        // Take as snapshot of the button and render as a template
        let snapshot = self.snapshot?.withRenderingMode(.alwaysTemplate)
        let imageView = UIImageView(image: snapshot)
        // Add it image view and render close to white
        imageView.tintColor = UIColor(white: 0.9, alpha: 0.35)
        imageView.tintColor = UIColor.white
        imageView.alpha = 0.3
        guard let image = imageView.snapshot  else { return }
        let width = image.size.width
        let height = image.size.height
        // Create CALayer and add light content to it
        let shineLayer = CALayer()
        shineLayer.contents = image.cgImage
        shineLayer.frame = bounds

        // create CAGradientLayer that will act as mask clear = not shown, opaque = rendered
        // Adjust gradient to increase width and angle of highlight
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.clear.cgColor,
                                UIColor.clear.cgColor,
                                UIColor.black.cgColor,
                                UIColor.clear.cgColor,
                                UIColor.clear.cgColor]
        gradientLayer.locations = [0.0, 0.35, 0.50, 0.65, 0.0]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.0)

        gradientLayer.frame = CGRect(x: CGFloat(-width), y: 0, width: width, height: height)
        // Create CA animation that will move mask from outside bounds left to outside bounds right
        let animation = CABasicAnimation(keyPath: "position.x")
        animation.byValue = width * 2
        // How long it takes for glare to move across button
        animation.duration = 3
        // Repeat forever
        animation.repeatCount = Float.greatestFiniteMagnitude
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)

        layer.addSublayer(shineLayer)
        shineLayer.mask = gradientLayer

        // Add animation
        gradientLayer.add(animation, forKey: "shine")
    }

    func stopFlash() {
        // Search all sublayer masks for "shine" animation and remove
        layer.sublayers?.forEach {
            $0.mask?.removeAnimation(forKey: "shine")
        }
    }
}

extension UIButton: CAAnimationDelegate {
    
    func playBounceAnimation() {
        let bounceAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        bounceAnimation.values = [1.0 ,1.05, 0.9, 1.0, 0.95, 1.0, 1.0]
        bounceAnimation.duration = TimeInterval(0.9)
        bounceAnimation.calculationMode = CAAnimationCalculationMode.cubic
        bounceAnimation.delegate = self
        layer.add(bounceAnimation, forKey: "bounceAnimation")
    }
    
    func stopBounceAnimation() {
        layer.removeAnimation(forKey: "bounceAnimation")
    }

    public func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if flag {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                self.playBounceAnimation()
            }

        }
    }
}
