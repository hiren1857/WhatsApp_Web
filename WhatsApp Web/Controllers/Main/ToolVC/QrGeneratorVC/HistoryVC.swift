//
//  HistoryVC.swift
//  WhatsApp Web
//
//  Created by mac on 13/06/24.
//

import UIKit
import PDFKit

class HistoryVC: UIViewController {
    
    // MARK: - @IBOutlet
    @IBOutlet weak var tblVw_history: UITableView!
    
    @IBOutlet weak var vw_blur: UIView!
    @IBOutlet var vw_renameBg: UIView!
    @IBOutlet weak var vw_nativeAd: UIView!
    
    @IBOutlet weak var imgVw_code: UIImageView!
    
    @IBOutlet weak var txtField_rename: UITextField!
    
    @IBOutlet weak var stackVw_btnRename: UIStackView!
    
    @IBOutlet weak var btn_cancel: UIButton!
    @IBOutlet weak var btn_rename: UIButton!
    
    @IBOutlet weak var const_vwNativeAdHeight: NSLayoutConstraint!
    @IBOutlet weak var const_vwNativeAdTop: NSLayoutConstraint!
    
    // MARK: - Variable
    var btn_add = UIBarButtonItem()
    var btn_back = UIBarButtonItem()
    
    var arrSaveGenerateCode = [GenerateEntity]()
    var generateCodeData = CodeGenerateData()
    let nativeAdManager = NativeAdManager()
    var timeStemp = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AdMob.sharedInstance()?.loadInste(self)
        setUpUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchGenerateData()
    }
    
    // MARK: - @IBAction
    @IBAction func btn_renameTapped(_ sender: UIButton) {
        renameGenerateCode(name: txtField_rename.text ?? "")
    }
    
    @IBAction func btn_cancelTapped(_ sender: UIButton) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [self] in
            vw_blur.alpha = 0
            btn_add.isEnabled = true
            btn_back.isEnabled = true
        }
        animateScaleOut(desiredView: vw_renameBg)
    }
}

// MARK: - Private Methods
extension HistoryVC {
    
    func setUpUI() {
        navigationItem.title = "Generate History"
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.hidesBackButton = true
        fetchGenerateData()
        
        btn_back = UIBarButtonItem(image: UIImage(named: "BackIcon"), style: .done, target: self, action: #selector(btn_backTapped))
        btn_back.imageInsets = UIEdgeInsets(top: 0, left: -8, bottom: 0, right: 0)
        navigationItem.leftBarButtonItem = btn_back
        btn_add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(btn_addTapped))
        navigationItem.rightBarButtonItem = btn_add
        
        vw_renameBg.layer.cornerRadius = 14
        txtField_rename.layer.cornerRadius = 8
        btn_cancel.layer.cornerRadius = 14
        btn_rename.layer.cornerRadius = 14
        btn_cancel.layer.maskedCorners = [.layerMinXMaxYCorner]
        btn_rename.layer.maskedCorners = [.layerMaxXMaxYCorner]
        stackVw_btnRename.layer.cornerRadius = 14
        stackVw_btnRename.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        
        tblVw_history.delegate = self
        tblVw_history.dataSource = self
        txtField_rename.delegate = self
        
        if Constants.USERDEFAULTS.value(forKey: "isPremium") == nil {
            const_vwNativeAdHeight.constant = IpadorIphone(value: 135)
            const_vwNativeAdTop.constant = IpadorIphone(value: 8)
            self.nativeAdManager.setupNativeAd(in: self, placeholderView: self.vw_nativeAd)
            vw_nativeAd.isHidden = false
        } else {
            const_vwNativeAdHeight.constant = 0
            const_vwNativeAdTop.constant = 0
            vw_nativeAd.isHidden = true
        }
        
        // left padding for UITextField’s placeholder
        let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: IpadorIphone(value: 8), height: txtField_rename.frame.height))
        txtField_rename.leftView = leftPaddingView
        txtField_rename.leftViewMode = .always
    }
    
    func fetchGenerateData() {
        Generate_Data().fetch_GenerateCode_Data(context: self.context) { arrGenerateCode in
            self.arrSaveGenerateCode = arrGenerateCode.reversed()
            UIView.transition(with: self.tblVw_history, duration: 0.3, options: .transitionCrossDissolve, animations: {self.tblVw_history.reloadData()}, completion: nil)
        }
    }
    
    func deleteGenerateData(product: GenerateEntity) {
        let delete = Generate_Data().delete_GenerateCode_Data(context: self.context, selectedProduct: product)
        
        if delete {
            fetchGenerateData()
            if self.arrSaveGenerateCode.isEmpty {
                self.btn_backTapped()
            }
        } else {
            print("Delete Error")
        }
    }
    
    func renameGenerateCode(name: String) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [self] in
            vw_blur.alpha = 0
            btn_add.isEnabled = true
            btn_back.isEnabled = true
        }
        animateScaleOut(desiredView: vw_renameBg)
        
        generateCodeData.code_name = name
        generateCodeData.timeStemp = timeStemp
        let nameUpdate = Generate_Data().updateGenerateCodeName(context: self.context, Generate: generateCodeData)
        
        if nameUpdate {
            fetchGenerateData()
        } else {
            print("Name not Update")
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
    
    @objc func btn_addTapped() {
        if let qrGeneratorvc = storyboard?.instantiateViewController(withIdentifier: "QrGeneratorVC") as? QrGeneratorVC {
            navigationController?.pushViewController(qrGeneratorvc, animated: true)
        }
    }
    
    @objc func btn_backTapped() {
        if let navigationController = self.navigationController {
            for viewController in navigationController.viewControllers {
                if viewController is ToolVC {
                    navigationController.popToViewController(viewController, animated: true)
                    break
                }
            }
        }
    }
}

// MARK: - TextField Delegate
extension HistoryVC: UITextFieldDelegate {
    
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

// MARK: - TableView (Delegate, DataSource)
extension HistoryVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrSaveGenerateCode.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblVw_history.dequeueReusableCell(withIdentifier: "TblVw_HistoryCell") as! TblVw_HistoryCell
        
        let arr = arrSaveGenerateCode[indexPath.row]
        cell.lbl_date.text = "Access \(Utils().ConvertDate(date: arr.date!))"
        cell.lbl_name.text = arr.code_name
        cell.imgVw.image = getImageFromDocumentDirectory(fileName: arr.img_code!)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let reversedIndex = arrSaveGenerateCode.count - 1 - indexPath.row

        let arr = arrSaveGenerateCode[indexPath.row]
        if let previewVc = storyboard?.instantiateViewController(withIdentifier: "CreateCodeVC") as? CreateCodeVC {
            previewVc.isQrPreview = true
            previewVc.previewImage = arrSaveGenerateCode[indexPath.row].img_code ?? ""
            previewVc.previewImageName = arrSaveGenerateCode[indexPath.row].code_name ?? ""
            previewVc.complitionHandlerDelete = { [self] in
                deleteGenerateData(product: arr)
            }
            navigationController?.pushViewController(previewVc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let arrGenerate = arrSaveGenerateCode[indexPath.row]
        
        let Delete = UIContextualAction(style: .destructive, title: "Delete") { [self] _, _, completionHandler in
            completionHandler(false)
            
            let alertMessage = "Are you sure you want to delete this Q.R. code."
            let alert = UIAlertController(title: "Delete Q.R.", message: alertMessage, preferredStyle: .actionSheet)
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            
            alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { [self] _ in
                deleteGenerateData(product: arrGenerate)
            }))
            
            if let popoverController = alert.popoverPresentationController {
                popoverController.sourceView = self.view
                popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
                popoverController.permittedArrowDirections = []
            }
            present(alert, animated: true)
        }
        
        let Share = UIContextualAction(style: .normal, title: "Share") { [self] _, _, complition in
            complition(false)
            
            if let image_Code = getImageFromDocumentDirectory(fileName: arrGenerate.img_code!) {
                shareGenerateCode(codeToShare: image_Code, codeName: arrGenerate.code_name!)
            }
        }
        
        let Rename = UIContextualAction(style: .normal, title: "Rename") { [self] _, _, complition in
            complition(false)
            txtField_rename.text = arrGenerate.code_name
            timeStemp = arrGenerate.timeStemp!
            imgVw_code.image = getImageFromDocumentDirectory(fileName: arrGenerate.img_code!)
            vw_blur.alpha = 1
            animateScaleIn(desiredView: vw_renameBg)
            btn_add.isEnabled = false
            btn_back.isEnabled = false
        }
        
        Share.backgroundColor = .link
        Rename.backgroundColor = UIColor(hex: "#1B9B30")
        return UISwipeActionsConfiguration(actions: [Delete, Share, Rename])
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let arrGenerate = arrSaveGenerateCode[indexPath.row]
        
        let actionProvider: UIContextMenuActionProvider = { _ in
            
            let share = UIAction(title: "Share", image: UIImage(systemName: "square.and.arrow.up")) { [self] _ in
                if let image_Code = getImageFromDocumentDirectory(fileName: arrGenerate.img_code!) {
                    shareGenerateCode(codeToShare: image_Code, codeName: arrGenerate.code_name!)
                }
            }
            
            let Rename = UIAction(title: "Rename", image: UIImage(systemName: "square.and.pencil")) { [self] _ in
                txtField_rename.text = arrGenerate.code_name
                timeStemp = arrGenerate.timeStemp!
                imgVw_code.image = getImageFromDocumentDirectory(fileName: arrGenerate.img_code!)
                vw_blur.alpha = 1
                animateScaleIn(desiredView: vw_renameBg)
                btn_add.isEnabled = false
                btn_back.isEnabled = false
            }
            
            let trash = UIAction(title: "Delete", image: UIImage(systemName: "trash"), attributes: .destructive) { [self] _ in
                let alertMessage = "Are you sure you want to delete this from Q.R. code."
                let alert = UIAlertController(title: "Delete Q.R.", message: alertMessage, preferredStyle: .actionSheet)
                
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
                    tableView.deselectRow(at: indexPath, animated: true)
                }))
                
                alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { [self] _ in
                    deleteGenerateData(product: arrGenerate)
                }))
                
                if let popoverController = alert.popoverPresentationController {
                    popoverController.sourceView = self.view
                    popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
                    popoverController.permittedArrowDirections = []
                }
                present(alert, animated: true)
            }
            
            return UIMenu(title: "", children: [share,Rename,trash])
        }
        return UIContextMenuConfiguration(identifier: "unique-ID" as NSCopying, previewProvider: nil, actionProvider: actionProvider)

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

// MARK: - TableView Cell
class TblVw_HistoryCell: UITableViewCell {
    
    @IBOutlet weak var imgVw: UIImageView!
    @IBOutlet weak var lbl_name: UILabel!
    @IBOutlet weak var lbl_date: UILabel!
}
