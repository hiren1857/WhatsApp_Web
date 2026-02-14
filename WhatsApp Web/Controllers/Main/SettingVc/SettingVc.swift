//
//  SettingVc.swift
//  WhatsApp Web
//
//  Created by mac on 24/06/24.
//

import UIKit
import StoreKit
import MessageUI
import SafariServices
import GoogleMobileAds

class SettingVc: UIViewController, MFMailComposeViewControllerDelegate {
    
    // MARK: - @IBOutlet
    @IBOutlet weak var adsView: BannerView!
    @IBOutlet weak var tblVw_setting: UITableView!
    
    // MARK: - Variable
    var arrImage = [["RateUs","ShareApp","Help","MoreApp"],["PrivacyPolicy","TermsofUse"]] // [""],
    var arrTitle = [["Rate Us","Share App","Help","More App"],["Privacy Policy","Terms of Use"]] // [""],
    var arrHeaderTitle = ["OTHER","LEGAL"] // "",

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
}

// MARK: - Private Methods
extension SettingVc {
    
    func setUpUI() {
        navigationItem.title = "Settings"
        setupTable()
        setupBanner(GADAdSize: AdSizeFullBanner, Banner: adsView)
    }
    
    func setupBanner(GADAdSize: AdSize , Banner: BannerView) {
        if Utils().isConnectedToNetwork() && Constants.USERDEFAULTS.value(forKey: "isShowAds") == nil {
            Banner.adUnitID = Constants.USERDEFAULTS.string(forKey: "BANNER")
            Banner.adSize = GADAdSize
            Banner.rootViewController = self
            Banner.load(Request())
        }
    }

    
    func setupTable()  {
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        let customView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: IpadorIphone(value: 50)))
        customView.backgroundColor = .clear
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: IpadorIphone(value: 50)))
        label.text = "Version  \(appVersion!)"
        label.textAlignment = .center
        label.textColor = .lightGray
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: IpadorIphone(value: 16), weight: .regular)
        customView.addSubview(label)
        tblVw_setting.tableFooterView = customView
        tblVw_setting.delegate = self
        tblVw_setting.dataSource = self
    }
}

// MARK: - TableView (Delegate, DataSource)
extension SettingVc: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return arrTitle.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrTitle[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        if indexPath.section == 0 {
//            let cell = tblVw_setting.dequeueReusableCell(withIdentifier: "TblVw_PremiumCardCell") as! TblVw_PremiumCardCell
//            
//            if Constants.USERDEFAULTS.value(forKey: "isPremium") == nil {
//                cell.imgVw_premiumCard.image = UIImage(named: "PremiumCardGetPro")
//            } else {
//                cell.imgVw_premiumCard.image = UIImage(named: "PremiumCardActivated")
//            }
//            return cell
//        }
        
        let cell = tblVw_setting.dequeueReusableCell(withIdentifier: "TblVw_SettingCell") as! TblVw_SettingCell
        cell.imgVw.image = UIImage(named: arrImage[indexPath.section][indexPath.row])
        cell.lbl_title.text = arrTitle[indexPath.section][indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
 
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                SKStoreReviewController.requestReview()
            case 1:
                let text = "Hey! Download this interesting Whatsapp Web: Whatsapp Web app from the App Store Now!\n\n"
                let text1 = "LINK here!!\n\n"
                let url = URL(string: "https.apps.apple.com")!

                let activityViewController =
                    UIActivityViewController(activityItems: [text,text1,url], applicationActivities: nil)
                if(UIDevice.current.userInterfaceIdiom == .pad) {
                    
                  let nav = UINavigationController(rootViewController: activityViewController)
                  nav.modalPresentationStyle = UIModalPresentationStyle.popover
                  let popover = nav.popoverPresentationController as UIPopoverPresentationController?
                  activityViewController.preferredContentSize = CGSize(width: 500, height: 600)
                  popover!.sourceView = self.view
                  popover!.sourceRect = CGRect(x: 100, y: 100, width: 0, height: 0)
                  self.present(nav, animated: true, completion: nil)
                } else {
                    present(activityViewController, animated: true)
                }
            case 2:
                
                if MFMailComposeViewController.canSendMail() {
                    let mail = MFMailComposeViewController()
                    mail.mailComposeDelegate = self
                    mail.setSubject("Feedback for Whatsapp Web iOS")
                    mail.setToRecipients(["devjogisoftech@gmail.com"])
                    mail.setMessageBody("body", isHTML: false)
                    present(mail, animated: true)
                } else {
                    Utils().showDialouge("Mail Error", "Your phone does not have Apple's Mail app installed.", view: self)
                }

            case 3:
                break
//                if let url = URL(string: "https://apps.apple.com/developer/sanket-shankar/id1184303147"),
//                    UIApplication.shared.canOpenURL(url) {
//                    UIApplication.shared.open(url, options: [:]) { (opened) in
//                        if(opened) {
//                            print("App Store Opened")
//                        }
//                    }
//                }

            default:  break
            }
            
        } else {
            switch indexPath.row {
            case 0:
                if let url = URL(string: Constants.PRIVACY) {
                    let controller = SFSafariViewController(url: url)
                    controller.delegate = self
                    present(controller, animated: true, completion: nil)
                }
            case 1:
                if let url = URL(string: Constants.TERMS) {
                    let controller = SFSafariViewController(url: url)
                    controller.delegate = self
                    present(controller, animated: true, completion: nil)
                }
            default:
                print(indexPath.row)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        if section == 0 {
//            return 0
//        }
        return IpadorIphone(value: 40)
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerview = UIView.init(frame: CGRect(x: 0, y: 0, width: self.tblVw_setting.frame.width , height: self.IpadorIphone(value: 40)))
        let lbl_Heading = UILabel(frame: .init(x: IpadorIphone(value: 10), y: IpadorIphone(value: 5), width: headerview.bounds.width, height: self.IpadorIphone(value: 40)))
        lbl_Heading.text = self.arrHeaderTitle[section]
        lbl_Heading.textColor = UIColor(hex: "#8E8E9E")
        lbl_Heading.textAlignment = .left
        lbl_Heading.font  = UIFont.systemFont(ofSize: self.IpadorIphone(value: 16) , weight: .regular)

        headerview.addSubview(lbl_Heading)
        return headerview
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }

}
extension SettingVc: SFSafariViewControllerDelegate{
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
}

// MARK: - TableView Setting Cell
class TblVw_SettingCell: UITableViewCell {
    
    @IBOutlet weak var imgVw: UIImageView!
    @IBOutlet weak var lbl_title: UILabel!
}

// MARK: - TableView PremiumCard Cell
class TblVw_PremiumCardCell: UITableViewCell {
    
    @IBOutlet weak var imgVw_premiumCard: UIImageView!
}
