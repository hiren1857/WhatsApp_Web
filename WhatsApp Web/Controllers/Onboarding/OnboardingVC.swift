//
//  OnboardingVC.swift
//  WhatsApp Web
//
//  Created by mac on 05/06/24.
//

import UIKit
import StoreKit

class OnboardingVC: UIViewController {
    
    // MARK: - @IBOutlet
    @IBOutlet var vw_pageController: [UIView]!
    
    @IBOutlet weak var stackVw_pageController: UIStackView!
    @IBOutlet weak var collVw_onboarding: UICollectionView!
    @IBOutlet weak var btn_next: UIButton!
    
    // MARK: - Variable
    var arrImage = ["RandomGenerator","TextRepeater","GenerateQR&Barcode","DualWhatsApp","SupportustoGrow"]
    var arrTitle = ["Random Generator","Text Repeater","Generate QR & Barcode","Dual WhatsApp","Support us to Grow"]
    var arrSubTitle = ["Stop typing yourself and garb the power of Random Generator!","Harness the Text Repeater Feature to Multiply Your Text in Seconds!","Create customised barcodes & \n QR codes.","Two WhatsApps, One Phone. Organize Communication Easily!","Show appreciation to the share by leaving a review!"]
    var arrSubTitleiPad = ["Stop typing yourself and garb the power of Random Generator!","Harness the Text Repeater Feature to Multiply Your Text in Seconds!","Create customised barcodes & QR codes.","Two WhatsApps, One Phone. Organize Communication Easily!","Show appreciation to the share by leaving a review!"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
    
    // MARK: - @IBAction
    @IBAction func btn_nextTapped(_ sender: UIButton) {
        let cellWidth = collVw_onboarding.frame.width
        let currentOffset = collVw_onboarding.contentOffset
        let nextIndex = Int(currentOffset.x / cellWidth) + 1
        
        if nextIndex > 4 {
            Utils().showLoader(text: "Loading...")
            SKStoreReviewController.requestReview()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [self] in
                openPremiumPage()
            }
            return
        }
        
        let newOffset = CGPoint(x: CGFloat(nextIndex) * cellWidth, y: currentOffset.y)
        collVw_onboarding.setContentOffset(newOffset, animated: true)
    }
}

// MARK: - Extension
extension OnboardingVC {
    
    func setUpUI() {
        for vw in vw_pageController {
            vw.layer.cornerRadius = IpadorIphone(value: 2)
        }
        
        btn_next.layer.cornerRadius = IpadorIphone(value: 25)
    }
    
    func openPremiumPage() {
        collVw_onboarding.isHidden = true
        let storyBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
        //        if let firstPremiumVc = storyBoard.instantiateViewController(withIdentifier: "FirstPremiumVC") as? FirstPremiumVC {
        //            firstPremiumVc.modalPresentationStyle = .fullScreen
        //            present(firstPremiumVc, animated: true)
        //        }
     
            UserDefaults.standard.set(1, forKey: "startUp")
            Utils().hideLoader()
            if let qrGeneratorvc = storyBoard.instantiateViewController(withIdentifier: "TabBarController") as? TabBarController {
                navigationController?.pushViewController(qrGeneratorvc, animated: true)
            }
    }
}


// MARK: - CollectionView (Delegate, DataSource)
extension OnboardingVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrImage.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collVw_onboarding.dequeueReusableCell(withReuseIdentifier: "CollVw_OnboardingCell", for: indexPath) as! CollVw_OnboardingCell
        cell.imgVw.image = UIImage(named: arrImage[indexPath.row])
        cell.lbl_title.text = arrTitle[indexPath.row]
        cell.lbl_subTitle.text = arrSubTitle[indexPath.row]
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            cell.lbl_subTitle.text = arrSubTitleiPad[indexPath.row]
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentContentOffsetX = scrollView.contentOffset.x
        let scroll = currentContentOffsetX / view.frame.width
        let nextIndex = Int(round(scroll))
        
        for (index, page) in vw_pageController.enumerated() {
            page.backgroundColor = (index == nextIndex) ? UIColor(named: "6CCD1C") : .white
        }
        
        if nextIndex == 4 {
            stackVw_pageController.isHidden = true
        } else {
            stackVw_pageController.isHidden = false
        }
        
        if scrollView.contentOffset.x >= (view.frame.width * 4) {
            collVw_onboarding.isScrollEnabled = false
        }
    }
}


// MARK: - CollectionView Cell
class CollVw_OnboardingCell: UICollectionViewCell {
    
    @IBOutlet weak var imgVw: UIImageView!
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var lbl_subTitle: UILabel!
    
}


