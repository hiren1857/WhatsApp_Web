//
//  CreateCodeVC.swift
//  WhatsApp Web
//
//  Created by mac on 11/06/24.
//

import UIKit
import CoreImage
import PDFKit

class CreateCodeVC: UIViewController {
    
    // MARK: - @IBOutlet
    @IBOutlet weak var lbl_rename: UILabel!
    
    @IBOutlet weak var txtField_rename: UITextField!
    
    @IBOutlet weak var stackVw_btnRename: UIStackView!
    
    @IBOutlet var vw_colorBg: [UIView]!
    @IBOutlet weak var vw_blur: UIView!
    @IBOutlet weak var vw_renameBg: UIView!
    @IBOutlet weak var vw_colorMainBg: UIView!
    
    @IBOutlet var imgVw_color: [UIImageView]!
    @IBOutlet weak var imgVw_code: UIImageView!
    @IBOutlet weak var imgVw_renameCode: UIImageView!
    
    @IBOutlet var btn_color: [UIButton]!
    @IBOutlet weak var btn_cancel: UIButton!
    @IBOutlet weak var btn_rename: UIButton!
    
    @IBOutlet weak var const_vwColorMainBgHight: NSLayoutConstraint!
    
    
    // MARK: - Variables
    var btn_save = UIBarButtonItem()
    var codeImage = UIImage()
    
    var isGenerate_QRDetails = ""
    var previewImage = ""
    var previewImageName = ""
    var codeTypeName = ""
    
    var isBarcode = false
    var isQrPreview = false
    
    var arrSaveGenerateCode = [GenerateEntity]()
    var generateCodeData = CodeGenerateData()
    var complitionHandlerDelete: (()->(Void))?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        AdMob.sharedInstance()?.loadInste(self)
    }
    
    // MARK: - @IBAction
    @IBAction func btn_colorTapped(_ sender: UIButton) {
        let selectedTag = sender.tag
        
        if selectedTag != 0 {
            for (index, view) in vw_colorBg.enumerated() {
                view.layer.borderWidth = (index == selectedTag) ? IpadorIphone(value: 2) : 0
            }
        }
        
        switch selectedTag {
        case 0:
            if #available(iOS 14.0, *) {
                let colorPicker = UIColorPickerViewController()
                colorPicker.delegate = self
                present(colorPicker, animated: true, completion: nil)
            }
        case 1:
            if isBarcode {
                codeImage = generateBarCode(from: isGenerate_QRDetails, with: UIColor.black) ?? UIImage()
                imgVw_code.image = codeImage
            } else {
                codeImage = generateQRCode(from: isGenerate_QRDetails, with: UIColor.black) ?? UIImage()
                imgVw_code.image = codeImage
            }
        case 2:
            if isBarcode {
                codeImage = generateBarCode(from: isGenerate_QRDetails, with: UIColor.link) ?? UIImage()
                imgVw_code.image = codeImage
            } else {
                codeImage = generateQRCode(from: isGenerate_QRDetails, with: UIColor.link) ?? UIImage()
                imgVw_code.image = codeImage
            }
        case 3:
            if isBarcode {
                codeImage = generateBarCode(from: isGenerate_QRDetails, with: UIColor(hex: "#FD5900")) ?? UIImage()
                imgVw_code.image = codeImage
            } else {
                codeImage = generateQRCode(from: isGenerate_QRDetails, with: UIColor(hex: "#FD5900")) ?? UIImage()
                imgVw_code.image = codeImage
            }
        case 4:
            if isBarcode {
                codeImage = generateBarCode(from: isGenerate_QRDetails, with: UIColor(hex: "#FFDE00")) ?? UIImage()
                imgVw_code.image = codeImage
            } else {
                codeImage = generateQRCode(from: isGenerate_QRDetails, with: UIColor(hex: "#FFDE00")) ?? UIImage()
                imgVw_code.image = codeImage
            }
        case 5:
            if isBarcode {
                codeImage = generateBarCode(from: isGenerate_QRDetails, with: UIColor(hex: "#D43D79")) ?? UIImage()
                imgVw_code.image = codeImage
            } else {
                codeImage = generateQRCode(from: isGenerate_QRDetails, with: UIColor(hex: "#D43D79")) ?? UIImage()
                imgVw_code.image = codeImage
            }
        case 6:
            if isBarcode {
                codeImage = generateBarCode(from: isGenerate_QRDetails, with: UIColor(hex: "#CB0606")) ?? UIImage()
                imgVw_code.image = codeImage
            } else {
                codeImage = generateQRCode(from: isGenerate_QRDetails, with: UIColor(hex: "#CB0606")) ?? UIImage()
                imgVw_code.image = codeImage
            }
        default:
            break
        }
    }
    
    @IBAction func btn_cancelTapped(_ sender: UIButton) {
        vw_blur.alpha = 0
        animateScaleOut(desiredView: vw_renameBg)
        btn_save.isEnabled = true
        navigationItem.hidesBackButton = false
    }
    
    @IBAction func btn_renameTapped(_ sender: UIButton) {
        let uuid = UUID()
        let uuidString = "\(uuid.uuidString)img_QrCode"
        let url = saveImageToDocumentDirectory(image: codeImage, fileName: uuidString)
        if url != nil {
            if !txtField_rename.text!.isEmpty {
                self.saveGenerateCode(img_code: uuidString, code_name: txtField_rename.text ?? "")
            } else {
               print("")
            }
        }
    }
    
    @IBAction func btn_bottomTapped(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            UIPasteboard.general.image = imgVw_code.image
            Utils().showToast(context: self, msg: "Copied!")
        case 1:
            if !isQrPreview {
                shareGenerateCode(codeToShare: codeImage, codeName: codeTypeName)
            } else {
                shareGenerateCode(codeToShare: imgVw_code.image!, codeName: previewImageName)
            }
        case 2:
            let alert = UIAlertController(title: "Delete Q.R.", message: "Are you sure you want to delete this Q.R. code.", preferredStyle: .actionSheet)
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            
            alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { [self] _ in
                if !isQrPreview {
                    if let QrGenerateVc = storyboard?.instantiateViewController(withIdentifier: "QrGeneratorVC") as? QrGeneratorVC {
                        navigationController?.pushViewController(QrGenerateVc, animated: false)
                    }
                } else {
                    complitionHandlerDelete!()
                    if let navigationController = self.navigationController {
                        for viewController in navigationController.viewControllers {
                            if viewController is HistoryVC {
                                navigationController.popToViewController(viewController, animated: false)
                                break
                            }
                        }
                    }
                }
            }))
            
            if let popoverController = alert.popoverPresentationController {
                popoverController.sourceView = self.view
                popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
                popoverController.permittedArrowDirections = []
            }
            present(alert, animated: true)
        default:
            break
        }
    }
}

// MARK: - Private Methods
extension CreateCodeVC {
    
    func setUpUI() {
        navigationItem.title = "Create Code"
        
        if !isQrPreview {
            btn_save = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(btn_saveTapped))
            btn_save.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18)], for: .normal)
            const_vwColorMainBgHight.constant = IpadorIphone(value: 70)
            vw_colorMainBg.isHidden = false
        } else {
            btn_save = UIBarButtonItem(title: "", style: .done, target: self, action: #selector(btn_saveTapped))
            btn_save.isEnabled = false
            
            DispatchQueue.main.async { [self] in
                if let image = getImageFromDocumentDirectory(fileName: previewImage) {
                    self.imgVw_code.image = image
                }
            }
            const_vwColorMainBgHight.constant = 0
            vw_colorMainBg.isHidden = true
        }
        navigationItem.rightBarButtonItem = btn_save
        
        vw_blur.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideKeyboard)))
        
        txtField_rename.delegate = self
        txtField_rename.text = codeTypeName
         
        DispatchQueue.main.async { [self] in
            imgVw_color.forEach { $0.layer.cornerRadius = $0.frame.size.height / 2 }
            vw_colorBg.forEach { $0.layer.cornerRadius = $0.frame.size.height / 2 }
            vw_colorBg.forEach { $0.layer.borderColor = UIColor.black.cgColor}
            vw_colorBg[1].layer.borderWidth = IpadorIphone(value: 2)
            vw_renameBg.layer.cornerRadius = 14
            
            btn_cancel.layer.cornerRadius = 14
            btn_rename.layer.cornerRadius = 14
            btn_cancel.layer.maskedCorners = [.layerMinXMaxYCorner]
            btn_rename.layer.maskedCorners = [.layerMaxXMaxYCorner]
            
            stackVw_btnRename.layer.cornerRadius = 14
            stackVw_btnRename.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            
            txtField_rename.layer.cornerRadius = 8
        }
        
        if isBarcode {
            codeImage = generateBarCode(from: isGenerate_QRDetails, with: UIColor.black) ?? UIImage()
            imgVw_code.image = codeImage
        } else {
            codeImage = generateQRCode(from: isGenerate_QRDetails, with: UIColor.black) ?? UIImage()
            imgVw_code.image = codeImage
        }
        
        // left padding for UITextField’s placeholder
        let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: IpadorIphone(value: 8), height: txtField_rename.frame.height))
        txtField_rename.leftView = leftPaddingView
        txtField_rename.leftViewMode = .always
    }
    
    func generateQRCode(from string: String, with bodyColor: UIColor) -> UIImage? {
        guard let qrFilter = CIFilter(name: "CIQRCodeGenerator") else { return nil }
        let qrData = string.data(using: String.Encoding.ascii)
        qrFilter.setValue(qrData, forKey: "inputMessage")

        guard let qrCodeImage = qrFilter.outputImage else { return nil }

        // Create color filter to apply the body color
        guard let colorFilter = CIFilter(name: "CIFalseColor") else { return nil }
        colorFilter.setDefaults()
        colorFilter.setValue(qrCodeImage, forKey: "inputImage")
        colorFilter.setValue(CIColor(color: bodyColor), forKey: "inputColor0")
        colorFilter.setValue(CIColor(color: UIColor.white), forKey: "inputColor1")

        // Get colored QR code image
        guard let coloredQRCodeImage = colorFilter.outputImage else { return nil }

        let scaleX = 300 / coloredQRCodeImage.extent.size.width
        let scaleY = 300 / coloredQRCodeImage.extent.size.height
        let scaledImage = coloredQRCodeImage.transformed(by: CGAffineTransform(scaleX: scaleX, y: scaleY))

        let context = CIContext()
        guard let cgImage = context.createCGImage(scaledImage, from: scaledImage.extent) else { return nil }
        let processedImage = UIImage(cgImage: cgImage)

        return processedImage
    }
    
    func generateBarCode(from string: String, with foregroundColor: UIColor) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)
        if let filter = CIFilter(name: "CICode128BarcodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            
            if let output = filter.outputImage {
                // Apply color filter to change the barcode color
                if let colorFilter = CIFilter(name: "CIFalseColor") {
                    colorFilter.setValue(output, forKey: kCIInputImageKey)
                    colorFilter.setValue(CIColor(color: foregroundColor), forKey: "inputColor0")
                    colorFilter.setValue(CIColor(color: UIColor.white), forKey: "inputColor1")
                    
                    if let coloredOutput = colorFilter.outputImage {
                        let scaleX = 500 / coloredOutput.extent.size.width
                        let scaleY = 200 / coloredOutput.extent.size.height
                        
                        let transformedImage = coloredOutput.transformed(by: CGAffineTransform(scaleX: scaleX, y: scaleY))
                        
                        // Create a CIContext to convert CIImage to CGImage
                        let context = CIContext()
                        if let cgImage = context.createCGImage(transformedImage, from: transformedImage.extent) {
                            return UIImage(cgImage: cgImage)
                        }
                    }
                }
            }
        }
        return nil
    }
    
    @objc func btn_saveTapped() {
        btn_save.isEnabled = false
        navigationItem.hidesBackButton = true
        vw_blur.alpha = 1
        animateScaleIn(desiredView: vw_renameBg)
        imgVw_renameCode.image = codeImage
    }
    
    func saveGenerateCode(img_code: String, code_name: String) {
        generateCodeData.code_name = code_name
        generateCodeData.img_code = img_code
        generateCodeData.date = Date()
        generateCodeData.timeStemp = "\(Date().currentTimeMillis())"
        
        let save = Generate_Data().Save_GenerateCode(context: self.context, Generate: generateCodeData)
        
        if save {
            vw_blur.alpha = 0
            animateScaleOut(desiredView: vw_renameBg)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [self] in
                btn_save.isEnabled = true
                navigationItem.hidesBackButton = false
                if let historyVc = storyboard?.instantiateViewController(withIdentifier: "HistoryVC") as? HistoryVC {
                    navigationController?.pushViewController(historyVc, animated: false)
                }
            }
        } else {
            print("Noooo")
        }
    }
    
    func shareGenerateCode(codeToShare: UIImage, codeName: String) {
        let alertActionSheet = UIAlertController(title: "Share as", message: nil, preferredStyle: .actionSheet)
        let PDF = UIAlertAction(title: "PDF", style: .default) { _ in
            if  let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                let pdfDocument = PDFDocument()
                let pdfPage = PDFPage(image: codeToShare)
                pdfDocument.insert(pdfPage!, at: 0)
                
                let pdfFileURL = documentsDirectory.appendingPathComponent("\(codeName).pdf")
                
                pdfDocument.write(to: pdfFileURL)
                
                let activityViewController = UIActivityViewController(activityItems: [pdfFileURL], applicationActivities: nil)
                
                if let popoverController = activityViewController.popoverPresentationController {
                    popoverController.sourceView = self.view
                    popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
                    popoverController.permittedArrowDirections = []
                }
                self.present(activityViewController, animated: true, completion: nil)
            }
        }
        
        let image = UIAlertAction(title: "Image", style: .default) { _ in
            let image = codeToShare
            let imageURL = self.saveImageToDocumentDirectory(image: image, fileName: "\(codeName).jpg")
            
            let activityViewController = UIActivityViewController(activityItems: [imageURL!], applicationActivities: nil)
            
            if let popoverController = activityViewController.popoverPresentationController {
                popoverController.sourceView = self.view
                popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
                popoverController.permittedArrowDirections = []
            }
            self.present(activityViewController, animated: true, completion: nil)
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            
        }
        
        alertActionSheet.addAction(PDF)
        alertActionSheet.addAction(image)
        alertActionSheet.addAction(cancel)
        
        if let popoverController = alertActionSheet.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        self.present(alertActionSheet, animated: true)
    }
}

// MARK: - TextField Delegate
extension CreateCodeVC: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: string)
        
        if textField.text == "" {
            if (string == " ") {
                return false
            }
        }
        
        if updatedText.isEmpty {
            btn_rename.isEnabled = false
        } else {
            btn_rename.isEnabled = true
        }
        
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        DispatchQueue.main.async { [self] in
            btn_rename.isEnabled = false
        }
        return true
    }
}

// MARK: - ColorPicker Delegate
extension CreateCodeVC: UIColorPickerViewControllerDelegate {
    
    @available(iOS 14.0, *)
    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
        let selectedColor = viewController.selectedColor
        if isBarcode {
            codeImage = generateBarCode(from: isGenerate_QRDetails, with: selectedColor)!
            imgVw_code.image = codeImage
        } else {
            codeImage = generateQRCode(from: isGenerate_QRDetails, with: selectedColor)!
            imgVw_code.image = codeImage
        }
        vw_colorBg.forEach { $0.layer.borderWidth = 0 }
    }
}
