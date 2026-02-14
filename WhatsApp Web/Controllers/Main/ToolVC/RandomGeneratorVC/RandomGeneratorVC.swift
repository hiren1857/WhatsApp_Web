//
//  RandomGeneratorVC.swift
//  WhatsApp Web
//
//  Created by mac on 06/06/24.
//

import UIKit
import SkeletonView

class RandomGeneratorVC: UIViewController {
    
    // MARK: - @IBOutlet
    @IBOutlet weak var vw_randomType: UIView!
    @IBOutlet weak var vw_nativeAD: UIView!
    @IBOutlet weak var vw_output: UIView!
    @IBOutlet weak var vw_containerView: UIView!
    
    @IBOutlet weak var lbl_randomType: UILabel!
    
    @IBOutlet weak var txtField_limit: NoPasteTextField!
    @IBOutlet weak var btn_generate: LoadingButton!
    
    @IBOutlet weak var txtView_output: UITextView!
    
    @IBOutlet weak var tblVw_randomSelectType: UITableView!
    
    @IBOutlet var imgVw_bottom: [UIImageView]!
    @IBOutlet var btn_bottom: [UIButton]!
    
    @IBOutlet weak var const_vwNativeAdHeight: NSLayoutConstraint!
    @IBOutlet weak var const_vwNativeAdTop: NSLayoutConstraint!
    
    // MARK: - Variable
    var arrTitle = ["Random Special Emojis","Random Digits","Random Letters","Random Letter & Digits","Random Special Character"]
    var arrSubTitle = ["Eg: 🤗🌹👩💥😅👆🏼👀😂","Eg: 957884567","Eg: HikyppOTT","Eg: Hi56709p2ss","Eg: *&%$#@<)("]

    var selectIndex = 0
    var randomType = "emoji"
    var originalTextTxtField = ""
    var originalRandomType = ""
    let nativeAdManager = NativeAdManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
    
    // MARK: - @IBAction
    @IBAction func btn_generateTapped(_ sender: UIButton) {
        hideKeyboard()
        
        if txtField_limit.text! .isEmpty {
            showAlert(message: "Please Enter Limit..")
        }
        
        guard let text = txtField_limit.text, let number = Int(text) else {
            showAlert(message: "Please enter only numbers in Repeat counter..")
            return
        }
        
        if number > 1000 {
            showAlert(message: "Repeat counter number should not be more than 1000.")
        }
        
//        if Constants.USERDEFAULTS.value(forKey: "isPremium") == nil {
//            if txtField_limit.text != originalTextTxtField || randomType != originalRandomType {
//                if let premiumPopUpVc = storyboard?.instantiateViewController(withIdentifier: "PremiumPopUpVC") as? PremiumPopUpVC {
//                    let nav = UINavigationController(rootViewController: premiumPopUpVc)
//                    nav.modalPresentationStyle = .custom
//                    
//                    premiumPopUpVc.isTitle = "Random Generator"
//                    premiumPopUpVc.complitionHandler = {
//                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [self] in
//                            originalTextTxtField = txtField_limit.text!
//                            originalRandomType = randomType
//                            dismiss(animated: false) { [self] in
//                                btn_generate.startLoading()
//                                let count = Int(txtField_limit.text!)
//                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) { [self] in
//                                    btn_generate.stopLoading()
//                                    switch randomType {
//                                    case "emoji":
//                                        txtView_output.text = generateRandomEmojis(length: count ?? 0)
//                                    case "digit":
//                                        txtView_output.text = generateRandomDigits(length: count ?? 0)
//                                    case "letter":
//                                        txtView_output.text = generateRandomLetters(length: count ?? 0)
//                                    case "letterAndDigit":
//                                        txtView_output.text = generateRandomLettersAndDigit(length: count ?? 0)
//                                    case "specialCharacter":
//                                        txtView_output.text = generateRandomSpecialCharacter(length: count ?? 0)
//                                    default:
//                                        break
//                                    }
//                                    
//                                    if txtView_output.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
//                                        imgVw_bottom.forEach { $0.tintColor = UIColor(hex: "#8E8E93") }
//                                        btn_bottom.forEach { $0.isEnabled = false }
//                                    } else {
//                                        imgVw_bottom.forEach { $0.tintColor = UIColor(named: "6CCD1C") }
//                                        btn_bottom.forEach { $0.isEnabled = true }
//                                    }
//                                }
//                            }
//                        }
//                    }
//                    self.present(nav, animated: false)
//                }
//            } else {
//                let count = Int(txtField_limit.text!)
//                btn_generate.startLoading()
//                DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) { [self] in
//                    btn_generate.stopLoading()
//                    switch randomType {
//                    case "emoji":
//                        txtView_output.text = generateRandomEmojis(length: count ?? 0)
//                    case "digit":
//                        txtView_output.text = generateRandomDigits(length: count ?? 0)
//                    case "letter":
//                        txtView_output.text = generateRandomLetters(length: count ?? 0)
//                    case "letterAndDigit":
//                        txtView_output.text = generateRandomLettersAndDigit(length: count ?? 0)
//                    case "specialCharacter":
//                        txtView_output.text = generateRandomSpecialCharacter(length: count ?? 0)
//                    default:
//                        break
//                    }
//                    
//                    if txtView_output.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
//                        imgVw_bottom.forEach { $0.tintColor = UIColor(hex: "#8E8E93") }
//                        btn_bottom.forEach { $0.isEnabled = false }
//                    } else {
//                        imgVw_bottom.forEach { $0.tintColor = UIColor(named: "6CCD1C") }
//                        btn_bottom.forEach { $0.isEnabled = true }
//                    }
//                }
//            }
//        } else {
        AdMob.sharedInstance()?.loadInste(self)
        let count = Int(txtField_limit.text!)
            btn_generate.startLoading()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) { [self] in
                btn_generate.stopLoading()
                switch randomType {
                case "emoji":
                    txtView_output.text = generateRandomEmojis(length: count ?? 0)
                case "digit":
                    txtView_output.text = generateRandomDigits(length: count ?? 0)
                case "letter":
                    txtView_output.text = generateRandomLetters(length: count ?? 0)
                case "letterAndDigit":
                    txtView_output.text = generateRandomLettersAndDigit(length: count ?? 0)
                case "specialCharacter":
                    txtView_output.text = generateRandomSpecialCharacter(length: count ?? 0)
                default:
                    break
                }
                
                if txtView_output.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    imgVw_bottom.forEach { $0.tintColor = UIColor(hex: "#8E8E93") }
                    btn_bottom.forEach { $0.isEnabled = false }
                } else {
                    imgVw_bottom.forEach { $0.tintColor = UIColor(named: "6CCD1C") }
                    btn_bottom.forEach { $0.isEnabled = true }
                }
            }
//        }
    }
    
    @IBAction func btn_bottomTapped(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            txtView_output.text = ""
            txtField_limit.text = ""
            originalTextTxtField = ""
            originalRandomType = ""
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


// MARK: - Private Methods
extension RandomGeneratorVC {
    
    func setUpUI() {
        navigationItem.title = "Random Generator"
        navigationItem.largeTitleDisplayMode = .never
        
        tblVw_randomSelectType.delegate = self
        tblVw_randomSelectType.dataSource = self
        tblVw_randomSelectType.alpha = 0
        vw_containerView.alpha = 0
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(vw_selectRandomTypeTap))
        vw_randomType.addGestureRecognizer(tapGesture)
        
        txtField_limit.delegate = self
        txtField_limit.keyboardType = .numberPad

        btn_generate.alpha = 0.5
        btn_generate.isEnabled = false
        
        vw_randomType.layer.cornerRadius = IpadorIphone(value: 8)
        vw_nativeAD.layer.cornerRadius = IpadorIphone(value: 8)
        vw_output.layer.cornerRadius = IpadorIphone(value: 8)
        txtField_limit.layer.cornerRadius = IpadorIphone(value: 8)
        btn_generate.layer.cornerRadius = IpadorIphone(value: 25)
        
        btn_bottom.forEach { $0.isEnabled = false }
        
        DispatchQueue.main.async { [self] in
            vw_containerView.layer.cornerRadius = IpadorIphone(value: 14)
            vw_containerView.layer.shadowColor = UIColor.black.cgColor
            vw_containerView.layer.shadowOpacity = 0.2
            vw_containerView.layer.shadowOffset = CGSize(width: 0, height: 0)
            vw_containerView.layer.shadowRadius = 4
            vw_containerView.layer.masksToBounds = false
            
            tblVw_randomSelectType.layer.cornerRadius = IpadorIphone(value: 14)
            tblVw_randomSelectType.layer.masksToBounds = true
        }
        
        if Constants.USERDEFAULTS.value(forKey: "isPremium") == nil {
            const_vwNativeAdHeight.constant = IpadorIphone(value: 135)
            const_vwNativeAdTop.constant = IpadorIphone(value: 16)
            self.nativeAdManager.setupNativeAd(in: self, placeholderView: self.vw_nativeAD)
            vw_nativeAD.isHidden = false
        } else {
            const_vwNativeAdHeight.constant = 0
            const_vwNativeAdTop.constant = 0
            vw_nativeAD.isHidden = true
        }
        
        // left padding for UITextField’s placeholder
        let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: IpadorIphone(value: 12), height: txtField_limit.frame.height))
        txtField_limit.leftView = leftPaddingView
        txtField_limit.leftViewMode = .always
    }
    
    func generateRandomLetters(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
        return generateRandomString(from: letters, length: length)
    }
    
    func generateRandomDigits(length: Int) -> String {
        let digits = "0123456789"
        return generateRandomString(from: digits, length: length)
    }
    
    func generateRandomLettersAndDigit(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyz1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        return generateRandomString(from: letters, length: length)
    }
    
    func generateRandomEmojis(length: Int) -> String {
        let emojis = "😀😃😄😁😆😅😂🤣😊😇🙂🙃😉😌😍🥰😘😗😙😚😋😛😝😜🤪🤨🧐🤓😎🤩🥳😏😒😞😔😟😕🙁☹️😣😖😫😩🥺😢😭😤😠😡🤬🤯😳🥵🥶😱😨😰😥😓🤗🤔🤭🤫🤥😶😐😑😬🙄😯😦😧😮😲😴🤤😪😵🤐🥴🤢🤮🤧😷🤒🤕🤑🤠😈👿👹👺🤡💩👻💀☠️👽👾🤖🎃😺😸😹😻😼😽🙀😿😾"
        return generateRandomString(from: emojis, length: length)
    }
    
    func generateRandomSpecialCharacter(length: Int) -> String {
        let letters = "%/(&@)[$<?!#}>€£¥~{*]"
        return generateRandomString(from: letters, length: length)
    }
    
    func generateRandomString(from characters: String, length: Int) -> String {
        var randomString = ""
        for _ in 0..<length {
            if let randomCharacter = characters.randomElement() {
                randomString.append(randomCharacter)
            }
        }
        return randomString
    }
    
    func dropDownAnimate(toogle: Bool) {
        hideKeyboard()
        if toogle {
            UIView.animate(withDuration: 0.3) {
                self.tblVw_randomSelectType.alpha = 1
                self.vw_containerView.alpha = 1
                self.txtField_limit.isEnabled = false
            }
        } else {
            UIView.animate(withDuration: 0.3) {
                self.tblVw_randomSelectType.alpha = 0
                self.vw_containerView.alpha = 0
                self.txtField_limit.isEnabled = true
            }
        }
    }
    
    @objc func vw_selectRandomTypeTap() {
        if tblVw_randomSelectType.alpha == 0 {
            dropDownAnimate(toogle: true)
        } else {
            dropDownAnimate(toogle: false)
        }
    }
}

// MARK: - TextField Delegate
extension RandomGeneratorVC: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        
        guard let oldText = textField.text, let r = Range(range, in: oldText) else {
            return true
        }
        
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: string)
        
        let allowedCharacterSet = CharacterSet(charactersIn: "1234567890")
        
        if string.isEmpty {
            if !updatedText.isEmpty {
                btn_generate.alpha = 1
                btn_generate.isEnabled = true
            } else {
                btn_generate.alpha = 0.5
                btn_generate.isEnabled = false
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
        
        if updatedText.isEmpty {
            btn_generate.alpha = 0.5
            btn_generate.isEnabled = false
        } else {
            btn_generate.alpha = 1
            btn_generate.isEnabled = true
        }
        
        if textField == self.txtField_limit {
            let nwtxt = Double(updatedText) ?? 0
            if nwtxt <= 0 && updatedText == "0" {
                btn_generate.isEnabled = false
                btn_generate.alpha = 0.5
            }
            
            if nwtxt > 1000 || nwtxt <= 0  {
                return isNumeric && numberOfDots <= 0 && numberOfDecimalDigits <= 0 && count <= 3
            } else {
                return isNumeric && numberOfDots <= 0 && numberOfDecimalDigits <= 0 && count <= 4
            }
        }
        return true
    }
}

// MARK: - TableView (Delegate, DataSource)
extension RandomGeneratorVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrTitle.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblVw_randomSelectType.dequeueReusableCell(withIdentifier: "TblVw_RandomSelectTypeCell") as! TblVw_RandomSelectTypeCell
        cell.lbl_title.text = arrTitle[indexPath.row]
        cell.lbl_subTitle.text = arrSubTitle[indexPath.row]
        
        cell.accessoryType = (selectIndex == indexPath.row) ? .checkmark : .none
        lbl_randomType.text = arrTitle[selectIndex]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dropDownAnimate(toogle: false)
        selectIndex = indexPath.row
        
        switch indexPath.row {
        case 0:
            randomType = "emoji"
        case 1:
            randomType = "digit"
        case 2:
            randomType = "letter"
        case 3:
            randomType = "letterAndDigit"
        case 4:
            randomType = "specialCharacter"
        default:
            break
        }
        
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

// MARK: - TableView Cell
class TblVw_RandomSelectTypeCell: UITableViewCell {
    
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var lbl_subTitle: UILabel!
}
