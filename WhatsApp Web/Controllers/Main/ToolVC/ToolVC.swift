//
//  ToolVC.swift
//  WhatsApp Web
//
//  Created by mac on 06/06/24.
//

import UIKit
import SkeletonView

class ToolVC: UIViewController {
    
    // MARK: - @IBOutlet
    @IBOutlet weak var collVw_tool: UICollectionView!
    
    // MARK: - Variable
    var arrTitleAndImage = ["Random Generator", "Text Repeater", "Text to Emoji", "", "Text to Alphabet", "What’s Caption", "Qr Generator"]
    
    var arrSaveGenerateCode = [GenerateEntity]()
    var generateCodeData = CodeGenerateData()
    let nativeAdManager = NativeAdManager()
    var isOfferViewHide = false
    
    var btn_pro = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchGenerateData()
        if let headerView = collVw_tool.supplementaryView(forElementKind: UICollectionView.elementKindSectionHeader, at: IndexPath(item: 0, section: 0)) as? HeaderView_CollTool {
            headerView.vw_offerExpire.flashInView()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.async { [self] in
            btn_pro.flash()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        btn_pro.stopFlash()
    }
    
}

// MARK: - Private Methods
extension ToolVC {
    
    func setUpUI() {
        fetchGenerateData()
        
        let btn_add = UIBarButtonItem(image: UIImage(systemName: "gear.badge"), style: .done, target: self, action: #selector(btn_addTapped))
        btn_add.tintColor = UIColor(named: "6CCD1C")
        navigationItem.rightBarButtonItem = btn_add
        
//        Constants.USERDEFAULTS.set(1, forKey: "isPremium")
        Constants.USERDEFAULTS.removeObject(forKey: "isPremium")
        
        collVw_tool.delegate = self
        collVw_tool.dataSource = self
        
//        btn_pro.addTarget(self, action: #selector(btn_proTapped), for: .touchUpInside)
//        let customBarButtonItem = UIBarButtonItem(customView: btn_pro)
//        if Constants.USERDEFAULTS.value(forKey: "isPremium") == nil {
//            navigationItem.rightBarButtonItem = customBarButtonItem
//        }
        
//        isOfferViewHide = Constants.USERDEFAULTS.bool(forKey: "isOfferViewHide")
//        if isOfferViewHide {
//            btn_pro.setBackgroundImage(UIImage(named: "btn_pro"), for: .normal)
//            btn_pro.sizeToFit()
//            btn_pro.isEnabled = true
//        } else {
//            btn_pro.setBackgroundImage(UIImage(named: ""), for: .normal)
//            btn_pro.sizeToFit()
//            btn_pro.isEnabled = false
//        }
        
//        if Constants.USERDEFAULTS.value(forKey: "isGiftVc") == nil {
//            if let giftVc = storyboard?.instantiateViewController(withIdentifier: "GiiftVC") as? GiiftVC {
//                giftVc.modalPresentationStyle = .custom
//                present(giftVc, animated: false)
//            }
//        }
        
        if Constants.USERDEFAULTS.value(forKey: "isPremium") != nil {
            arrTitleAndImage.remove(at: 3)
            collVw_tool.reloadData()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(openGiftVc(_:)), name: Notification.Name("openGiftVc"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadCollVw(_:)), name: Notification.Name("reloadCollVw"), object: nil)

    }
    
    @objc func btn_addTapped() {
        if let qrGeneratorvc = storyboard?.instantiateViewController(withIdentifier: "SettingVc") as? SettingVc {
            qrGeneratorvc.navigationItem.largeTitleDisplayMode = .never
            navigationController?.pushViewController(qrGeneratorvc, animated: true)
        }
    }
    
    func fetchGenerateData() {
        Generate_Data().fetch_GenerateCode_Data(context: self.context) { [self] arr in
            arrSaveGenerateCode = arr
        }
    }
    
    func navigate(withIdentifier identifier: String) {
        if let viewController = storyboard?.instantiateViewController(withIdentifier: identifier) {
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    @objc func btn_proTapped() {
        if let secondPremiumVc = storyboard?.instantiateViewController(withIdentifier: "SecondPremiumVC") as? SecondPremiumVC {
            secondPremiumVc.modalPresentationStyle = .fullScreen
            self.present(secondPremiumVc, animated: true)
        }
    }
    
    @objc func openGiftVc(_ notification: Notification) {
        if let giftVc = storyboard?.instantiateViewController(withIdentifier: "GiiftVC") as? GiiftVC {
            giftVc.modalPresentationStyle = .custom
            present(giftVc, animated: false)
        }
    }
    
    @objc func reloadCollVw(_ notification: Notification) {
        if Constants.USERDEFAULTS.bool(forKey: "isOfferViewHide") == true {
            collVw_tool.reloadData()
            btn_pro.setBackgroundImage(UIImage(named: "btn_pro"), for: .normal)
            btn_pro.sizeToFit()
            btn_pro.isEnabled = true
        } else {
            btn_pro.setBackgroundImage(UIImage(named: ""), for: .normal)
            btn_pro.sizeToFit()
            btn_pro.isEnabled = false
        }
    }
    
}

// MARK: - CollectionView (Delegate, DataSource)
extension ToolVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrTitleAndImage.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollVw_TollCell", for: indexPath) as! CollVw_TollCell
        cell.layer.cornerRadius = IpadorIphone(value: 12)
        cell.imageVw.image = UIImage(named: arrTitleAndImage[indexPath.row])
        cell.lbl_titles.text = arrTitleAndImage[indexPath.row]
        
        if Constants.USERDEFAULTS.value(forKey: "isPremium") == nil {
            if indexPath.row == 3 {
                cell.contentView.subviews.forEach { $0.isHidden = false }
                cell.contentView.subviews.filter { $0.tag == 99 }.forEach { $0.removeFromSuperview() }
                self.nativeAdManager.setupNativeAd(in: self, placeholderView: cell.contentView)
            } else {
                cell.contentView.subviews.forEach { $0.isHidden = false }
                cell.contentView.subviews.filter { $0.tag == 99 }.forEach { $0.removeFromSuperview() }
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        if Constants.USERDEFAULTS.value(forKey: "isPremium") == nil {
            switch indexPath.row {
            case 0:
                navigate(withIdentifier: "RandomGeneratorVC")
            case 1:
                navigate(withIdentifier: "TextRepeaterVC")
            case 2:
                navigate(withIdentifier: "TextToEmojiVC")
            case 4:
                navigate(withIdentifier: "TextToAlphabetVC")
            case 5:
                navigate(withIdentifier: "CaptionVC")
            case 6:
                if arrSaveGenerateCode.isEmpty {
                    navigate(withIdentifier: "QrGeneratorVC")
                } else {
                    navigate(withIdentifier: "HistoryVC")
                }
            default:
                break
            }
//        } else {
//            switch indexPath.row {
//            case 0:
//                navigate(withIdentifier: "RandomGeneratorVC")
//            case 1:
//                navigate(withIdentifier: "TextRepeaterVC")
//            case 2:
//                navigate(withIdentifier: "TextToEmojiVC")
//            case 3:
//                navigate(withIdentifier: "TextToAlphabetVC")
//            case 4:
//                navigate(withIdentifier: "CaptionVC")
//            case 5:
//                if arrSaveGenerateCode.isEmpty {
//                    navigate(withIdentifier: "QrGeneratorVC")
//                } else {
//                    navigate(withIdentifier: "HistoryVC")
//                }
//            default:
//                break
//            }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        if Constants.USERDEFAULTS.value(forKey: "isPremium") == nil {
            if indexPath.row == 3 {
                return CGSize(width: collectionView.bounds.width - 2 * IpadorIphone(value: 16), height: IpadorIphone(value: 135))
            }
//        }
        return CGSize(width: collectionView.bounds.width - 2 * IpadorIphone(value: 16), height: IpadorIphone(value: 68))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return IpadorIphone(value: 12)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 12, right: 0)
    }
    
//    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//        let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HeaderView_CollTool", for: indexPath) as! HeaderView_CollTool
//        cell.vw_offerExpire.layer.cornerRadius = IpadorIphone(value: 10)
//        cell.vw_timeBg.forEach {$0.layer.cornerRadius = IpadorIphone(value: 6)}
//        
//        return cell
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
//        if Constants.USERDEFAULTS.bool(forKey: "isOfferViewHide") == true {
//            return CGSize(width: collectionView.bounds.width, height: 0)
//        }
//        return CGSize(width: collectionView.bounds.width, height: IpadorIphone(value: 60))
//    }
}

// MARK: - CollectionView Cell
class CollVw_TollCell: UICollectionViewCell {
    
    @IBOutlet weak var imageVw: UIImageView!
    @IBOutlet weak var imgVw_assecory: UIImageView!
    
    @IBOutlet weak var vw_nativeAd: UIView!
    
    @IBOutlet weak var lbl_titles: UILabel!
}

// MARK: - CollectionView HeaderView
class HeaderView_CollTool: UICollectionReusableView {
    
    @IBOutlet weak var vw_offerExpire: UIView!
    @IBOutlet var vw_timeBg: [UIView]!
    
    @IBOutlet weak var lbl_hours: UILabel!
    @IBOutlet weak var lbl_seconds: UILabel!
    @IBOutlet weak var lbl_minutes: UILabel!
    
    var countdownTimer: Timer?
    var targetDate: Date?
    var isOfferViewHide = false
    var isViewAnimate = true
    var hour = "24"
    var minute = "00"
    var second = "00"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        DispatchQueue.main.async { [self] in
            self.vw_offerExpire.flashInView()
            if shouldShowCountdown() {
                startCountdown()
            }
        }
    }
    
    @IBAction func btn_vwTapped(_ sender: UIButton) {
        NotificationCenter.default.post(name: Notification.Name("openGiftVc"), object: nil)
    }
    
    func shouldShowCountdown() -> Bool {
        let userDefaults = UserDefaults.standard
        if let startDate = userDefaults.object(forKey: "CountdownStartDate") as? Date {
            let now = Date()
            let elapsedTime = now.timeIntervalSince(startDate)
            
            if elapsedTime >= 24 * 3600 {
                return false
            } else {
                targetDate = Calendar.current.date(byAdding: .second, value: Int( 24 * 3600 - elapsedTime), to: now) //24 * 3600
                return true
            }
        } else {
            userDefaults.set(Date(), forKey: "CountdownStartDate")
            targetDate = Calendar.current.date(byAdding: .hour, value: 24, to: Date())
            return true
        }
    }
    
    func startCountdown() {
        countdownTimer?.invalidate()
        countdownTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCountdown), userInfo: nil, repeats: true)
    }
    
    @objc func updateCountdown() {
        guard let targetDate = targetDate else { return }
        let now = Date()
        let remainingTime = targetDate.timeIntervalSince(now)
        
        if remainingTime <= 0 {
            countdownTimer?.invalidate()
            Constants.USERDEFAULTS.set(true, forKey: "isOfferViewHide")
            NotificationCenter.default.post(name: Notification.Name("reloadCollVw"), object: nil)
        } else {
            Constants.USERDEFAULTS.set(false, forKey: "isOfferViewHide")
            updateLabels(remainingTime: remainingTime)
            NotificationCenter.default.post(name: Notification.Name("reloadCollVw"), object: nil)
        }
    }
    
    func updateLabels(remainingTime: TimeInterval) {
        let hours = Int(remainingTime) / 3600
        let minutes = (Int(remainingTime) % 3600) / 60
        let seconds = Int(remainingTime) % 60
        
        lbl_hours.text = String(format: "%02d", hours)
        lbl_minutes.text = String(format: "%02d", minutes)
        lbl_seconds.text = String(format: "%02d", seconds)
    }
}
