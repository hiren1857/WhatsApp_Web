//
//  UIViewController + Ext.swift
//  Dual Camera
//
//  Created by mac on 03/06/24.
//

import Foundation
import UIKit
import CoreData

extension UIViewController {
    
    // Ipad and iPhone Size
    func IpadorIphone(value:Double) -> Double {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return ((value / 2) * 3)
        } else if UIDevice.current.userInterfaceIdiom == .phone {
            return value
        } else {
            return value
        }
    }
    
    // Hide keyboard
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    //     PopUp Center Open Animation
//        func animateScaleIn(desiredView: UIView) {
//            let backgroundView = self.view!
//            backgroundView.addSubview(desiredView)
//            desiredView.center = backgroundView.center
//            desiredView.isHidden = false
//            desiredView.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
//            desiredView.alpha = 0
//            UIView.animate(withDuration: 0.2) {
//                desiredView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
//                desiredView.alpha = 1
//            }
//        }

    // PopUp Open Animation
    func animateScaleIn(desiredView: UIView) {
        let backgroundView = self.view!
        backgroundView.addSubview(desiredView)
        desiredView.center = CGPoint(x: backgroundView.bounds.width / 2, y: backgroundView.bounds.height / 3)
        
        desiredView.isHidden = false
        desiredView.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        desiredView.alpha = 0
        UIView.animate(withDuration: 0.2) {
            desiredView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            desiredView.alpha = 1
        }
    }
    
    // PopUp Close Animation
    func animateScaleOut(desiredView: UIView) {
        UIView.animate(withDuration: 0.2, animations: {
            desiredView.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            desiredView.alpha = 0
        }, completion: { (success: Bool) in
            desiredView.removeFromSuperview()
        })
        UIView.animate(withDuration: 0.2, animations: {
        }, completion: { _ in
        })
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    // Context
    var context : NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    func saveImageToDocumentDirectory(image: UIImage, fileName: String) -> URL? {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        
        do {
            if let data = image.jpegData(compressionQuality: 1.0) {
                try data.write(to: fileURL)
                return fileURL
            }
        } catch {
            print("Error saving image to document directory: \(error)")
        }
        
        return nil
    }
    
    func getImageFromDocumentDirectory(fileName: String) -> UIImage? {
        let fileURL = getDocumentDirectoryURL().appendingPathComponent(fileName)
        return UIImage(contentsOfFile: fileURL.path)
    }
    
    func getDocumentDirectoryURL() -> URL {
        let documentDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentDirectoryURL
    }
}
