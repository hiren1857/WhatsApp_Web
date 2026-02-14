//
//  TextRepeaterVC.swift
//  WhatsApp Web
//
//  Created by mac on 07/06/24.
//

import UIKit
import SkeletonView

class TextRepeaterVC: UIViewController {
    
    //MARK: - @IBOutlets
    @IBOutlet weak var vw_enterTextBg: UIView!
    @IBOutlet weak var vw_nativeAd: UIView!
    @IBOutlet weak var vw_outputBg: UIView!
    
    @IBOutlet weak var txtView_enterText: UITextView!
    @IBOutlet weak var txtView_output: UITextView!
    
    @IBOutlet weak var txtField_repeatCount: NoPasteTextField!
    
    @IBOutlet weak var switch_addLine: UISwitch!
    
    @IBOutlet weak var btn_repeat: LoadingButton!
    
    @IBOutlet var btn_bottom: [UIButton]!
    @IBOutlet var imgVw_bottom: [UIImageView]!
    
    @IBOutlet weak var const_vwNativeAdTop: NSLayoutConstraint!
    @IBOutlet weak var const_vwNativeAdHeight: NSLayoutConstraint!
    
    //MARK: - Variables
    var originalTextTxtField = ""
    var originalTextTxtView = ""
    var addLine = true
    let nativeAdManager = NativeAdManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
    
    //MARK: - @IBActions
    @IBAction func switch_tapped(_ sender: UISwitch) {
        if switch_addLine.isOn {
            addLine = true
        } else {
            addLine = false
        }
    }
    
    @IBAction func btn_repeatTapped(_ sender: UIButton) {
        hideKeyboard()
        
        if txtField_repeatCount.text! .isEmpty {
            showAlert(message: "Please Enter Repeat Counter..")
        }
        
        guard let text = txtField_repeatCount.text, let number = Int(text) else {
            showAlert(message: "Please enter only numbers in Repeat counter..")
            return
        }
        
        if number > 1000 {
            showAlert(message: "Repeat counter number should not be more than 1000.")
        }
        
//        if Constants.USERDEFAULTS.value(forKey: "isPremium") == nil {
//            if txtField_repeatCount.text != originalTextTxtField || txtView_enterText.text != originalTextTxtView {
//                if let premiumPopUpVc = storyboard?.instantiateViewController(withIdentifier: "PremiumPopUpVC") as? PremiumPopUpVC {
//                    let nav = UINavigationController(rootViewController: premiumPopUpVc)
//                    nav.modalPresentationStyle = .custom
//                    
//                    premiumPopUpVc.isTitle = "Text Repeater"
//                    premiumPopUpVc.complitionHandler = {
//                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [self] in
//                            originalTextTxtField = txtField_repeatCount.text!
//                            originalTextTxtView = txtView_enterText.text!
//                            dismiss(animated: false) { [self] in
//                                let count = Int(txtField_repeatCount.text!)
//                                textRepeat(originalText: txtView_enterText.text, count: count ?? 0)
//                            }
//                        }
//                    }
//                    self.present(nav, animated: false)
//                }
//            } else {
//                let count = Int(txtField_repeatCount.text!)
//                textRepeat(originalText: txtView_enterText.text, count: count ?? 0)
//            }
//        } else {
            AdMob.sharedInstance()?.loadInste(self)
            let count = Int(txtField_repeatCount.text!)
            textRepeat(originalText: txtView_enterText.text, count: count ?? 0)
//        }
    }
    
    @IBAction func btn_bottomTapped(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            txtView_output.text = ""
            txtView_enterText.text = ""
            txtField_repeatCount.text = ""
            originalTextTxtField = ""
            originalTextTxtView = ""
            btn_repeat.isEnabled = false
            btn_repeat.alpha = 0.5
            
            imgVw_bottom.forEach { $0.tintColor = UIColor(hex: "#8E8E93") }
            btn_bottom.forEach { $0.isEnabled = false }
            
        case 1:
            UIPasteboard.general.string = txtView_output.text
            Utils().showToast(context: self, msg: "Copied!")
            
        case 2:
            let txt = txtView_output.text
            let activityController = UIActivityViewController(activityItems: [txt! as String], applicationActivities: nil)
            activityController.popoverPresentationController?.sourceView = view
            activityController.popoverPresentationController?.sourceRect = view.frame
            
            if let popoverController = activityController.popoverPresentationController {
                popoverController.sourceView = self.view
                popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
                popoverController.permittedArrowDirections = []
            }
            self.present(activityController, animated: true, completion: nil)
            
        default :
            break
        }
    }
}

//MARK: - Private Methods
extension TextRepeaterVC {
    
    func setUpUI() {
        navigationItem.title = "Text Repeater"
        navigationItem.largeTitleDisplayMode = .never
        
        vw_enterTextBg.layer.cornerRadius = IpadorIphone(value: 8)
        vw_outputBg.layer.cornerRadius = IpadorIphone(value: 8)
        txtField_repeatCount.layer.cornerRadius = IpadorIphone(value: 8)
        vw_nativeAd.layer.cornerRadius = IpadorIphone(value: 8)
        btn_repeat.layer.cornerRadius = IpadorIphone(value: 25)
        
        txtField_repeatCount.delegate = self
        txtView_enterText.delegate = self
        
        switch_addLine.isOn = true
        
        btn_repeat.isEnabled = false
        btn_repeat.alpha = 0.5
        
        btn_bottom.forEach { $0.isEnabled = false }
        
        if Constants.USERDEFAULTS.value(forKey: "isPremium") == nil {
            const_vwNativeAdHeight.constant = IpadorIphone(value: 135)
            const_vwNativeAdTop.constant = IpadorIphone(value: 16)
            self.nativeAdManager.setupNativeAd(in: self, placeholderView: self.vw_nativeAd)
            vw_nativeAd.isHidden = false
        } else {
            const_vwNativeAdHeight.constant = 0
            const_vwNativeAdTop.constant = 0
            vw_nativeAd.isHidden = true
        }
        
        // left padding for UITextField’s placeholder
        let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: IpadorIphone(value: 12), height: txtField_repeatCount.frame.height))
        txtField_repeatCount.leftView = leftPaddingView
        txtField_repeatCount.leftViewMode = .always
    }
    
    func textRepeat(originalText: String,count: Int) {
        btn_repeat.startLoading()
        var multipliedText = ""
        
        if addLine {
            multipliedText = Array(repeating: originalText, count: count).joined(separator: "\n")
        } else {
            multipliedText = Array(repeating: originalText, count: count).joined(separator: " ")
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) { [self] in
            txtView_output.text = multipliedText
            btn_repeat.stopLoading()
            
            if txtView_output.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                imgVw_bottom.forEach { $0.tintColor = UIColor(hex: "#8E8E93") }
                btn_bottom.forEach { $0.isEnabled = false }
            } else {
                imgVw_bottom.forEach { $0.tintColor = UIColor(named: "6CCD1C") }
                btn_bottom.forEach { $0.isEnabled = true }
            }
        }
    }
}

// MARK: - TextField & TextView Delegate
extension TextRepeaterVC: UITextFieldDelegate, UITextViewDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        
        guard let oldText = textField.text, let r = Range(range, in: oldText) else {
            return true
        }
        
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: string)
        
        let allowedCharacterSet = CharacterSet(charactersIn: "1234567890")
        
        if string.isEmpty {
            if !updatedText.isEmpty && !txtView_enterText.text.isEmpty {
                btn_repeat.alpha = 1
                btn_repeat.isEnabled = true
            } else {
                btn_repeat.alpha = 0.5
                btn_repeat.isEnabled = false
            }
            return true // Allow erase operation
        }
        
        let replacementCharacterSet = CharacterSet(charactersIn: string)
        if !allowedCharacterSet.isSuperset(of: replacementCharacterSet) {
            return false
        }
        
        let substringToReplace = oldText[r]
        let count = oldText.count - substringToReplace.count + string.count
        let isNumeric = updatedText.isEmpty || (Double(updatedText) != nil)
        let numberOfDots = updatedText.components(separatedBy: ".").count - 1
        
        let numberOfDecimalDigits: Int
        if let dotIndex = updatedText.firstIndex(of: ".") {
            numberOfDecimalDigits = updatedText.distance(from: dotIndex, to: updatedText.endIndex) - 1
        } else {
            numberOfDecimalDigits = 0
        }
        
        if updatedText == "00" {
            return false
        }
        
        if !updatedText.isEmpty && !txtView_enterText.text.isEmpty {
            btn_repeat.alpha = 1
            btn_repeat.isEnabled = true
        } else {
            btn_repeat.alpha = 0.5
            btn_repeat.isEnabled = false
        }
        
        
        if textField == self.txtField_repeatCount {
            let nwtxt = Double(updatedText) ?? 0
            if nwtxt <= 0 && updatedText == "0" {
                btn_repeat.isEnabled = false
                btn_repeat.alpha = 0.5
            }
            
            if nwtxt > 1000 || nwtxt <= 0  {
                return isNumeric && numberOfDots <= 0 && numberOfDecimalDigits <= 0 && count <= 3
            } else {
                return isNumeric && numberOfDots <= 0 && numberOfDecimalDigits <= 0 && count <= 4
            }
        }
        return true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let exerciseName = txtField_repeatCount.text ?? ""
        
        if textView.text == "" {
            if (text == " ") {
                return false
            }
        }
        
        if newText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || exerciseName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            btn_repeat.alpha = 0.5
            btn_repeat.isEnabled = false
        } else {
            btn_repeat.alpha = 1.0
            btn_repeat.isEnabled = true
        }
        
        return true
    }
}

