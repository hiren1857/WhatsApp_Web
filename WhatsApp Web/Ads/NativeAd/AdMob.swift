//
//  AdMob.swift
//  Phone Tracker
//
//  Created by Ishwar Hingu on 19/07/22.
//

import Foundation
import GoogleMobileAds
import ProgressHUD

class AdMob: NSObject, FullScreenContentDelegate {

    static var sharedData_: AdMob? = nil

    var interstitial: InterstitialAd?
    var adUnitID = ""

    class func sharedInstance() -> AdMob? {
        let lockQueue = DispatchQueue(label: "self")
        lockQueue.sync {
            if sharedData_ == nil {
                sharedData_ = AdMob()
            }
        }
        return sharedData_
    }

    override init() {
        super.init()
    }

    func createAndLoadInterstitial(intID: String) -> InterstitialAd? {

        if Constants.USERDEFAULTS.value(forKey: "isShowAds") == nil && Utils().isConnectedToNetwork() {
            adUnitID = intID
            let request = Request()
            InterstitialAd.load(with:self.adUnitID,request: request,
                completionHandler: { [self] ad, error in
                ProgressHUD.dismiss()
                     if error != nil {
                         if let adUnitID = Constants.USERDEFAULTS.string(forKey: "INTERTIALS2"){
                             _ = AdMob.sharedInstance()?.createAndLoadInterstitial(intID: adUnitID)
                         }
                        return
                     }
                     self.interstitial = ad
                     self.interstitial?.fullScreenContentDelegate = self
                }
            )
            return interstitial
        }
        return nil
    }

    func loadInste(_ vc: UIViewController?) {

        var adsCount : Int = 1
        if Constants.USERDEFAULTS.value(forKey: "adsCount") != nil {
            adsCount = Constants.USERDEFAULTS.value(forKey: "adsCount") as! Int
            adsCount += 1
            Constants.USERDEFAULTS.set(adsCount, forKey: "adsCount")
        }
        else{
            Constants.USERDEFAULTS.set(adsCount, forKey: "adsCount")
        }

        let Inter_In_Click = Constants.USERDEFAULTS.value(forKey: "ads_counter") ?? 1
        if let intID = Constants.USERDEFAULTS.string(forKey: "INTERTIALS") {
            interstitial = self.createAndLoadInterstitial(intID: intID)
        }
        if interstitial != nil && adsCount >= Inter_In_Click as! Int {
            Constants.USERDEFAULTS.removeObject(forKey: "adsCount")
            if var topController = Constants.ROOTVIEW  {
                while let presentedViewController = topController.presentedViewController {
                    topController = presentedViewController
                }
                interstitial?.present(from: topController)
            }
        }
    }

    /// Tells the delegate that an impression has been recorded for the ad.
    func adDidRecordImpression(_ ad: FullScreenPresentingAd) {
        print("0. impression recorded")
    }

    /// Tells the delegate that the ad presented full screen content.
    func adWillPresentFullScreenContent(_ ad: FullScreenPresentingAd) {
        print("1. ad presented")
    }

    /// Tells the delegate that the ad will dismiss full screen content.
    func adWillDismissFullScreenContent(_ ad: FullScreenPresentingAd) {
        print("2. willDimiss ad")
    }

    /// Tells the delegate that the ad dismissed full screen content.
    func adDidDismissFullScreenContent(_ ad: FullScreenPresentingAd) {
        print("3. didDimiss ad")
        if let intID = Constants.USERDEFAULTS.string(forKey: "INTERTIALS") {
            interstitial = self.createAndLoadInterstitial(intID: intID)
        }
    }

    /// Tells the delegate that a click has been recorded for the ad.
    func adDidRecordClick(_ ad: FullScreenPresentingAd) {
        print("4. impression click detected")
    }

    /// Tells the delegate that the ad failed to present full screen content.
    func ad(_ ad: FullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        print("5. didFailToReceiveAdWithError: \(error.localizedDescription)")
        interstitial = nil
        if let intID = Constants.USERDEFAULTS.string(forKey: "INTERTIALS") {
            interstitial = self.createAndLoadInterstitial(intID: intID)
        }
    }
}
