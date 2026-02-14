//
//  UIView+Ext.swift
//  WhatsApp Web
//
//  Created by mac on 15/06/24.
//

import Foundation
import UIKit

extension UIView {
    
    func addToTopShadow(shadowColor: UIColor, shadowOpacity: Float, shadowRadius: CGFloat, shadowOffset: CGSize) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = shadowColor.cgColor
        self.layer.shadowOpacity = shadowOpacity
        self.layer.shadowRadius = shadowRadius
        self.layer.shadowOffset = shadowOffset
        
        // Define the shadow path
        let shadowPath = UIBezierPath()
        let topLeft = CGPoint(x: 0, y: 0)
        let topRight = CGPoint(x: self.bounds.width, y: 0)
        let bottomLeft = CGPoint(x: 0, y: shadowRadius)
        let bottomRight = CGPoint(x: self.bounds.width, y: shadowRadius)
        
        shadowPath.move(to: topLeft)
        shadowPath.addLine(to: topRight)
        shadowPath.addLine(to: bottomRight)
        shadowPath.addLine(to: bottomLeft)
        shadowPath.close()
        
        self.layer.shadowPath = shadowPath.cgPath
    }
    
    func addTopShadow(shadowColor: UIColor = .black,
                      shadowOpacity: Float = 0.5,
                      shadowRadius: CGFloat = 4.0,
                      shadowOffset: CGSize = CGSize(width: 0, height: 3)) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = shadowColor.cgColor
        self.layer.shadowOpacity = shadowOpacity
        self.layer.shadowRadius = shadowRadius
        self.layer.shadowOffset = shadowOffset
        
        // Create a shadow path to optimize rendering performance
        let shadowPath = UIBezierPath(rect: CGRect(x: 0,
                                                   y: -shadowRadius,
                                                   width: self.bounds.width,
                                                   height: 3))
        self.layer.shadowPath = shadowPath.cgPath
    }
    
    // Helper to snapshot a view
    var snapshot: UIImage? {
        let renderer = UIGraphicsImageRenderer(size: bounds.size)
        let image = renderer.image { context in
            layer.render(in: context.cgContext)
        }
        return image
    }
    
    func addBlurToView() {
        var blurEffect: UIBlurEffect!
        blurEffect = UIBlurEffect(style: .dark)
        let blurredEffectView = UIVisualEffectView(effect: blurEffect)
        blurredEffectView.frame = self.bounds
        blurredEffectView.alpha = 0.9
        blurredEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(blurredEffectView)
    }
    
    func removeBlurFromView() {
        for subview in self.subviews {
            if subview is UIVisualEffectView {
                subview.removeFromSuperview()
            }
        }
    }
    
    func flashInView() {
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
    
    func stopFlashInView() {
        // Search all sublayer masks for "shine" animation and remove
        layer.sublayers?.forEach {
            $0.mask?.removeAnimation(forKey: "shine")
        }
    }
}

