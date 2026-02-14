//
//  QrGeneratorVC.swift
//  WhatsApp Web
//
//  Created by mac on 11/06/24.
//

import UIKit
import SkeletonView

class QrGeneratorVC: UIViewController {
    
    // MARK: - @IBOutlet
    @IBOutlet weak var tblVw_qrGenerate: UITableView!
    
    @IBOutlet weak var vw_nativeAd: UIView!
    
    @IBOutlet weak var const_vwNativeAdHeight: NSLayoutConstraint!
    
    // MARK: - Variables
    var arrTitle = [["Barcode"],["URL","Phone Number","SMS","Email"],["App store","Instagram Profile","Instagram Post","Facebook Profile","Facebook Post","Twitter Profile","Twitter Post"]]
    var arrEnterTitle = [["Enter Product ID:"],["Enter URL:","Enter Phone Number:","Enter Phone Number:","Enter Email:"],["Enter App URL:","Enter Instagram Username:","Enter Instagram Post URL:","Enter Facebook Profile URL:","Enter Facebook Post URL:","Enter Twitter Profile URL:","Enter Twitter Post URL:"]]
    var arrSectionTitle = ["Create Barcode","Create Qr Code",""]
    
    var arrSaveGenerateCode = [GenerateEntity]()
    var btn_back = UIBarButtonItem()
    let nativeAdManager = NativeAdManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchGenerateData()
    }
}

// MARK: - Private Methods
extension QrGeneratorVC {
    
    func setUpUI() {
        navigationItem.title = "Choose Code Type"
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.hidesBackButton = true
        
        fetchGenerateData()
        
        btn_back = UIBarButtonItem(image: UIImage(named: "BackIcon"), style: .done, target: self, action: #selector(btn_backTapped))
        btn_back.imageInsets = UIEdgeInsets(top: 0, left: -8, bottom: 0, right: 0)
        navigationItem.leftBarButtonItem = btn_back
        
        tblVw_qrGenerate.delegate = self
        tblVw_qrGenerate.dataSource = self
        
        if Constants.USERDEFAULTS.value(forKey: "isPremium") == nil {
            const_vwNativeAdHeight.constant = IpadorIphone(value: 135)
            vw_nativeAd.layer.cornerRadius = IpadorIphone(value: 8)
            self.nativeAdManager.setupNativeAd(in: self, placeholderView: self.vw_nativeAd)
            vw_nativeAd.isHidden = false
        } else {
            const_vwNativeAdHeight.constant = 0
            vw_nativeAd.isHidden = true
        }
    }
    
    func fetchGenerateData() {
        Generate_Data().fetch_GenerateCode_Data(context: self.context) { arrGenerateCode in
            self.arrSaveGenerateCode = arrGenerateCode.reversed()
        }
    }
    
    func navigateToAddDetail(isTitle: String, isEnterTitle: String) {
        if let addCodDetailVc = storyboard?.instantiateViewController(withIdentifier: "AddCodeDetailVC") as? AddCodeDetailVC {
            addCodDetailVc.isFromTitle = isTitle
            addCodDetailVc.isEnterTitle = isEnterTitle
            navigationController?.pushViewController(addCodDetailVc, animated: true)
        }
    }
    
    private func handleSectionOneSelection(_ row: Int, title: String, enterTitle: String, isPremium: Bool) {
//        switch row {
//        case 0:
//            navigateToAddDetail(isTitle: title, isEnterTitle: enterTitle)
//        case 1, 2, 3:
//            if !isPremium {
//                if let secondPremiumVc = storyboard?.instantiateViewController(withIdentifier: "SecondPremiumVC") as? SecondPremiumVC {
//                    secondPremiumVc.modalPresentationStyle = .fullScreen
//                    present(secondPremiumVc, animated: true)
//                }
//            } else {
                navigateToAddDetail(isTitle: title, isEnterTitle: enterTitle)
//            }
//        default:
//            break
//        }
    }
    
    @objc func btn_backTapped() {
        if arrSaveGenerateCode.isEmpty {
            if let navigationController = self.navigationController {
                for viewController in navigationController.viewControllers {
                    if viewController is ToolVC {
                        navigationController.popToViewController(viewController, animated: true)
                        break
                    }
                }
            }
        } else {
            if let navigationController = self.navigationController {
                for viewController in navigationController.viewControllers {
                    if viewController is HistoryVC {
                        navigationController.popToViewController(viewController, animated: true)
                        break
                    }
                }
            }
        }
    }
}

// MARK: - TableView (Delegate, DataSource)
extension QrGeneratorVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return arrTitle.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrTitle[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblVw_qrGenerate.dequeueReusableCell(withIdentifier: "tblVw_QrGenerateCell") as! tblVw_QrGenerateCell
        cell.imgVw.image = UIImage(named: arrTitle[indexPath.section][indexPath.row])
        cell.lbl_title.text = arrTitle[indexPath.section][indexPath.row]
        cell.imgVw_premium.isHidden = true
        
//        if Constants.USERDEFAULTS.value(forKey: "isPremium") == nil {
//            if indexPath.section == 1 {
//                if indexPath.row == 1 || indexPath.row == 2 || indexPath.row == 3 {
//                    cell.imgVw_premium.isHidden = false
//                }
//            } 
//        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let title = arrTitle[indexPath.section][indexPath.row]
        let enterTitle = arrEnterTitle[indexPath.section][indexPath.row]
        let isPremium = Constants.USERDEFAULTS.value(forKey: "isPremium") != nil
        
        if indexPath.section == 0 {
            navigateToAddDetail(isTitle: title, isEnterTitle: enterTitle)
        } else if indexPath.section == 1 {
            handleSectionOneSelection(indexPath.row, title: title, enterTitle: enterTitle, isPremium: isPremium)
        } else if indexPath.section == 2 {
            navigateToAddDetail(isTitle: title, isEnterTitle: enterTitle)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 2 {
            return 0
        } else {
            return IpadorIphone(value: 30)
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.frame = CGRect(x: 0, y: 0, width: tableView.bounds.width, height: IpadorIphone(value: 30))
        headerView.backgroundColor = .clear
        
        let label = UILabel()
        label.frame = CGRect(x: 0, y: IpadorIphone(value: 5), width: headerView.bounds.width, height: IpadorIphone(value: 20))
        label.font = .systemFont(ofSize: IpadorIphone(value: 15), weight: .medium)
        label.clipsToBounds = true
        label.textColor = UIColor(hex: "#AEAEB2")
        label.textAlignment = .left
        label.text = arrSectionTitle[section]
        headerView.addSubview(label)
        
        return headerView
    }
}

// MARK: - TableView Cell
class tblVw_QrGenerateCell: UITableViewCell {
    
    @IBOutlet weak var imgVw: UIImageView!
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var imgVw_premium: UIImageView!
    @IBOutlet weak var vw_nativeAd: UIView!
    @IBOutlet weak var const_vwNativeAdHeight: NSLayoutConstraint!
}
