//
//  NativeAdManager.swift
//  ClickToChat
//
//  Created by Apple on 05/03/24.
//

import Foundation
import GoogleMobileAds
import SkeletonView

class NativeAdManager: NSObject {

    private var nativeAdView: NativeAdView?
    private var adLoader: AdLoader?

    var mainView: UIViewController?
    var isFailed = true

    func setupNativeAd(in viewController: UIViewController, placeholderView: UIView) {
//        guard let adUnitID = Constants.USERDEFAULTS.value(forKey: "NATIVE") as? String else {
//            return
//        }

//        if Utils().isConnectedToNetwork() && !Constants.USERDEFAULTS.bool(forKey: "isShowAds") {
            guard let nibObjects = Bundle.main.loadNibNamed("NativeAdsView", owner: nil, options: nil),
                  let adView = nibObjects.first as? NativeAdView else {
                return
            }

            isFailed = true
            mainView = viewController
            setAdView(adView, in: placeholderView)
            refreshAd(adUnitID: "ca-app-pub-3940256099942544/3986624511", rootViewController: viewController)
//        }
    }

    private func setAdView(_ view: NativeAdView, in placeholderView: UIView) {
        nativeAdView = view
        nativeAdView?.isSkeletonable = true
        nativeAdView?.showAnimatedGradientSkeleton()
        nativeAdView?.frame = CGRect(x: 0, y: 0, width: placeholderView.bounds.width, height: placeholderView.bounds.height)
        nativeAdView?.tag = 99
        placeholderView.addSubview(nativeAdView!)
    }

    private func refreshAd(adUnitID: String, rootViewController: UIViewController) {
        adLoader = AdLoader(adUnitID: adUnitID, rootViewController: rootViewController, adTypes: [.native], options: nil)
        adLoader?.delegate = self
        adLoader?.load(Request())
    }
}

extension NativeAdManager: NativeAdLoaderDelegate {

    func adLoader(_ adLoader: AdLoader, didReceive nativeAd: NativeAd) {
        guard let nativeAdView = nativeAdView else { return }
        nativeAdView.hideSkeleton()
        nativeAd.delegate = self

        (nativeAdView.headlineView as? UILabel)?.text = nativeAd.headline
        nativeAdView.mediaView?.mediaContent = nativeAd.mediaContent
        (nativeAdView.bodyView as? UILabel)?.text = nativeAd.body
         nativeAdView.bodyView?.isHidden = nativeAd.body == nil

        (nativeAdView.callToActionView as? UIButton)?.setTitle("Open Now", for: .normal)
         nativeAdView.callToActionView?.isHidden = nativeAd.callToAction == nil

        (nativeAdView.iconView as? UIImageView)?.image = nativeAd.icon?.image
         nativeAdView.iconView?.isHidden = nativeAd.icon == nil

         nativeAdView.callToActionView?.isUserInteractionEnabled = false

         (nativeAdView.storeView as? UILabel)?.text = nativeAd.store?.uppercased()
         nativeAdView.storeView?.isHidden = nativeAd.store == nil

         (nativeAdView.priceView as? UILabel)?.text = nativeAd.price
         nativeAdView.priceView?.isHidden = nativeAd.price == nil

         nativeAdView.nativeAd = nativeAd
    }

    func adLoader(_ adLoader: AdLoader, didFailToReceiveAdWithError error: Error) {
        // Handle ad loading failure
        if isFailed{
            isFailed = false
            guard let adUnitID = Constants.USERDEFAULTS.value(forKey: "NATIVE2") as? String else {
                return
            }
            refreshAd(adUnitID: adUnitID, rootViewController: mainView!)
        }
    }
}

extension NativeAdManager: NativeAdDelegate {
    // Implement native ad delegate methods as needed
}


