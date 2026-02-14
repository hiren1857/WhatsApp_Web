//
//  TextToEmojiVC.swift
//  WhatsApp Web
//
//  Created by mac on 10/06/24.
//

import UIKit
import SkeletonView

class TextToEmojiVC: UIViewController {
    
    //MARK: - @IBOutlets
    @IBOutlet weak var vw_enterTextBg: UIView!
    @IBOutlet weak var vw_nativeAd: UIView!
    @IBOutlet weak var vw_outputBg: UIView!
    
    @IBOutlet weak var txtView_enterText: NoPasteTextView!
    @IBOutlet weak var txtView_output: UITextView!
    
    @IBOutlet weak var txtField_enterEmoji: EmojiTextField!
    
    @IBOutlet weak var btn_generate: UIButton!
    @IBOutlet var btn_bottom: [UIButton]!
    
    @IBOutlet var imgVw_bottom: [UIImageView]!
    
    @IBOutlet weak var const_vwNativeAdTop: NSLayoutConstraint!
    @IBOutlet weak var const_vwNativeAdHeight: NSLayoutConstraint!
    
    //MARK: - Variables
    var arr_emojis: [String] = []
    
    var combinedPattern = ""
    var originalTextTxtField = ""
    var originalTextTxtView = ""
    private var currentIndex: Int = 0
    let nativeAdManager = NativeAdManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
    
    // MARK: - @IBAction
    @IBAction func btn_generateTapped(_ sender: UIButton) {
        hideKeyboard()
        
        if txtView_enterText.text!.isEmpty {
            let alert = UIAlertController(title: "", message: "Please Enter Text..(A-Z,a-z, and 0-9)", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel))
            present(alert, animated: true)
        } else if txtField_enterEmoji.text!.isEmpty {
            let alert = UIAlertController(title: "", message: "Please Enter Emoji..", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel))
            present(alert, animated: true)
        } else if txtView_enterText.text!.isEmpty && txtField_enterEmoji.text!.isEmpty {
            let alert = UIAlertController(title: "", message: "Please Enter Text And Emoji..", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel))
            present(alert, animated: true)
        }
        
        guard let text = txtField_enterEmoji.text, text.containsEmoji else {
            showAlert(message: "Please Enter Only Emoji.")
            return
        }
        
//        if Constants.USERDEFAULTS.value(forKey: "isPremium") == nil {
//            if txtField_enterEmoji.text != originalTextTxtField || txtView_enterText.text != originalTextTxtView {
//                if let premiumPopUpVc = storyboard?.instantiateViewController(withIdentifier: "PremiumPopUpVC") as? PremiumPopUpVC {
//                    let nav = UINavigationController(rootViewController: premiumPopUpVc)
//                    nav.modalPresentationStyle = .custom
//                    
//                    premiumPopUpVc.isTitle = "Text To Emoji"
//                    premiumPopUpVc.complitionHandler = {
//                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [self] in
//                            originalTextTxtField = txtField_enterEmoji.text!
//                            originalTextTxtView = txtView_enterText.text!
//                            dismiss(animated: false) { [self] in
//                                generateEmoji()
//                            }
//                        }
//                    }
//                    self.present(nav, animated: false)
//                }
//            }
//        } else {
        AdMob.sharedInstance()?.loadInste(self)
            generateEmoji()
//        }
    }
    
    @IBAction func btn_bottomTapped(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            txtView_output.text = ""
            txtView_enterText.text = ""
            txtField_enterEmoji.text = ""
            originalTextTxtField = ""
            originalTextTxtView = ""
            btn_generate.isEnabled = false
            btn_generate.alpha = 0.5
            
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

// MARK: - Private Func
extension TextToEmojiVC {
    
    func setUpUI() {
        navigationItem.title = "Text To Emoji"
        navigationItem.largeTitleDisplayMode = .never
        
        txtView_enterText.delegate = self
        txtField_enterEmoji.delegate = self
        txtView_enterText.autocorrectionType = .no
        
        vw_enterTextBg.layer.cornerRadius = IpadorIphone(value: 8)
        vw_nativeAd.layer.cornerRadius = IpadorIphone(value: 8)
        btn_generate.layer.cornerRadius = IpadorIphone(value: 25)
        vw_outputBg.layer.cornerRadius = IpadorIphone(value: 8)
        txtField_enterEmoji.layer.cornerRadius = IpadorIphone(value: 8)
        
        btn_generate.alpha = 0.5
        btn_generate.isEnabled = false
        btn_bottom.forEach { $0.isEnabled = false }
        imgVw_bottom.forEach { $0.tintColor = UIColor(hex: "#8E8E93") }
        
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
        let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: IpadorIphone(value: 12), height: txtField_enterEmoji.frame.height))
        txtField_enterEmoji.leftView = leftPaddingView
        txtField_enterEmoji.leftViewMode = .always
    }
    
    func generateEmoji() {
        hideKeyboard()
        btn_bottom.forEach { $0.isEnabled = true }
        imgVw_bottom.forEach { $0.tintColor = UIColor(named: "6CCD1C") }
        
        combinedPattern = ""
        let text_to_convert = self.txtView_enterText.text ?? ""
        
        let allowedCharacters = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
        let nameArray = Array(text_to_convert.filter { allowedCharacters.contains($0) })
        
        if let text = txtField_enterEmoji.text {
            arr_emojis = text.filter { isEmoji(character: $0) }.map { String($0) }
        }
        
        for char in nameArray {
            let emoji = getNextEmoji()
            let letterPattern = createLetterPattern(letter: String(char), star: emoji)
            combinedPattern += letterPattern
            combinedPattern += "\n\n\n"
        }
        
        txtView_output.text = combinedPattern
    }
    
    func createLetterPattern(letter: String, star: String) -> String {
        let pattern: [String]
        
        switch letter {
            // Numbers
        case "0":
            pattern = [
                "        \(star)\(star)\(star)\(star)",
                "   \(star)\(star)\(star)\(star)\(star)\(star)",
                "\(star)\(star)                 \(star)\(star)",
                "\(star)\(star)                 \(star)\(star)",
                "\(star)\(star)                 \(star)\(star)",
                "\(star)\(star)                 \(star)\(star)",
                "\(star)\(star)                 \(star)\(star)",
                "\(star)\(star)                 \(star)\(star)",
                "   \(star)\(star)\(star)\(star)\(star)\(star)",
                "        \(star)\(star)\(star)\(star)"
            ]
        case "1":
            pattern = [
                "   \(star)\(star)\(star)\(star)",
                "   \(star)\(star)\(star)\(star)",
                "              \(star)\(star)",
                "              \(star)\(star)",
                "              \(star)\(star)",
                "              \(star)\(star)",
                "              \(star)\(star)",
                "              \(star)\(star)",
                "   \(star)\(star)\(star)\(star)\(star)\(star)",
                "   \(star)\(star)\(star)\(star)\(star)\(star)"
            ]
        case "2":
            pattern = [
                "    \(star)\(star)\(star)\(star)\(star)",
                " \(star)\(star)\(star)\(star)\(star)\(star)",
                "\(star)\(star)          \(star)\(star)",
                "                 \(star)\(star)",
                "              \(star)\(star)",
                "           \(star)\(star)",
                "        \(star)\(star)",
                "     \(star)\(star)",
                "  \(star)\(star)\(star)\(star)\(star)\(star)",
                "  \(star)\(star)\(star)\(star)\(star)\(star)",
            ]
        case "3":
            pattern = [
                "     \(star)\(star)\(star)\(star)",
                "  \(star)\(star)\(star)\(star)\(star)",
                "\(star)\(star)          \(star)\(star)",
                "                    \(star)\(star)",
                "             \(star)\(star)\(star)",
                "             \(star)\(star)\(star)",
                "                    \(star)\(star)",
                "\(star)\(star)          \(star)\(star)",
                "  \(star)\(star)\(star)\(star)\(star)",
                "     \(star)\(star)\(star)\(star)"
                
            ]
        case "4":
            pattern = [
                "                          \(star)\(star)",
                "                     \(star)\(star)\(star)",
                "               \(star)\(star) \(star)\(star)",
                "         \(star)\(star)       \(star)\(star)",
                "     \(star)\(star)           \(star)\(star)",
                "\(star)\(star)                \(star)\(star)",
                "\(star)\(star)\(star)\(star)\(star)\(star)\(star)\(star)\(star)",
                "\(star)\(star)\(star)\(star)\(star)\(star)\(star)\(star)\(star)",
                "                          \(star)\(star)",
                "                          \(star)\(star)"
            ]
        case "5":
            pattern = [
                "\(star)\(star)\(star)\(star)\(star)\(star)",
                "\(star)\(star)\(star)\(star)\(star)\(star)",
                "\(star)\(star)",
                "\(star)\(star)\(star)\(star)\(star)",
                "  \(star)\(star)\(star)\(star)\(star)",
                "                    \(star)\(star)",
                "                     \(star)\(star)",
                "\(star)\(star)          \(star)\(star)",
                "   \(star)\(star)\(star)\(star)\(star)",
                "      \(star)\(star)\(star)\(star)"
            ]
        case "6":
            pattern = [
                "       \(star)\(star)\(star)\(star)\(star)",
                "    \(star)\(star)\(star)\(star)\(star)\(star)",
                "\(star)\(star)",
                "\(star)\(star)",
                "\(star)\(star)\(star)\(star)\(star)\(star)",
                "\(star)\(star)\(star)\(star)\(star)\(star)\(star)",
                "\(star)\(star)                \(star)\(star)",
                "\(star)\(star)                \(star)\(star)",
                "    \(star)\(star)\(star)\(star)\(star)\(star)",
                "       \(star)\(star)\(star)\(star)\(star)"
            ]
        case "7":
            pattern = [
                "\(star)\(star)\(star)\(star)\(star)\(star)",
                "\(star)\(star)\(star)\(star)\(star)\(star)",
                "                   \(star)\(star)",
                "                 \(star)\(star)",
                "               \(star)\(star)",
                "             \(star)\(star)",
                "           \(star)\(star)",
                "         \(star)\(star)",
                "       \(star)\(star)",
                "     \(star)\(star)"
            ]
        case "8":
            pattern = [
                "        \(star)\(star)\(star)\(star)",
                "   \(star)\(star)\(star)\(star)\(star)\(star)",
                "\(star)\(star)                \(star)\(star)",
                "\(star)\(star)                \(star)\(star)",
                "   \(star)\(star)\(star)\(star)\(star)\(star)",
                "   \(star)\(star)\(star)\(star)\(star)\(star)",
                "\(star)\(star)                \(star)\(star)",
                "\(star)\(star)                \(star)\(star)",
                "   \(star)\(star)\(star)\(star)\(star)\(star)",
                "         \(star)\(star)\(star)\(star)",
            ]
        case "9":
            pattern = [
                "      \(star)\(star)\(star)\(star)\(star)",
                "   \(star)\(star)\(star)\(star)\(star)\(star)",
                "\(star)\(star)                \(star)\(star)",
                "\(star)\(star)                \(star)\(star)",
                "\(star)\(star)\(star)\(star)\(star)\(star)\(star)",
                "     \(star)\(star)\(star)\(star)\(star)\(star)",
                "                          \(star)\(star)",
                "                          \(star)\(star)",
                "   \(star)\(star)\(star)\(star)\(star)\(star)",
                "      \(star)\(star)\(star)\(star)\(star)"
            ]
            
            // Capital
        case "A":
            pattern = [
                "                \(star)\(star)\(star)",
                "              \(star)\(star)\(star)\(star)",
                "            \(star)\(star)   \(star)\(star)",
                "          \(star)\(star)       \(star)\(star)",
                "        \(star)\(star)\(star)\(star)\(star)\(star)",
                "      \(star)\(star)\(star)\(star)\(star)\(star)\(star)",
                "    \(star)\(star)                   \(star)\(star)",
                "  \(star)\(star)                       \(star)\(star)",
                "\(star)\(star)                           \(star)\(star)"
            ]
        case "B":
            pattern = [
                "\(star)\(star)\(star)\(star)\(star)\(star)\(star)",
                "\(star)\(star)\(star)\(star)\(star)\(star)\(star)\(star)",
                "\(star)\(star)                       \(star)\(star)",
                "\(star)\(star)                       \(star)\(star)",
                "\(star)\(star)\(star)\(star)\(star)\(star)\(star)\(star)",
                "\(star)\(star)\(star)\(star)\(star)\(star)\(star)\(star)",
                "\(star)\(star)                       \(star)\(star)",
                "\(star)\(star)                       \(star)\(star)",
                "\(star)\(star)\(star)\(star)\(star)\(star)\(star)\(star)",
                "\(star)\(star)\(star)\(star)\(star)\(star)\(star)"
            ]
        case "C":
            pattern = [
                "          \(star)\(star)\(star)\(star)\(star)\(star)",
                "     \(star)\(star)\(star)\(star)\(star)\(star)\(star)\(star)",
                "   \(star)\(star)                         \(star)\(star)",
                " \(star)\(star)",
                "\(star)\(star)",
                "\(star)\(star)",
                " \(star)\(star)",
                "   \(star)\(star)                         \(star)\(star)",
                "     \(star)\(star)\(star)\(star)\(star)\(star)\(star)\(star)",
                "          \(star)\(star)\(star)\(star)\(star)\(star)"
            ]
        case "D":
            pattern = [
                "\(star)\(star)\(star)\(star)\(star)\(star)\(star)",
                "\(star)\(star)\(star)\(star)\(star)\(star)\(star)\(star)",
                "\(star)\(star)                      \(star)\(star)",
                "\(star)\(star)                        \(star)\(star)",
                "\(star)\(star)                         \(star)\(star)",
                "\(star)\(star)                         \(star)\(star)",
                "\(star)\(star)                        \(star)\(star)",
                "\(star)\(star)                      \(star)\(star)",
                "\(star)\(star)\(star)\(star)\(star)\(star)\(star)\(star)",
                "\(star)\(star)\(star)\(star)\(star)\(star)\(star)"
            ]
        case "E":
            pattern = [
                "\(star)\(star)\(star)\(star)\(star)\(star)\(star)\(star)",
                "\(star)\(star)\(star)\(star)\(star)\(star)\(star)\(star)",
                "\(star)\(star)",
                "\(star)\(star)",
                "\(star)\(star)\(star)\(star)\(star)\(star)",
                "\(star)\(star)\(star)\(star)\(star)\(star)",
                "\(star)\(star)",
                "\(star)\(star)",
                "\(star)\(star)\(star)\(star)\(star)\(star)\(star)\(star)",
                "\(star)\(star)\(star)\(star)\(star)\(star)\(star)\(star)"
            ]
        case "F":
            pattern =  [
                "\(star)\(star)\(star)\(star)\(star)\(star)\(star)\(star)",
                "\(star)\(star)\(star)\(star)\(star)\(star)\(star)\(star)",
                "\(star)\(star)",
                "\(star)\(star)",
                "\(star)\(star)\(star)\(star)\(star)\(star)",
                "\(star)\(star)\(star)\(star)\(star)\(star)",
                "\(star)\(star)",
                "\(star)\(star)",
                "\(star)\(star)",
                "\(star)\(star)"
            ]
        case"G":
            pattern = [
                "          \(star)\(star)\(star)\(star)\(star)\(star)",
                "     \(star)\(star)\(star)\(star)\(star)\(star)\(star)\(star)",
                "   \(star)\(star)                       \(star)\(star)",
                " \(star)\(star)",
                "\(star)\(star)               \(star)\(star)\(star)\(star)",
                "\(star)\(star)               \(star)\(star)\(star)\(star)",
                " \(star)\(star)                         \(star)\(star)",
                "   \(star)\(star)                       \(star)\(star)",
                "     \(star)\(star)\(star)\(star)\(star)\(star)\(star)\(star)",
                "          \(star)\(star)\(star)\(star)\(star)\(star)"
            ]
        case"H":
            pattern = [
                "\(star)\(star)                          \(star)\(star)",
                "\(star)\(star)                          \(star)\(star)",
                "\(star)\(star)                          \(star)\(star)",
                "\(star)\(star)                          \(star)\(star)",
                "\(star)\(star)\(star)\(star)\(star)\(star)\(star)\(star)\(star)",
                "\(star)\(star)\(star)\(star)\(star)\(star)\(star)\(star)\(star)",
                "\(star)\(star)                          \(star)\(star)",
                "\(star)\(star)                          \(star)\(star)",
                "\(star)\(star)                          \(star)\(star)",
                "\(star)\(star)                          \(star)\(star)"
            ]
        case"I":
            pattern = [
                "\(star)\(star)\(star)\(star)\(star)\(star)",
                "\(star)\(star)\(star)\(star)\(star)\(star)",
                "           \(star)\(star)",
                "           \(star)\(star)",
                "           \(star)\(star)",
                "           \(star)\(star)",
                "           \(star)\(star)",
                "           \(star)\(star)",
                "\(star)\(star)\(star)\(star)\(star)\(star)",
                "\(star)\(star)\(star)\(star)\(star)\(star)"
            ]
        case"J":
            pattern =  [
                "        \(star)\(star)\(star)\(star)\(star)\(star)",
                "        \(star)\(star)\(star)\(star)\(star)\(star)",
                "                   \(star)\(star)",
                "                   \(star)\(star)",
                "                   \(star)\(star)",
                "                   \(star)\(star)",
                "\(star)\(star)        \(star)\(star)",
                "  \(star)\(star)      \(star)\(star)",
                "   \(star)\(star)\(star)\(star)\(star)",
                "     \(star)\(star)\(star)\(star)"
            ]
        case"K":
            pattern = [
                "\(star)\(star)                  \(star)\(star)",
                "\(star)\(star)             \(star)\(star)",
                "\(star)\(star)        \(star)\(star)",
                "\(star)\(star)   \(star)\(star)",
                "\(star)\(star)\(star)\(star)",
                "\(star)\(star) \(star)\(star)",
                "\(star)\(star)     \(star)\(star) ",
                "\(star)\(star)         \(star)\(star) ",
                "\(star)\(star)             \(star)\(star)",
                "\(star)\(star)                 \(star)\(star)"
            ]
        case"L":
            pattern = [
                "\(star)\(star)",
                "\(star)\(star)",
                "\(star)\(star)",
                "\(star)\(star)",
                "\(star)\(star)",
                "\(star)\(star)",
                "\(star)\(star)",
                "\(star)\(star)",
                "\(star)\(star)\(star)\(star)\(star)\(star)\(star)\(star)",
                "\(star)\(star)\(star)\(star)\(star)\(star)\(star)\(star)"
            ]
        case"M":
            pattern = [
                "\(star)\(star)                             \(star)\(star)",
                "\(star)\(star)\(star)                  \(star)\(star)\(star)",
                "\(star)\(star)\(star)\(star)        \(star)\(star)\(star)\(star)",
                "\(star)\(star)   \(star)\(star) \(star)\(star)    \(star)\(star)",
                "\(star)\(star)       \(star)\(star)\(star)       \(star)\(star)",
                "\(star)\(star)             \(star)           \(star)\(star)",
                "\(star)\(star)                              \(star)\(star)",
                "\(star)\(star)                              \(star)\(star)",
                "\(star)\(star)                              \(star)\(star)",
                "\(star)\(star)                              \(star)\(star)"
            ]
        case"N":
            pattern = [
                "\(star)\(star)                           \(star)\(star)",
                "\(star)\(star)\(star)                      \(star)\(star)",
                "\(star)\(star)\(star)\(star)                 \(star)\(star)",
                "\(star)\(star)  \(star)\(star)               \(star)\(star)",
                "\(star)\(star)     \(star)\(star)            \(star)\(star)",
                "\(star)\(star)         \(star)\(star)        \(star)\(star)",
                "\(star)\(star)             \(star)\(star)    \(star)\(star)",
                "\(star)\(star)                 \(star)\(star)\(star)\(star)",
                "\(star)\(star)                      \(star)\(star)\(star)",
                "\(star)\(star)                           \(star)\(star)"
            ]
        case "O":
            pattern = [
                "         \(star)\(star)\(star)\(star)\(star)",
                "    \(star)\(star)\(star)\(star)\(star)\(star)\(star)",
                "  \(star)\(star)                    \(star)\(star)",
                " \(star)\(star)                      \(star)\(star)",
                "\(star)\(star)                        \(star)\(star)",
                "\(star)\(star)                        \(star)\(star)",
                " \(star)\(star)                      \(star)\(star)",
                "  \(star)\(star)                    \(star)\(star)",
                "    \(star)\(star)\(star)\(star)\(star)\(star)\(star)",
                "         \(star)\(star)\(star)\(star)\(star)"
            ]
        case"P":
            pattern = [
                "\(star)\(star)\(star)\(star)\(star)\(star)\(star)",
                "\(star)\(star)\(star) \(star)\(star)\(star)\(star)\(star)",
                "\(star)\(star)                      \(star)\(star)",
                "\(star)\(star)                      \(star)\(star)",
                "\(star)\(star)\(star) \(star)\(star)\(star)\(star)\(star)",
                "\(star)\(star)\(star)\(star)\(star)\(star)\(star)",
                "\(star)\(star)",
                "\(star)\(star)",
                "\(star)\(star)",
                "\(star)\(star)"
            ]
        case"Q":
            pattern = [
                "         \(star)\(star)\(star)\(star)\(star)",
                "    \(star)\(star)\(star)\(star)\(star)\(star)\(star)",
                "  \(star)\(star)                    \(star)\(star)",
                " \(star)\(star)                      \(star)\(star)",
                "\(star)\(star)                        \(star)\(star)",
                "\(star)\(star)          \(star)\(star)    \(star)\(star)",
                " \(star)\(star)            \(star)\(star)\(star)\(star)",
                "  \(star)\(star)                 \(star)\(star)",
                "    \(star)\(star)\(star)\(star)\(star)\(star)\(star)\(star)",
                "         \(star)\(star)\(star)\(star)\(star)   \(star)\(star)"
            ]
        case"R":
            pattern = [
                "\(star)\(star)\(star)\(star)\(star)\(star)\(star)",
                "\(star)\(star)\(star)\(star)\(star)\(star)\(star)\(star)",
                "\(star)\(star)                     \(star)\(star)",
                "\(star)\(star)                     \(star)\(star)",
                "\(star)\(star)\(star)\(star)\(star)\(star)\(star)\(star)",
                "\(star)\(star)\(star)\(star)\(star)\(star)\(star)",
                "\(star)\(star)    \(star)\(star)",
                "\(star)\(star)         \(star)\(star)",
                "\(star)\(star)              \(star)\(star)",
                "\(star)\(star)                  \(star)\(star)"
            ]
        case "S":
            pattern = [
                "     \(star)\(star)\(star)\(star)\(star)",
                " \(star)\(star)\(star)\(star)\(star)\(star)\(star)",
                "\(star)\(star)                 \(star)\(star)",
                "\(star)\(star)",
                "  \(star)\(star)\(star)\(star)\(star)\(star)",
                "     \(star)\(star)\(star)\(star)\(star)\(star)",
                "                            \(star)\(star)",
                "\(star)\(star)                  \(star)\(star)",
                " \(star)\(star)\(star)\(star)\(star)\(star)\(star)",
                "       \(star)\(star)\(star)\(star)\(star)",
            ]
        case "T":
            pattern = [
                "\(star)\(star)\(star)\(star)\(star)\(star)\(star)\(star)",
                "\(star)\(star)\(star)\(star)\(star)\(star)\(star)\(star)",
                "                \(star)\(star)",
                "                \(star)\(star)",
                "                \(star)\(star)",
                "                \(star)\(star)",
                "                \(star)\(star)",
                "                \(star)\(star)",
                "                \(star)\(star)",
                "                \(star)\(star)"
            ]
        case "U":
            pattern =  [
                "\(star)\(star)                     \(star)\(star)",
                "\(star)\(star)                     \(star)\(star)",
                "\(star)\(star)                     \(star)\(star)",
                "\(star)\(star)                     \(star)\(star)",
                "\(star)\(star)                     \(star)\(star)",
                "\(star)\(star)                     \(star)\(star)",
                "\(star)\(star)                     \(star)\(star)",
                "  \(star)\(star)                 \(star)\(star)",
                "      \(star)\(star)\(star)\(star)\(star)\(star)",
                "          \(star)\(star)\(star)\(star)"
            ]
        case "V":
            pattern = [
                "\(star)\(star)                              \(star)\(star)",
                "  \(star)\(star)                          \(star)\(star)",
                "    \(star)\(star)                      \(star)\(star)",
                "      \(star)\(star)                  \(star)\(star)",
                "        \(star)\(star)              \(star)\(star)",
                "          \(star)\(star)          \(star)\(star)",
                "            \(star)\(star)      \(star)\(star) ",
                "              \(star)\(star)  \(star)\(star)",
                "                  \(star)\(star)\(star)",
                "                       \(star)"
            ]
        case "W":
            pattern = [
                "\(star)\(star)                                          \(star)\(star)",
                " \(star)\(star)                                        \(star)\(star)",
                "  \(star)\(star)                                      \(star)\(star)",
                "   \(star)\(star)                                    \(star)\(star)",
                "    \(star)\(star)               \(star)              \(star)\(star)",
                "     \(star)\(star)           \(star)\(star)           \(star)\(star)",
                "      \(star)\(star)        \(star)\(star)\(star)       \(star)\(star)",
                "       \(star)\(star)   \(star)\(star)  \(star)\(star)   \(star)\(star)",
                "        \(star)\(star)\(star)\(star)      \(star)\(star)\(star)\(star)",
                "          \(star)\(star)\(star)            \(star)\(star)\(star)"
            ]
        case "X":
            pattern = [
                "\(star)\(star)                    \(star)\(star)",
                "   \(star)\(star)              \(star)\(star)",
                "      \(star)\(star)        \(star)\(star)",
                "         \(star)\(star)  \(star)\(star)",
                "            \(star)\(star)\(star)",
                "            \(star)\(star)\(star)",
                "         \(star)\(star)  \(star)\(star)",
                "      \(star)\(star)        \(star)\(star)",
                "   \(star)\(star)              \(star)\(star)",
                "\(star)\(star)                    \(star)\(star)"
            ]
        case "Y":
            pattern = [
                "\(star)\(star)                   \(star)\(star)",
                "   \(star)\(star)             \(star)\(star)",
                "      \(star)\(star)       \(star)\(star)",
                "         \(star)\(star) \(star)\(star) ",
                "            \(star)\(star)\(star)",
                "               \(star)\(star)",
                "               \(star)\(star)",
                "               \(star)\(star)",
                "               \(star)\(star)",
                "               \(star)\(star)"
            ]
        case "Z":
            pattern = [
                "\(star)\(star)\(star)\(star)\(star)\(star)\(star)",
                "\(star)\(star)\(star)\(star)\(star)\(star)\(star)",
                "                       \(star)\(star)",
                "                   \(star)\(star)",
                "               \(star)\(star)",
                "           \(star)\(star)",
                "       \(star)\(star)",
                "   \(star)\(star)",
                "\(star)\(star)\(star)\(star)\(star)\(star)\(star)",
                "\(star)\(star)\(star)\(star)\(star)\(star)\(star)"
            ]
            
            // Small
        case "a":
            pattern = [
                "     \(star)\(star)\(star)\(star)\(star)",
                "  \(star)\(star)\(star)\(star)\(star)\(star)",
                "                          \(star)\(star)",
                "                          \(star)\(star)",
                "     \(star)\(star)\(star)\(star)\(star)\(star)",
                "\(star)\(star)\(star)\(star)\(star)\(star)\(star)",
                "\(star)\(star)                \(star)\(star)",
                "\(star)\(star)                \(star)\(star)",
                "   \(star)\(star)\(star)\(star)\(star)\(star)",
                "     \(star)\(star)\(star)\(star)\(star)\(star)",
                "                          \(star)\(star)"
            ]
        case "b":
            pattern = [
                "\(star)\(star)",
                "\(star)\(star)",
                "\(star)\(star)",
                "\(star)\(star)\(star)\(star)\(star)\(star)",
                "\(star)\(star)\(star)\(star)\(star)\(star)\(star)",
                "\(star)\(star)                 \(star)\(star)",
                "\(star)\(star)                  \(star)\(star)",
                "\(star)\(star)                 \(star)\(star)",
                "\(star)\(star)\(star)\(star)\(star)\(star)\(star)",
                "\(star)\(star)\(star)\(star)\(star)\(star)",
            ]
        case"c":
            pattern = [
                "       \(star)\(star)\(star)\(star)\(star)\(star)",
                "    \(star)\(star)\(star)\(star)\(star)\(star)\(star)",
                " \(star)\(star)",
                "\(star)\(star)",
                " \(star)\(star)",
                "    \(star)\(star)\(star)\(star)\(star)\(star)\(star)",
                "       \(star)\(star)\(star)\(star)\(star)\(star)",
            ]
        case"d":
            pattern = [
                "                             \(star)\(star)",
                "                             \(star)\(star)",
                "                             \(star)\(star)",
                "        \(star)\(star)\(star)\(star)\(star)\(star)",
                "   \(star)\(star)\(star)\(star)\(star)\(star)\(star)",
                " \(star)\(star)                  \(star)\(star)",
                "\(star)\(star)                   \(star)\(star)",
                " \(star)\(star)                  \(star)\(star)",
                "   \(star)\(star)\(star)\(star)\(star)\(star)\(star)",
                "        \(star)\(star)\(star)\(star)\(star)\(star)",
            ]
        case"e":
            pattern = [
                "       \(star)\(star)\(star)\(star)\(star)",
                "    \(star)\(star)\(star)\(star)\(star)\(star)",
                "  \(star)\(star)              \(star)\(star)",
                " \(star)\(star)               \(star)\(star)",
                "\(star)\(star)\(star)\(star)\(star)\(star)\(star)",
                "\(star)\(star)\(star)\(star)\(star)\(star)\(star)",
                " \(star)\(star)",
                "  \(star)\(star)",
                "     \(star)\(star)\(star)\(star)\(star)\(star)",
                "        \(star)\(star)\(star)\(star)\(star)"
            ]
        case"f":
            pattern = [
                "          \(star)\(star)\(star)\(star)\(star)",
                "       \(star)\(star)\(star)\(star)\(star)\(star)",
                "     \(star)\(star)",
                "     \(star)\(star)",
                "\(star)\(star)\(star)\(star)\(star)\(star)",
                "\(star)\(star)\(star)\(star)\(star)\(star)",
                "     \(star)\(star)",
                "     \(star)\(star)",
                "     \(star)\(star)",
                "     \(star)\(star)"
            ]
        case"g":
            pattern = [
                "      \(star)\(star)\(star)\(star)\(star)",
                "   \(star)\(star)\(star)\(star)\(star)\(star)",
                " \(star)\(star)               \(star)\(star)",
                "\(star)\(star)                \(star)\(star)",
                "\(star)\(star)\(star)\(star)\(star)\(star)\(star)",
                "     \(star)\(star)\(star)\(star)\(star)\(star)",
                "                          \(star)\(star)",
                " \(star)\(star)              \(star)\(star)",
                "   \(star)\(star)\(star)\(star)\(star)\(star)",
                "      \(star)\(star)\(star)\(star)\(star)"
            ]
        case"h":
            pattern = [
                "\(star)\(star)",
                "\(star)\(star)",
                "\(star)\(star)",
                "\(star)\(star) \(star)\(star)\(star)\(star)",
                "\(star)\(star)\(star)\(star)\(star)\(star)\(star)",
                "\(star)\(star)                \(star)\(star)",
                "\(star)\(star)                \(star)\(star)",
                "\(star)\(star)                \(star)\(star)",
                "\(star)\(star)                \(star)\(star)",
                "\(star)\(star)                \(star)\(star)"
            ]
        case"i":
            pattern = [
                "    \(star)\(star)",
                "    \(star)\(star)",
                "",
                "    \(star)\(star)",
                "    \(star)\(star)",
                "    \(star)\(star)",
                "    \(star)\(star)",
                "    \(star)\(star)",
                "    \(star)\(star)",
                "    \(star)\(star)"
            ]
        case"j":
            pattern = [
                "                  \(star)\(star)",
                "                  \(star)\(star)",
                "",
                "                  \(star)\(star)",
                "                  \(star)\(star)",
                "                  \(star)\(star)",
                "                  \(star)\(star)",
                "                  \(star)\(star)",
                "                  \(star)\(star)",
                "                  \(star)\(star)",
                "\(star)\(star)       \(star)\(star)",
                " \(star)\(star)\(star)\(star)\(star)",
                "    \(star)\(star)\(star)\(star)"
            ]
        case"k":
            pattern = [
                "\(star)\(star)",
                "\(star)\(star)",
                "\(star)\(star)             \(star)\(star)",
                "\(star)\(star)        \(star)\(star)",
                "\(star)\(star)     \(star)\(star)",
                "\(star)\(star)\(star)\(star)",
                "\(star)\(star)   \(star)\(star)",
                "\(star)\(star)       \(star)\(star)",
                "\(star)\(star)           \(star)\(star)",
                "\(star)\(star)              \(star)\(star)"
            ]
        case"l":
            pattern = [
                "\(star)\(star)",
                "\(star)\(star)",
                "\(star)\(star)",
                "\(star)\(star)",
                "\(star)\(star)",
                "\(star)\(star)",
                "\(star)\(star)",
                "\(star)\(star)",
                "\(star)\(star)",
                "\(star)\(star)"
            ]
        case "m":
            pattern = [
                "\(star)\(star)  \(star)\(star)           \(star)\(star)",
                "\(star)\(star)\(star)  \(star)\(star)\(star)\(star)  \(star)\(star)",
                "\(star)\(star)             \(star)\(star)          \(star)\(star)",
                "\(star)\(star)             \(star)\(star)          \(star)\(star)",
                "\(star)\(star)             \(star)\(star)          \(star)\(star)",
                "\(star)\(star)             \(star)\(star)          \(star)\(star)",
                "\(star)\(star)             \(star)\(star)          \(star)\(star)"
            ]
        case"n":
            pattern = [
                "\(star)\(star)  \(star)\(star)",
                "\(star)\(star)\(star)   \(star)\(star)",
                "\(star)\(star)             \(star)\(star)",
                "\(star)\(star)             \(star)\(star)",
                "\(star)\(star)             \(star)\(star)",
                "\(star)\(star)             \(star)\(star)",
                "\(star)\(star)             \(star)\(star)"
            ]
        case"o":
            pattern = [
                "         \(star)\(star)\(star)\(star)",
                "    \(star)\(star)\(star)\(star)\(star)\(star)",
                " \(star)\(star)                \(star)\(star)",
                "\(star)\(star)                  \(star)\(star)",
                " \(star)\(star)                \(star)\(star)",
                "    \(star)\(star)\(star)\(star)\(star)\(star)",
                "         \(star)\(star)\(star)\(star)"
            ]
        case "p":
            pattern = [
                "\(star)\(star)\(star)\(star)\(star)\(star)",
                "\(star)\(star)\(star)\(star)\(star)\(star)\(star)",
                "\(star)\(star)                \(star)\(star)",
                "\(star)\(star)                \(star)\(star)",
                "\(star)\(star)\(star)\(star)\(star)\(star)\(star)",
                "\(star)\(star)\(star)\(star)\(star)\(star)",
                "\(star)\(star)",
                "\(star)\(star)",
                "\(star)\(star)",
                "\(star)\(star)"
            ]
        case "q":
            pattern = [
                "     \(star)\(star)\(star)\(star)\(star)\(star)",
                "\(star)\(star)\(star)\(star)\(star)\(star)\(star)",
                "\(star)\(star)                \(star)\(star)",
                "\(star)\(star)                \(star)\(star)",
                "\(star)\(star)\(star)\(star)\(star)\(star)\(star)",
                "     \(star)\(star)\(star)\(star)\(star)\(star)",
                "                          \(star)\(star)",
                "                          \(star)\(star)",
                "                          \(star)\(star)",
                "                          \(star)\(star)"
            ]
        case "r":
            pattern = [
                "\(star)      \(star)\(star)\(star)\(star)",
                " \(star)\(star)\(star)\(star)\(star)\(star)\(star)",
                " \(star)\(star)                \(star)\(star)",
                " \(star)\(star)",
                " \(star)\(star)",
                " \(star)\(star)",
                " \(star)\(star)"
            ]
        case"s":
            pattern = [
                "    \(star)\(star)\(star)\(star)\(star)",
                " \(star)\(star)\(star)\(star)\(star)\(star)",
                "\(star)\(star)",
                "\(star)\(star)",
                "  \(star)\(star)\(star)\(star)\(star)",
                "     \(star)\(star)\(star)\(star)\(star)",
                "                       \(star)\(star)",
                "                       \(star)\(star)",
                " \(star)\(star)\(star)\(star)\(star)\(star)",
                "    \(star)\(star)\(star)\(star)\(star)"
            ]
        case"t":
            pattern = [
                "           \(star)\(star)",
                "           \(star)\(star)",
                " \(star)\(star)\(star)\(star)\(star)\(star)",
                " \(star)\(star)\(star)\(star)\(star)\(star)",
                "           \(star)\(star)",
                "           \(star)\(star)",
                "           \(star)\(star)",
                "           \(star)\(star)   \(star)\(star)",
                "             \(star)\(star)\(star)\(star)",
                "               \(star)\(star)\(star)"
            ]
        case"u":
            pattern = [
                "\(star)\(star)          \(star)\(star)",
                "\(star)\(star)          \(star)\(star)",
                "\(star)\(star)          \(star)\(star)",
                "\(star)\(star)          \(star)\(star)",
                "\(star)\(star)          \(star)\(star)",
                "\(star)\(star)          \(star)\(star)",
                "\(star)\(star)\(star)\(star)\(star)\(star)",
                "   \(star)\(star)\(star)\(star)\(star)",
                "                     \(star)\(star)"
            ]
        case"v":
            pattern = [
                " \(star)\(star)                 \(star)\(star)",
                "   \(star)\(star)             \(star)\(star)",
                "     \(star)\(star)         \(star)\(star)",
                "       \(star)\(star)     \(star)\(star)",
                "         \(star)\(star) \(star)\(star)",
                "            \(star)\(star)\(star)",
                "                 \(star)"
            ]
        case "w":
            pattern = [
                "\(star)\(star)                                    \(star)\(star)",
                " \(star)\(star)               \(star)              \(star)\(star)",
                "  \(star)\(star)           \(star)\(star)           \(star)\(star)",
                "   \(star)\(star)        \(star)\(star)\(star)       \(star)\(star)",
                "    \(star)\(star)   \(star)\(star)  \(star)\(star)   \(star)\(star)",
                "     \(star)\(star)\(star)\(star)      \(star)\(star)\(star)\(star)",
                "       \(star)\(star)\(star)            \(star)\(star)\(star)"
            ]
        case"x":
            pattern = [
                "\(star)\(star)              \(star)\(star)",
                "   \(star)\(star)        \(star)\(star)",
                "      \(star)\(star)  \(star)\(star)",
                "          \(star)\(star)\(star)",
                "      \(star)\(star)  \(star)\(star)",
                "   \(star)\(star)        \(star)\(star)",
                "\(star)\(star)              \(star)\(star)"
            ]
        case "y":
            pattern = [
                "\(star)\(star)                \(star)\(star)",
                "   \(star)\(star)           \(star)\(star)",
                "      \(star)\(star)      \(star)\(star) ",
                "         \(star)\(star)\(star)\(star)  ",
                "            \(star)\(star)\(star)",
                "              \(star)\(star)",
                "             \(star)\(star)",
                "           \(star)\(star)",
                "         \(star)\(star)",
                "       \(star)\(star)",
            ]
        case "z":
            pattern = [
                "\(star)\(star)\(star)\(star)\(star)\(star)",
                "\(star)\(star)\(star)\(star)\(star)\(star)",
                "                \(star)\(star)",
                "          \(star)\(star)",
                "    \(star)\(star)",
                "\(star)\(star)\(star)\(star)\(star)\(star)",
                "\(star)\(star)\(star)\(star)\(star)\(star)"
            ]
            
            // Default case
        default:
            pattern = ["No pattern available"]
        }
        
        var patternWithEmojis = [String]()
        for line in pattern {
            var newLine = ""
            for char in line {
                if String(char) == star {
                    newLine += getNextEmoji()
                } else {
                    newLine += String(char)
                }
            }
            patternWithEmojis.append(newLine)
        }
        
        return patternWithEmojis.joined(separator: "\n")
        
        //        return pattern.joined(separator: "\n")
    }
    
    func getNextEmoji() -> String {
        guard !arr_emojis.isEmpty else {
            return ""
        }
        
        let emoji = arr_emojis[currentIndex % arr_emojis.count]
        currentIndex += 1
        return emoji
    }
    
    func isEmoji(character: Character) -> Bool {
        return character.unicodeScalars.first?.properties.isEmoji ?? false
    }
}

// MARK: - TextField And TextView Delegate
extension TextToEmojiVC: UITextViewDelegate, UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: string)
        
        let allowedCharacterSet = CharacterSet(charactersIn: "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxy'z0123456789-/:;()\\\"$&@.,?!₹[]{}#%^*+=_|~<>€£¥• ")
        
        if string.isEmpty {
            if !updatedText.isEmpty && !txtView_enterText.text.isEmpty {
                btn_generate.alpha = 1
                btn_generate.isEnabled = true
            } else {
                btn_generate.alpha = 0.5
                btn_generate.isEnabled = false
            }
            return true // Allow erase operation
        }
        
        let replacementCharacterSet = CharacterSet(charactersIn: string)
        if allowedCharacterSet.isSuperset(of: replacementCharacterSet) {
            return false
        }
        
        if !updatedText.isEmpty && !txtView_enterText.text.isEmpty {
            btn_generate.alpha = 1
            btn_generate.isEnabled = true
        } else {
            btn_generate.alpha = 0.5
            btn_generate.isEnabled = false
        }
        return true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let exerciseName = txtField_enterEmoji.text ?? ""
        
        let allowedCharacterSet = CharacterSet(charactersIn: "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789 ")
        let replacementCharacterSet = CharacterSet(charactersIn: text)
        if !allowedCharacterSet.isSuperset(of: replacementCharacterSet) {
            return false
        }
        
        if newText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || exerciseName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            btn_generate.alpha = 0.5
            btn_generate.isEnabled = false
        } else {
            btn_generate.alpha = 1.0
            btn_generate.isEnabled = true
        }
        
        return true
    }
}

