//
//  Utils.swift
//  SwiftDemo
//
//  Created by Redspark on 19/12/17.
//  Copyright © 2017 Redspark. All rights reserved.
//

import UIKit
import Foundation
import SystemConfiguration
import EventKit
import MobileCoreServices
import StoreKit
import QuickLook
import Photos
import ProgressHUD

class Utils: NSObject {

    func isConnectedToNetwork() -> Bool{
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return false
        }
        
        var flags: SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return false
        }
        
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        
        return (isReachable && !needsConnection)
    }
    
    func showLoader(text: String) {
        ProgressHUD.animationType = .circleDotSpinFade
        ProgressHUD.colorAnimation = UIColor(named: "6CCD1C") ?? UIColor.systemGreen
        ProgressHUD.colorHUD = UIColor.secondarySystemGroupedBackground
        ProgressHUD.fontStatus = UIFont(name: "AvenirNext-DemiBold", size: 24)!
        ProgressHUD.animate(text, interaction: false)
    }
    
    func hideLoader() {
        ProgressHUD.dismiss()
    }
    
    func showAlert(_ message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            
            }))
        UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.rootViewController!.present(alert, animated: true, completion: nil)
    }
    
    func showDialouge(_ title: String,_ message: String, view: UIViewController){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            }))
        view.present(alert, animated: true, completion: nil)
    }
    
    func showAlertControllerWith(title:String, message:String?, onVc:UIViewController , style: UIAlertController.Style = .alert, buttons:[String], completion:((Bool,Int)->Void)?) -> Void {

         let alertController = UIAlertController.init(title: title, message: message, preferredStyle: style)
         for (index,title) in buttons.enumerated() {
             let action = UIAlertAction.init(title: title, style: UIAlertAction.Style.default) { (action) in
                 completion?(true,index)
             }
             alertController.addAction(action)
         }

         onVc.present(alertController, animated: true, completion: nil)
     }

    func height(forText text: String?, font: UIFont?, withinWidth width: CGFloat) -> CGFloat {
        
        let constraint = CGSize(width: width, height: 20000.0)
        var size: CGSize
        var boundingBox: CGSize? = nil
        if let aFont = font {
            boundingBox = text?.boundingRect(with: constraint, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: aFont], context: nil).size
        }
        size = CGSize(width: ceil((boundingBox?.width)!), height: ceil((boundingBox?.height)!))
        return size.height
    }
    
    func ConvertDate(date: Date) -> String {
        
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "dd/MM/yyyy,hh:mm a"
        let resultString = inputFormatter.string(from: date)
        return resultString
    }
    
    func ConvertOnlyTime(date: Date) -> String {
        
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "hh:mm a"
        let resultString = inputFormatter.string(from: date)
        return resultString
    }
    
    func ConvertOnlyDate(date: Date) -> String {
        
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "dd/MM/yyyy"
        let resultString = inputFormatter.string(from: date)
        return resultString
    }
    
    func ConvertStringToDate1(stringDate: String) -> String {
        let dateFormatterUK = DateFormatter()
        dateFormatterUK.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatterUK.date(from: stringDate)!
        dateFormatterUK.dateFormat = "dd MMM yyyy hh:mm a"
        let resultString = dateFormatterUK.string(from: date)
        return resultString
    }
    
    func setupHome() {
        guard let window = UIApplication.shared.windows.filter({$0.isKeyWindow}).first else {
            return
        }
        let rootViewController = Constants.storyBoard.instantiateViewController(withIdentifier: "TabBarController") as! TabBarController
        let navigationController = UINavigationController(rootViewController: rootViewController)
        navigationController.isNavigationBarHidden = true
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        let options: UIView.AnimationOptions = .transitionCrossDissolve
        UIView.transition(with: window, duration: 0.3, options: options, animations: {}, completion: nil)
    }
  
    func ConvertStringToDate(stringDate: String) -> Date {
        let dateFormatterUK = DateFormatter()
        dateFormatterUK.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatterUK.date(from: stringDate)!
        return date
    }
    
    func getCreationDate(for image: UIImage?) -> Date {
        var creationDate = Date()
        if let imageData = image?.jpegData(compressionQuality: 1.0), let imageSource = CGImageSourceCreateWithData(imageData as CFData, nil) {
            let metadataOptions = [kCGImageSourceShouldCache: false] as CFDictionary
            if let metadata = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, metadataOptions) as? [String: Any], let date = metadata[kCGImagePropertyExifDateTimeOriginal as String] as? String {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy:MM:dd HH:mm:ss"
                creationDate = dateFormatter.date(from: date) ?? Date()
            }
        }
        return creationDate
    }

    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
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
    
    func getPastTime(for date : Date) -> String {

        var secondsAgo = Int(Date().timeIntervalSince(date))
        if secondsAgo < 0 {
            secondsAgo = secondsAgo * (-1)
        }

        let minute = 60
        let hour = 60 * minute
        let day = 24 * hour
        let week = 7 * day

        if secondsAgo < minute  {
            if secondsAgo < 2{
                return "just now"
            }else{
                return "\(secondsAgo) secs"
            }
        } else if secondsAgo < hour {
            let min = secondsAgo/minute
            if min == 1{
                return "\(min) min"
            }else{
                return "\(min) mins"
            }
        } else if secondsAgo < day {
            let hr = secondsAgo/hour
            if hr == 1{
                return "\(hr) hr"
            } else {
                return "\(hr) hrs"
            }
        } else if secondsAgo < week {
            let day = secondsAgo/day
            if day == 1{
                return "Yesterday"
            }else{
                
                let formatter = DateFormatter()
                formatter.dateFormat = "dd/mm/yyyy"
                let strDate: String = formatter.string(from: date)
                return strDate
            }
        } else {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/mm/yyyy"
            let strDate: String = formatter.string(from: date)
            return strDate
        }
    }
    
    func getAllCountry() -> [String] {
        var countries: [String] = []
        for code in NSLocale.isoCountryCodes  {
            let id = NSLocale.localeIdentifier(fromComponents: [NSLocale.Key.countryCode.rawValue: code])
            let name = NSLocale(localeIdentifier: "en_UK").displayName(forKey: NSLocale.Key.identifier, value: id) ?? "Country not found for code: \(code)"
            countries.append(name)
        }
        return countries
    }
    
    func getLabelsInView(view: UIView) -> [UILabel] {
        var results = [UILabel]()
        for subview in view.subviews as [UIView] {
            if let labelView = subview as? UILabel {
                results += [labelView]
            } else {
                results += getLabelsInView(view: subview)
            }
        }
        return results
    }
    
    func getButtonsInView(view: UIView) -> [UIButton] {
        var results = [UIButton]()
        for subview in view.subviews as [UIView] {
            if let labelView = subview as? UIButton {
                results += [labelView]
            } else {
                results += getButtonsInView(view: subview)
            }
        }
        return results
    }
    
    func getTextfieldsInView(view: UIView) -> [UITextField] {
        var results = [UITextField]()
        for subview in view.subviews as [UIView] {
            if let labelView = subview as? UITextField {
                results += [labelView]
            } else {
                results += getTextfieldsInView(view: subview)
            }
        }
        return results
    }
    
    func getTextviewInView(view: UIView) -> [UITextView] {
        var results = [UITextView]()
        for subview in view.subviews as [UIView] {
            if let labelView = subview as? UITextView {
                results += [labelView]
            } else {
                results += getTextviewInView(view: subview)
            }
        }
        return results
    }
        
    func giveRating()  {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            var RateUsCount : Int = 0
            if(Constants.USERDEFAULTS.value(forKey: "isRate") != nil){
                RateUsCount = Constants.USERDEFAULTS.value(forKey: "isRate") as! Int
                RateUsCount += 1
                Constants.USERDEFAULTS.set(RateUsCount, forKey: "isRate")
            } else {
                Constants.USERDEFAULTS.set(RateUsCount, forKey: "isRate")
            }
            if(RateUsCount > 3){
                Constants.USERDEFAULTS.removeObject(forKey: "isRate")
                SKStoreReviewController.requestReview()
            }
        }
    }
    
    func showToast(context ctx: UIViewController, msg: String) {
        
        var toast = UILabel()
        if UIDevice.current.userInterfaceIdiom == .pad {
            toast = UILabel(frame:
                                CGRect(x:  ctx.view.frame.size.width / 2 - 150, y: ctx.view.bounds.height - 225,
                                       width: 300, height: 75))
        } else {
            toast = UILabel(frame:
                                CGRect(x:  ctx.view.frame.size.width / 2 - 100, y: ctx.view.bounds.height - 150,
                                       width: 200, height: 50))
        }
        toast.backgroundColor = UIColor.black
        toast.textColor = UIColor.white
        toast.textAlignment = .center
        toast.numberOfLines = 1
        toast.font = UIFont.systemFont(ofSize: IpadorIphone(value: 20))
        toast.layer.cornerRadius = 12
        toast.clipsToBounds  =  true
        toast.text = msg
        ctx.view.addSubview(toast)
        
        UIView.animate(withDuration: 0.5, delay: 0.5,
                       options: .curveEaseOut, animations: {
            toast.alpha = 0.5
        }, completion: {(isCompleted) in
            toast.removeFromSuperview()
        })
    }
    
    func fileSize(fileSize: Double) -> String {
        let byteSize = Int64(fileSize)
        
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = [.useBytes, .useKB, .useMB, .useGB]
        formatter.countStyle = .file
        var sizeString = formatter.string(fromByteCount: byteSize)
        
        if byteSize == 0 {
            sizeString = "0 B"
        }
        
        return sizeString
    }
    
    func getImageFromDocumentDirectory(fileName: String) -> UIImage? {
        let fileURL = documentsUrl().appendingPathComponent(fileName)
        return UIImage(contentsOfFile: fileURL.path)
    }
    
    func documentsUrl() -> URL {
        let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentsUrl
    }

   

    func resizeImage(image: UIImage, targetMP: CGFloat) -> UIImage? {
        let scale = targetMP / image.size.width
        let newHeight = image.size.height * scale
        let newWidth = image.size.width * scale
        let newSize = CGSize(width: newWidth, height: newHeight)

        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: CGRect(origin: CGPoint(x: 0, y: 0), size: newSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage
    }
    
    func requestImageData(for image: UIImage, completion: @escaping (Data?) -> Void) {
        autoreleasepool {
            guard let cgImage = image.cgImage else {
                completion(nil) // Unable to get CGImage from UIImage
                return
            }
            
            let data = NSMutableData()
            guard let destination = CGImageDestinationCreateWithData(data as CFMutableData, kUTTypeJPEG, 1, nil) else {
                completion(nil) // Failed to create CGImageDestination
                return
            }
            
            let options: [CFString: Any] = [
                kCGImageDestinationLossyCompressionQuality: 0.5
            ]
            
            CGImageDestinationAddImage(destination, cgImage, options as CFDictionary)
            
            if CGImageDestinationFinalize(destination) {
                completion(data as Data)
            } else {
                completion(nil) 
            }
        }
    }

    func deleteFile(fileNameToDelete: String)  {
        var filePath = ""
        
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentDirectory = paths[0]
        filePath = "\(documentDirectory)/\(fileNameToDelete)"
        do {
            let fileManager = FileManager.default
            
            if fileManager.fileExists(atPath: filePath) {
                try fileManager.removeItem(atPath: filePath)
            } else {
                print("File does not exist")
            }
        }
        catch let error as NSError {
            print("An error took place: \(error)")
        }
    }
    
    
    func createMaskImage(from image: UIImage) -> UIImage? {
          guard let cgImage = image.cgImage else {
              return nil
          }
          
          let colorSpace = CGColorSpaceCreateDeviceGray()
          let bitmapInfo = CGImageAlphaInfo.none.rawValue
          
          // Create a bitmap context with the size of the image
          if let context = CGContext(data: nil,
                                     width: cgImage.width,
                                     height: cgImage.height,
                                     bitsPerComponent: 8,
                                     bytesPerRow: 0,
                                     space: colorSpace,
                                     bitmapInfo: bitmapInfo) {
              
              // Draw the image on the context, converting it to grayscale
              context.draw(cgImage, in: CGRect(x: 0, y: 0, width: cgImage.width, height: cgImage.height))
              
              // Create a CGImage from the context
              if let maskImage = context.makeImage() {
                  // Create a UIImage from the CGImage
                  let maskedUIImage = UIImage(cgImage: maskImage)
                  return maskedUIImage
              }
          }
          
          return nil
      }
    
    func applyMaskToImage(originalImage: UIImage, maskImage: UIImage) -> UIImage? {
           autoreleasepool {
               guard let originalCGImage = originalImage.cgImage,
                     let maskCGImage = maskImage.cgImage else {
                   return nil
               }
               
               let imageSize = CGSize(width: originalCGImage.width, height: originalCGImage.height)
               
               guard let bitmapContext = CGContext(data: nil,
                                                   width: Int(imageSize.width),
                                                   height: Int(imageSize.height),
                                                   bitsPerComponent: 8,
                                                   bytesPerRow: 0,
                                                   space: CGColorSpaceCreateDeviceRGB(),
                                                   bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue) else {
                   return nil
               }
               
               bitmapContext.clip(to: CGRect(origin: .zero, size: imageSize), mask: maskCGImage)
               bitmapContext.draw(originalCGImage, in: CGRect(origin: .zero, size: imageSize))
               
               guard let finalCGImage = bitmapContext.makeImage() else {
                   return nil
               }
               
               let finalUIImage = UIImage(cgImage: finalCGImage)
               
               // Convert the UIImage to PNG representation
               guard let pngData = finalUIImage.pngData() else {
                   return nil
               }
               
               // Create a new UIImage from the PNG data
               guard let pngImage = UIImage(data: pngData) else {
                   return nil
               }
               
               return pngImage
           }
       }

    
    func imageFromBase64(_ base64: String) -> UIImage? {
        if let url = URL(string: base64), let data = try? Data(contentsOf: url) {
            return UIImage(data: data)
        }
        return nil
    }
    func resizeImage(image: UIImage) -> UIImage {
           
           var actualHeight = Float(image.size.height)
           var actualWidth = Float(image.size.width)
           let maxHeight: Float = 800.0
           let maxWidth: Float = 800.0
           var imgRatio: Float = actualWidth / actualHeight
           let maxRatio: Float = maxWidth / maxHeight
           let compressionQuality: Float = 1.0
           //50 percent compression
           if actualHeight > maxHeight || actualWidth > maxWidth {
               if imgRatio < maxRatio {
                   //adjust width according to maxHeight
                   imgRatio = maxHeight / actualHeight
                   actualWidth = imgRatio * actualWidth
                   actualHeight = maxHeight
               }
               else if imgRatio > maxRatio {
                   //adjust height according to maxWidth
                   imgRatio = maxWidth / actualWidth
                   actualHeight = imgRatio * actualHeight
                   actualWidth = maxWidth
               }
               else {
                   actualHeight = maxHeight
                   actualWidth = maxWidth
               }
           }
           
           let rect = CGRect(x: 0.0, y: 0.0, width: CGFloat(actualWidth), height: CGFloat(actualHeight))
           UIGraphicsBeginImageContext(rect.size)
           image.draw(in: rect)
           let img = UIGraphicsGetImageFromCurrentImageContext()
           let imageData = img!.jpegData(compressionQuality: CGFloat(compressionQuality))
           UIGraphicsEndImageContext()
           return UIImage(data: imageData!) ?? UIImage()
       }
}


// Define a class to parse the RSS feed
class RSSParser: NSObject, XMLParserDelegate {
    var currentElement = ""
    var currentTitle = ""
    var currentLink = ""
    var currentDescription = ""
    var currentPubDate = ""
    var currentCreator: String?
    var currentGUID = ""
    
    func parse(data: Data) {
        let parser = XMLParser(data: data)
        parser.delegate = self
        parser.parse()
    }
    
    // XMLParserDelegate methods
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentElement = elementName
        if elementName == "item" {
            currentTitle = ""
            currentLink = ""
            currentDescription = ""
            currentPubDate = ""
            currentCreator = nil
            currentGUID = ""
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        switch currentElement {
        case "title":
            currentTitle += string
        case "link":
            currentLink += string
        case "description":
            currentDescription += string
        case "pubDate":
            currentPubDate += string
        case "dc:creator":
            if currentCreator == nil {
                currentCreator = string
            } else {
                currentCreator! += string
            }
        case "guid":
            currentGUID += string
        default:
            break
        }
    }
}
