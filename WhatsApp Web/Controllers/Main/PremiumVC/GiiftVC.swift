//
//  GiiftVC.swift
//  WhatsApp Web
//
//  Created by mac on 17/06/24.
//

import UIKit
import Lottie

class GiiftVC: UIViewController {
    
    // MARK: - @IBOutlet
    @IBOutlet weak var btn_continue: UIButton!
    
    @IBOutlet var vw_time: [UIView]!
    @IBOutlet weak var vw_giftLotie: UIView!
    @IBOutlet weak var vw_bg: UIView!
    @IBOutlet weak var vw_blur: UIView!
    
    @IBOutlet weak var lbl_hours: UILabel!
    @IBOutlet weak var lbl_minutes: UILabel!
    @IBOutlet weak var lbl_seconds: UILabel!
    
    @IBOutlet weak var cons_bottom: NSLayoutConstraint!
    
    // MARK: - Variable
    var countdownTimer: Timer?
    var targetDate: Date?
    var animationView: LottieAnimationView?
    
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
    @IBAction func btn_countinueTapped(_ sender: UIButton) {
        
    }
    
    @IBAction func btn_continueFreeTapped(_ sender: UIButton) {
        Constants.USERDEFAULTS.set(1, forKey: "isGiftVc")
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
extension GiiftVC {
    
    func setUpUI() {
        vw_time.forEach { $0.layer.borderColor = UIColor.link.cgColor }
        vw_time.forEach { $0.layer.borderWidth = IpadorIphone(value: 1) }
        vw_time.forEach { $0.layer.cornerRadius = IpadorIphone(value: 6) }
        btn_continue.layer.cornerRadius = IpadorIphone(value: 25)
        vw_bg.layer.cornerRadius = IpadorIphone(value: 16)
        vw_bg.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        vw_blur.addBlurToView()
        
        if shouldShowCountdown() {
            startCountdown()
        }
        
        DispatchQueue.main.async { [self] in
            animationView = .init(name: "GiftAnimation")
            animationView?.frame = vw_giftLotie.bounds
            animationView?.contentMode = .scaleAspectFill
            animationView?.loopMode = .loop
            animationView?.animationSpeed = 1
            animationView?.play()
            vw_giftLotie.addSubview(animationView!)
        }
    }
    
    func shouldShowCountdown() -> Bool {
        let userDefaults = UserDefaults.standard
        if let startDate = userDefaults.object(forKey: "CountdownStartDate") as? Date {
            let now = Date()
            let elapsedTime = now.timeIntervalSince(startDate)
            
            if elapsedTime >= 24 * 3600 {
                return false
            } else {
                targetDate = Calendar.current.date(byAdding: .second, value: Int(24 * 3600 - elapsedTime), to: now)
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
        } else {
            updateLabels(remainingTime: remainingTime)
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
