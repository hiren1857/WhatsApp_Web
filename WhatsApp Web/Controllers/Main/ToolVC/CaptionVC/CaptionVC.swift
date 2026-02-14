//
//  CaptionVC.swift
//  WhatsApp Web
//
//  Created by mac on 10/06/24.
//

import UIKit
import SkeletonView

class CaptionVC: UIViewController {
    
    // MARK: - @IBOutlet
    @IBOutlet weak var tblVw_caption: UITableView!
    
    // MARK: - Variable
    var arrTitleAndImg = ["Morning","Attitude","Relationship","Birthday","Engagement","Parents","Anniversary",""]
    let nativeAdManager = NativeAdManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
}

// MARK: - Private Methods
extension CaptionVC {
    
    func setUpUI() {
        navigationItem.title = "What’s Caption"
        navigationItem.largeTitleDisplayMode = .never
        
        tblVw_caption.delegate = self
        tblVw_caption.dataSource = self
    }
}

// MARK: - TableView Delegate
extension CaptionVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrTitleAndImg.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblVw_caption.dequeueReusableCell(withIdentifier: "TblVw_CaptionCell") as! TblVw_CaptionCell
        cell.imgVw_caption.image = UIImage(named: arrTitleAndImg[indexPath.row])
        cell.lbl_title.text = arrTitleAndImg[indexPath.row]
        cell.vw_cellBg.layer.cornerRadius = IpadorIphone(value: 8)
        
        
        
        if indexPath.row == 7 {
            if Constants.USERDEFAULTS.value(forKey: "isPremium") == nil {
                cell.contentView.subviews.forEach { $0.isHidden = false }
                cell.contentView.subviews.filter { $0.tag == 199 }.forEach { $0.removeFromSuperview() }
                nativeAdManager.setupNativeAd(in: self, placeholderView: cell.contentView)
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let quotesVc = storyboard?.instantiateViewController(withIdentifier: "QuotesVC") as? QuotesVC {
            switch indexPath.row {
            case 0 :
                quotesVc.fromTitle = "Moring Quotes"
                quotesVc.arrQuotes = Quotes().quotes(quoteName: "Morning")
            case 1:
                quotesVc.fromTitle = "Attitude Quotes"
                quotesVc.arrQuotes = Quotes().quotes(quoteName: "Attitude")
            case 2:
                quotesVc.fromTitle = "Relationship Quotes"
                quotesVc.arrQuotes = Quotes().quotes(quoteName: "Relationship")
            case 3:
                quotesVc.fromTitle = "Birthday Quotes"
                quotesVc.arrQuotes = Quotes().quotes(quoteName: "Birthday")
            case 4:
                quotesVc.fromTitle = "Engagement Quotes"
                quotesVc.arrQuotes = Quotes().quotes(quoteName: "Engagement")
            case 5:
                quotesVc.fromTitle = "Parents Quotes"
                quotesVc.arrQuotes = Quotes().quotes(quoteName: "Parents")
            case 6:
                quotesVc.fromTitle = "Anniversary Quotes"
                quotesVc.arrQuotes = Quotes().quotes(quoteName: "Anniversary")
            default:
                break
            }
            
            navigationController?.pushViewController(quotesVc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 7 {
            if Constants.USERDEFAULTS.value(forKey: "isPremium") == nil {
                return IpadorIphone(value: 135)
            } else {
                return 0
            }
        }
        return UITableView.automaticDimension
    }
}

// MARK: - TableView Cell
class TblVw_CaptionCell: UITableViewCell {
    
    @IBOutlet weak var imgVw_caption: UIImageView!
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var vw_cellBg: UIView!
    @IBOutlet weak var vw_nativeAd: UIView!
    @IBOutlet weak var imgVw_accessory: UIImageView!
    @IBOutlet weak var const_vwNativeAdHeight: NSLayoutConstraint!
    
}
