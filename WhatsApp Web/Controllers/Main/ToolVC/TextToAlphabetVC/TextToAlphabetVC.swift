//
//  TextToAlphabetVC.swift
//  WhatsApp Web
//
//  Created by mac on 07/06/24.
//

import UIKit
import SkeletonView

class TextToAlphabetVC: UIViewController {
    
    // MARK: - @IBOutlet
    @IBOutlet weak var vw_enterTextBg: UIView!
    @IBOutlet weak var vw_nativeAd: UIView!
    @IBOutlet weak var vw_outputBg: UIView!
    
    @IBOutlet weak var txtView_enterText: UITextView!
    @IBOutlet weak var txtView_output: UITextView!
    
    @IBOutlet var btns_alphabet: [UIButton]!
    @IBOutlet var btn_bottom: [UIButton]!
    @IBOutlet var imgVw_bottom: [UIImageView]!
    
    @IBOutlet weak var const_vwNativeAdTop: NSLayoutConstraint!
    @IBOutlet weak var const_vwNativeAdHeight: NSLayoutConstraint!
    
    // MARK: - Variable
    var originalTextTxtView = ""
    let nativeAdManager = NativeAdManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
    
    // MARK: - @IBAction
    @IBAction func btn_alphabetTapped(_ sender: UIButton) {
        hideKeyboard()
        AdMob.sharedInstance()?.loadInste(self)

        switch sender.tag {
        case 0:
//            if Constants.USERDEFAULTS.value(forKey: "isPremium") == nil {
//                presentPremiumPopUp() {
//                    self.textToAlphabet()
//                }
//            } else {
            textToAlphabet()
//            }
        case 1:
//            if Constants.USERDEFAULTS.value(forKey: "isPremium") == nil {
//                presentPremiumPopUp() { [self] in
//                    textReverse(originalText: txtView_enterText.text)
//                }
//            } else {
            textReverse(originalText: txtView_enterText.text)
//            }
        case 2:
//            if Constants.USERDEFAULTS.value(forKey: "isPremium") == nil {
//                presentPremiumPopUp() { [self] in
//                    textFlip(originalText: txtView_enterText.text)
//                }
//            } else {
            textFlip(originalText: txtView_enterText.text)
//            }
        default:
            break
        }
    }
    
    @IBAction func btn_bottomTapped(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            txtView_output.text = ""
            txtView_enterText.text = ""
            originalTextTxtView = ""
            
            btns_alphabet.forEach { $0.isEnabled = false }
            btns_alphabet.forEach { $0.alpha = 0.5 }
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

// MARK: - Private Methods
extension TextToAlphabetVC {
    
    func setUpUI() {
        navigationItem.title = "Text To Alphabet"
        navigationItem.largeTitleDisplayMode = .never
        
        vw_outputBg.layer.cornerRadius = IpadorIphone(value: 8)
        vw_nativeAd.layer.cornerRadius = IpadorIphone(value: 8)
        vw_enterTextBg.layer.cornerRadius = IpadorIphone(value: 8)
        
        txtView_enterText.delegate = self
        
        btns_alphabet.forEach { $0.isEnabled = false }
        btns_alphabet.forEach { $0.alpha = 0.5 }
        btns_alphabet.forEach { $0.layer.cornerRadius = IpadorIphone(value: 23) }
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
    }
    
    func textToAlphabet() {
        let characterMapping: [Character: String] = [
            "a": "@", "b": "฿", "c": "©", "d": "|)", "e": "€", "f": "ⓕ", "g": "₲",
            "h": "]-[", "i": "𝕚", "j": "𝕛", "k": "|<", "l": "Ⱡ", "m": "|\\/|",
            "n": "|\\|", "o": "O", "p": "₱", "q": "ⓠ", "r": "Ⓡ", "s": "$",
            "t": "₮", "u": "Ʉ", "v": "ⓥ", "w": "|/\\|", "x": "Ӿ", "y": "¥",
            "z": "Ⱬ", "A": "@", "B": "฿", "C": "©", "D": "|)", "E": "€", "F": "ⓕ", "G": "₲",
            "H": "]-[", "I": "𝕚", "J": "𝕛", "K": "|<", "L": "Ⱡ", "M": "|\\/|",
            "N": "|\\|", "O": "O", "P": "₱", "Q": "ⓠ", "R": "Ⓡ", "S": "$",
            "T": "₮", "U": "Ʉ", "V": "ⓥ", "W": "|/\\|", "X": "Ӿ", "Y": "¥",
            "Z": "Ⱬ", "0": "⓪", "1": "①", "2": "②", "3": "③", "4": "④", "5": "⑤",
            "6": "⑥", "7": "⑦", "8": "⑧", "9": "⑨"
        ]
        
        txtView_output.text = txtView_enterText.text?.map { characterMapping[$0] ?? String($0) }.joined()
        
        if txtView_output.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            imgVw_bottom.forEach { $0.tintColor = UIColor(hex: "#8E8E93") }
            btn_bottom.forEach { $0.isEnabled = false }
        } else {
            imgVw_bottom.forEach { $0.tintColor = UIColor(named: "6CCD1C") }
            btn_bottom.forEach { $0.isEnabled = true }
        }
    }
    
    func textReverse(originalText: String) {
        var multipliedText = ""
        multipliedText = String(originalText.reversed())
        txtView_output.text = multipliedText
        
        if txtView_output.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            imgVw_bottom.forEach { $0.tintColor = UIColor(hex: "#8E8E93") }
            btn_bottom.forEach { $0.isEnabled = false }
        } else {
            imgVw_bottom.forEach { $0.tintColor = UIColor(named: "6CCD1C") }
            btn_bottom.forEach { $0.isEnabled = true }
        }
    }
    
    func textFlip(originalText: String) {
        let characterMapping: [Character: String] = [
            "a": "ɐ", "b": "p", "c": "c", "d": "q", "e": "ǝ", "f": "ɟ", "g": "ɓ",
            "h": "ɥ", "i": "ᴉ", "j": "ꓩ", "k": "ʞ", "l": "l", "m": "ɯ",
            "n": "u", "o": "o", "p": "b", "q": "d", "r": "ɹ", "s": "ƨ",
            "t": "ʇ", "u": "n", "v": "ʌ", "w": "ʍ", "x": "x", "y": "ʎ",
            "z": "z", "A": "Ɐ", "B": "B", "C": "C", "D": "D", "E": "E", "F": "ᖶ", "G": "ꓨ",
            "H": "H", "I": "I", "J": "ᒉ", "K": "K", "L": "Γ", "M": "W",
            "N": "И", "O": "O", "P": "b", "Q": "Ὸ", "R": "ꓤ", "S": "Ƨ",
            "T": "ꓕ", "U": "ꓵ", "V": "Λ", "W": "M", "X": "X", "Y": "⅄",
            "Z": "Z", "0": "0", "1": "⇂", "2": "ᘕ", "3": "3", "4": "߈",
            "5": "ဌ","6": "9", "7": "𝘓", "8": "8", "9": "6"
        ]
        
        txtView_output.text = originalText.map { characterMapping[$0] ?? String($0) }.joined()
        
        if txtView_output.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            imgVw_bottom.forEach { $0.tintColor = UIColor(hex: "#8E8E93") }
            btn_bottom.forEach { $0.isEnabled = false }
        } else {
            imgVw_bottom.forEach { $0.tintColor = UIColor(named: "6CCD1C") }
            btn_bottom.forEach { $0.isEnabled = true }
        }
    }
    
    func presentPremiumPopUp(completion: @escaping () -> Void) {
        if txtView_enterText.text != originalTextTxtView {
            if let premiumPopUpVc = storyboard?.instantiateViewController(withIdentifier: "PremiumPopUpVC") as? PremiumPopUpVC {
                let nav = UINavigationController(rootViewController: premiumPopUpVc)
                nav.modalPresentationStyle = .custom
                
                premiumPopUpVc.isTitle = "Text To Alphabet"
                premiumPopUpVc.complitionHandler = {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [self] in
                        originalTextTxtView = txtView_enterText.text!
                        self.dismiss(animated: false, completion: completion)
                    }
                }
                self.present(nav, animated: false)
            }
        } else {
            self.dismiss(animated: false, completion: completion)
        }
    }
}

// MARK: - TextView Delegate
extension TextToAlphabetVC: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        
        if newText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            btns_alphabet.forEach { $0.isEnabled = false }
            btns_alphabet.forEach { $0.alpha = 0.5 }
        } else {
            btns_alphabet.forEach { $0.isEnabled = true }
            btns_alphabet.forEach { $0.alpha = 1 }
        }
        
        return true
    }
}
