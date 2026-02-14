//
//  PremiumPopUpVC.swift
//  WhatsApp Web
//
//  Created by mac on 17/06/24.
//

import UIKit

import AdSupport
import GoogleMobileAds

class PremiumPopUpVC: UIViewController {
    
    // MARK: - @IBOutlet
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var lbl_seeAllFeatures: UILabel!
    
    @IBOutlet weak var vw_bg: UIView!
    
    @IBOutlet weak var btn_tryPremium: UIButton!
    @IBOutlet weak var btn_continueAds: UIButton!
    
    @IBOutlet weak var cons_bottom: NSLayoutConstraint!
    
    // MARK: - Variable
    var isTitle = ""
    private var rewardedAd: RewardedAd?
    var complitionHandler: (() -> (Void))?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        cons_bottom.constant = 0
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }
    
    // MARK: - @IBAction
    @IBAction func btn_tryPremiumTapped(_ sender: UIButton) {
        if let secondPremiumVc = self.storyboard?.instantiateViewController(withIdentifier: "SecondPremiumVC") as? SecondPremiumVC {                            secondPremiumVc.modalPresentationStyle = .fullScreen
            self.present(secondPremiumVc, animated: true)
        }
    }
    
    @IBAction func btn_continueAdsTapped(_ sender: UIButton) {
        RewardVideoAds()
        cons_bottom.constant = IpadorIphone(value: -600)
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func btn_closeTApped(_ sender: UIButton) {
        cons_bottom.constant = IpadorIphone(value: -500)
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.dismiss(animated: false)
        }
    }
}

// MARK: - Private Methods
extension PremiumPopUpVC {
    
    func setUpUI() {
        vw_bg.layer.cornerRadius = IpadorIphone(value: 16)
        vw_bg.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        btn_continueAds.layer.borderColor = UIColor.white.cgColor
        btn_continueAds.layer.borderWidth = IpadorIphone(value: 1)
        btn_continueAds.layer.cornerRadius = IpadorIphone(value: 27)
        btn_tryPremium.layer.cornerRadius = IpadorIphone(value: 27)
        
        lbl_title.text = isTitle
        
        lbl_seeAllFeatures.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(lbl_seeAllFeaturesTap)))
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: UIApplication.willEnterForegroundNotification.rawValue), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(Will_EnterForeground(_:)),
                                               name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    func RewardVideoAds() {
        Utils().showLoader(text: "Loading...")
        let REWARD = "ca-app-pub-3940256099942544/1712485313"
        let request = Request()
        RewardedAd.load(with: REWARD, request: request) { [weak self](rewardedAd, error) in
            if let error = error {
                print("Failed to load rewarded ad with error: \(error.localizedDescription)")
                DispatchQueue.main.async { [self] in
                    self?.dismiss(animated: false)
                    Utils().hideLoader()
                    self?.complitionHandler!()
                    self?.cons_bottom.constant = -600
                    UIView.animate(withDuration: 0.2) {
                        self?.view.layoutIfNeeded()
                    }
                }
                return
            }
            self?.rewardedAd = rewardedAd
            self?.rewardedAd?.fullScreenContentDelegate = self
            self?.presentRewardedVideo()
        }
    }

    func presentRewardedVideo() {
        guard let rewardedAd = rewardedAd else { return }
        rewardedAd.present(from: self) {
            _ = rewardedAd.adReward
            Utils().hideLoader()
        }
    }
    
    @objc func lbl_seeAllFeaturesTap() {
        if let secondPremiumVc = self.storyboard?.instantiateViewController(withIdentifier: "SecondPremiumVC") as? SecondPremiumVC {                            secondPremiumVc.modalPresentationStyle = .fullScreen
            self.present(secondPremiumVc, animated: true)
        }
    }
    
    @objc func Will_EnterForeground(_ notification: NSNotification) {
        Utils().hideLoader()
    }
}

//MARK: - Extention Of Reward Ads Delegate
extension PremiumPopUpVC: FullScreenContentDelegate {

    func adDidRecordImpression(_ ad: FullScreenPresentingAd) {
        print("0. impression recorded")
    }

    func adWillDismissFullScreenContent(_ ad: FullScreenPresentingAd) {
        print("2. willDimiss ad")
    }

    func adDidDismissFullScreenContent(_ ad: FullScreenPresentingAd) {
        print("3. didDimiss ad")
        cons_bottom.constant = IpadorIphone(value: -600)
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
        complitionHandler!()
    }

    func adDidRecordClick(_ ad: FullScreenPresentingAd) {
        print("4. impression click detected")
    }

    func ad(_ ad: FullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        print("5. didFailToReceiveAdWithError: \(error.localizedDescription)")
    }
}
