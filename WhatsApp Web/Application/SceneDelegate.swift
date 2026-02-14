//
//  SceneDelegate.swift
//  WhatsApp Web
//
//  Created by mac on 05/06/24.
//

import UIKit
import GoogleMobileAds

class SceneDelegate: UIResponder, UIWindowSceneDelegate, FullScreenContentDelegate {

    var window: UIWindow?
    var appOpenAd: AppOpenAd?
    var loadTime = Date()
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
        
        window?.overrideUserInterfaceStyle = .light
       
        if UserDefaults.standard.value(forKey: "startUp") == nil {
            makeRootVC(storyBoardName: "Onboarding", vcName: "OnboardingVC")
        } else {
            setupHome()
            if Constants.USERDEFAULTS.value(forKey: "isShowAds") == nil {
                Utils().showLoader(text: "Loading ads...")
                Constants.USERDEFAULTS.removeObject(forKey: "openCount")
                self.tryToPresentAd(openID: "ca-app-pub-3940256099942544/5575463023")
                MobileAds.shared.start(completionHandler: nil)
            }
        }
      
        Constants.USERDEFAULTS.set(3, forKey: "ads_counter")
        Constants.USERDEFAULTS.set("ca-app-pub-3940256099942544/5575463023", forKey: "OPEN")
        Constants.USERDEFAULTS.set("ca-app-pub-3940256099942544/4411468910", forKey: "INTERTIALS")
        Constants.USERDEFAULTS.set("ca-app-pub-3940256099942544/6978759866", forKey: "INTERTIALS2")
        Constants.USERDEFAULTS.set("ca-app-pub-3940256099942544/1712485313", forKey: "REWARD")
        Constants.USERDEFAULTS.set("ca-app-pub-3940256099942544/3986624511", forKey: "NATIVE")
        Constants.USERDEFAULTS.set("ca-app-pub-3940256099942544/2521693316", forKey: "NATIVE2")
        Constants.USERDEFAULTS.set("ca-app-pub-3940256099942544/2435281174", forKey: "BANNER")
    }
    
    func setupHome() {
        guard let window = self.window else {
            return
        }
        let rootViewController = Constants.storyBoard.instantiateViewController(withIdentifier: "TabBarController") as? TabBarController
        let rootNavigationController = UINavigationController(rootViewController: rootViewController!)
        rootNavigationController.isNavigationBarHidden = true
        window.rootViewController = rootNavigationController
        window.makeKeyAndVisible()
        let options: UIView.AnimationOptions = .transitionCrossDissolve
        UIView.transition(with: window, duration: 0.3, options: options, animations: {}, completion:
        { completed in
        })
    }
    
    func makeRootVC(storyBoardName : String, vcName : String) {
        let mainStoryBoard = UIStoryboard(name: storyBoardName, bundle: nil)
        let viewController = mainStoryBoard.instantiateViewController(withIdentifier: vcName)
        self.window?.rootViewController = viewController
        self.window?.makeKeyAndVisible()
    }
    
    func requestAppOpenAd(openID: String) {
        let request = Request()
        AppOpenAd.load(with: openID,
                          request: request,
                          completionHandler: { (appOpenAdIn, error) in
            if let error = error {
                print("Failed to load app open ad: \(error.localizedDescription)")
                return
            }
            self.appOpenAd = appOpenAdIn
            self.appOpenAd?.fullScreenContentDelegate = self
            self.loadTime = Date()
            self.tryToPresentAd(openID: openID)
            Utils().hideLoader()
        })
    }

    func tryToPresentAd(openID: String) {
       if Utils().isConnectedToNetwork() {
            if let gOpenAd = self.appOpenAd, let rwc = self.window?.rootViewController, wasLoadTimeLessThanNHoursAgo(thresholdN: 4) {
                gOpenAd.present(from: rwc)
            } else {
                self.requestAppOpenAd(openID: openID)
            }
        } else {
            Utils().hideLoader()
        }
    }

    func wasLoadTimeLessThanNHoursAgo(thresholdN: Int) -> Bool {
        let now = Date()
        let timeIntervalBetweenNowAndLoadTime = now.timeIntervalSince(self.loadTime)
        let secondsPerHour = 3600.0
        let intervalInHours = timeIntervalBetweenNowAndLoadTime / secondsPerHour
        return intervalInHours < Double(thresholdN)
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.

        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }


}

