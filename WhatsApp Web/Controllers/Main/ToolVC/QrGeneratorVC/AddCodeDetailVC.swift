//
//  AddCodeDetailVC.swift
//  WhatsApp Web
//
//  Created by mac on 11/06/24.
//

import UIKit
import SkeletonView

class AddCodeDetailVC: UIViewController {
    
    // MARK: - @IBOutlet
    @IBOutlet weak var vw_enterSMSBg: UIView!
    @IBOutlet weak var vw_nativeAd: UIView!
    
    @IBOutlet weak var lbl_enterSMS: UILabel!
    @IBOutlet weak var lbl_enterTitle: UILabel!
    
    @IBOutlet weak var btn_paste: UIButton!
    
    @IBOutlet weak var txtField_enterText: UITextField!
    
    @IBOutlet weak var txtView_enterSMS: UITextView!
    
    @IBOutlet weak var const_vwNativeAdHeight: NSLayoutConstraint!
    
    // MARK: - Variable
    var isEnterTitle = ""
    var isFromTitle = ""
    var btn_create: UIBarButtonItem?
    let nativeAdManager = NativeAdManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        txtField_enterText.becomeFirstResponder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !txtField_enterText.text!.isEmpty {
            btn_create?.tintColor = .link
        }
    }
    
    // MARK: - @IBAction
    @IBAction func btn_pasteTapped(_ sender: UIButton) {
        if let copiedText = UIPasteboard.general.string {
            if isEnterTitle == "Enter Phone Number:" {
                let regex = try! NSRegularExpression(pattern: "[\\d,]+", options: [])

                let matches = regex.matches(in: copiedText, options: [], range: NSRange(location: 0, length: copiedText.utf16.count))

                if let match = matches.first, let range = Range(match.range, in: copiedText) {
                    let numericPart = String(copiedText[range])
                    txtField_enterText.text = numericPart
                } else {
                    txtField_enterText.text = ""
                    btn_create?.isEnabled = false
                }
            } else {
                txtField_enterText.text = copiedText
            }

            if !txtField_enterText.text!.isEmpty {
                btn_create?.isEnabled = true
            }
        }
    }
}

// MARK: - Private Methods
extension AddCodeDetailVC {
    
    func setUpUI() {
        navigationItem.title = isFromTitle
        
        btn_create = UIBarButtonItem(title: "Create", style: .done, target: self, action: #selector(btn_createTap))
        btn_create!.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18)], for: .normal)
        btn_create?.tintColor = UIColor(named: "6CCD1C")
        navigationItem.rightBarButtonItem = btn_create
        btn_create?.isEnabled = false
        
        vw_enterSMSBg.layer.cornerRadius = IpadorIphone(value: 8)
        txtField_enterText.layer.cornerRadius = IpadorIphone(value: 8)
        
        txtField_enterText.delegate = self
        
        lbl_enterTitle.text = isEnterTitle
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideKeyboard)))
        
        if isFromTitle == "Phone Number" {
            txtField_enterText.keyboardType = .phonePad
        } else if isFromTitle == "Barcode" {
            txtField_enterText.keyboardType = .alphabet
        } else if isFromTitle == "SMS" {
            lbl_enterSMS.isHidden = false
            vw_enterSMSBg.isHidden = false
            txtField_enterText.keyboardType = .phonePad
            txtView_enterSMS.keyboardType = .default
        } else if isEnterTitle == "Enter URL:" || isEnterTitle == "Enter App URL:" || isEnterTitle == "Enter Instagram Post URL:" || isEnterTitle == "Enter Facebook Profile URL:" || isEnterTitle == "Enter Facebook Post URL:" || isEnterTitle == "Enter Twitter Profile URL:" || isEnterTitle == "Enter Twitter Post URL:" {
            txtField_enterText.text = "https://"
        } else {
            txtField_enterText.keyboardType = .default
        }
        
        if Constants.USERDEFAULTS.value(forKey: "isPremium") == nil {
            self.nativeAdManager.setupNativeAd(in: self, placeholderView: self.vw_nativeAd)
            vw_nativeAd.isHidden = false
            const_vwNativeAdHeight.constant = IpadorIphone(value: 135)
        } else {
            vw_nativeAd.isHidden = true
            const_vwNativeAdHeight.constant = 0
        }
        
        // left padding for UITextField’s placeholder
        let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: IpadorIphone(value: 12), height: txtField_enterText.frame.height))
        txtField_enterText.leftView = leftPaddingView
        txtField_enterText.leftViewMode = .always
    }
    
    @objc func btn_createTap() {
        guard let text = txtField_enterText.text, !text.isEmpty else {
            return
        }
        
        switch isFromTitle {
        case "Barcode":
            if txtField_enterText.text!.containsEmoji {
                showAlert(message: "Please enter a valid Product ID.")
            }
            navigateToCreateCodeVC(with: txtField_enterText.text ?? "", isFrom: isFromTitle, isBarcode: true)
            break
            
        case "URL":
            navigateToCreateCodeVC(with: text, isFrom: isFromTitle, isBarcode: false)
            break
            
        case "Phone Number":
            let telString = "tel:\(text)"
            navigateToCreateCodeVC(with: telString, isFrom: isFromTitle, isBarcode: false)
            break
            
        case "SMS":
            guard let smsText = txtView_enterSMS.text, !smsText.isEmpty else {
                showAlert(message: "Please enter SMS text.")
                return
            }
            
            let phoneNumber = "\(text)"
            let smsString = "smsto:\(phoneNumber):\(smsText)"
            navigateToCreateCodeVC(with: smsString, isFrom: isFromTitle, isBarcode: false)
            break
            
        case "Email":
            if isValidEmail(text) {
                navigateToCreateCodeVC(with: "mailto:\(text)", isFrom: isFromTitle, isBarcode: false)
            } else {
                showAlert(message: "Please enter a valid email address.")
            }
            break
            
        case "Instagram Profile":
            let instagramProfileURL = "https://instagram.com/\(text)"
            navigateToCreateCodeVC(with: instagramProfileURL, isFrom: isFromTitle, isBarcode: false)
            break
            
        case "Instagram Post":
            if text.hasPrefix("https://") {
                navigateToCreateCodeVC(with: text, isFrom: isFromTitle, isBarcode: false)
            } else {
                showAlert(message: "Please enter a valid Instagram post URL.")
            }
            break
            
        case "Facebook Profile":
            if text.hasPrefix("https://www.facebook.com/") {
                navigateToCreateCodeVC(with: text, isFrom: isFromTitle, isBarcode: false)
            } else {
                showAlert(message: "Please enter a valid Facebook profile URL.")
            }
            break
            
        case "Facebook Post":
            if text.hasPrefix("https://") {
                navigateToCreateCodeVC(with: text, isFrom: isFromTitle, isBarcode: false)
            } else {
                showAlert(message: "Please enter a valid Facebook post URL.")
            }
            break
            
        case "Twitter Profile":
            if text.hasPrefix("https://twitter.com/") || text.hasPrefix("https://x.com/") {
                navigateToCreateCodeVC(with: text, isFrom: isFromTitle, isBarcode: false)
            } else {
                showAlert(message: "Please enter a valid Twitter profile URL.")
            }
            break
            
        case "Twitter Post":
            if text.hasPrefix("https://twitter.com/") || text.hasPrefix("https://x.com/") {
                navigateToCreateCodeVC(with: text, isFrom: isFromTitle, isBarcode: false)
            } else {
                showAlert(message: "Please enter a valid Twitter post URL.")
            }
            break
            
        case "App store":
            if text.hasPrefix("https://apps.apple.com") {
                navigateToCreateCodeVC(with: text, isFrom: isFromTitle, isBarcode: false)
            } else {
                showAlert(message: "Please enter a valid App URL.")
            }
            break
            
        default:
            showAlert(message: "Unknown option selected.")
        }
    }
    
    func navigateToCreateCodeVC(with qrDetails: String, isFrom: String, isBarcode: Bool) {
        if let createCodeVc = storyboard?.instantiateViewController(withIdentifier: "CreateCodeVC") as? CreateCodeVC {
            createCodeVc.isGenerate_QRDetails = qrDetails
            createCodeVc.isBarcode = isBarcode
            createCodeVc.codeTypeName = isFrom
            navigationController?.pushViewController(createCodeVc, animated: true)
        }
    }
    
    func isValidEmail(_ email: String?) -> Bool {
        guard let email = email else { return false }
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
}

// MARK: - TextField Delegate
extension AddCodeDetailVC: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: string)
        
        if isEnterTitle == "Enter Phone Number:" {
            let allowedCharacterSet = CharacterSet(charactersIn: "1234567890+*#")

            if string.isEmpty {
                if !updatedText.isEmpty {
                    btn_create?.isEnabled = true
                } else {
                    btn_create?.isEnabled = false
                }
                return true // Allow erase operation
            }

            let replacementCharacterSet = CharacterSet(charactersIn: string)
            if !allowedCharacterSet.isSuperset(of: replacementCharacterSet) {
                return false
            }
        } else if isFromTitle == "Barcode" {
            let allowedCharacterSet = CharacterSet(charactersIn: "¥€£•")

            if string.isEmpty {
                if !updatedText.isEmpty {
                    btn_create?.isEnabled = true
                } else {
                    btn_create?.isEnabled = false
                }
                return true // Allow erase operation
            }

            let replacementCharacterSet = CharacterSet(charactersIn: string)
            if allowedCharacterSet.isSuperset(of: replacementCharacterSet) {
                return false
            }
        }
        
        if !updatedText.isEmpty {
            btn_create?.isEnabled = true
        } else {
            btn_create?.isEnabled = false
        }
        
        return true
    }
}
