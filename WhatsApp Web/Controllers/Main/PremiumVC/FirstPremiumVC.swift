//
//  FirstPremiumVC.swift
//  WhatsApp Web
//
//  Created by mac on 14/06/24.
//

import UIKit

class FirstPremiumVC: UIViewController {
    
    // MARK: - @IBOutlet
    @IBOutlet weak var collVw_rating: UICollectionView!
    @IBOutlet weak var btn_continue: UIButton!
    @IBOutlet weak var btn_close: UIButton!
    @IBOutlet weak var vw_bottom: UIView!
    
    // MARK: - Variable
    var arrTitle = ["Absolutely love this app!💥💖","Super handy app!🙌 🤗","Ultimate experience 👍 😋","Finally found an app that does it all!✨👌","The premium offer exceeded my expectations!✌"]
    var arrSubTitle = ["The Random Generator is incredibly useful for generating creative content, and the other tools are amazing. Highly recommend!","Incredible value packed into one app! this app has everything I need. The WhatsApp web is especially useful for my work. thank so much.","The premium features deliver results that are far superior to anything I've seen in other apps.","The all Generator sparks my creativity, and  Plus, removing ads makes the experience seamless.","Not only do I get access to all the tools without any limitations, but the results are consistently excellent."]
    
    var timer: Timer?
    var currentIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
    
    @IBAction func btn_continueTapped(_ sender: UIButton) {
        
    }
    
    @IBAction func btn_closeTapped(_ sender: UIButton) {
        UserDefaults.standard.set(1, forKey: "startUp")
        Utils().setupHome()
    }
}

// MARK: - Private Methods
extension FirstPremiumVC {
    
    func setUpUI() {
        btn_continue.layer.cornerRadius = IpadorIphone(value: 25)
        
        collVw_rating.delegate = self
        collVw_rating.dataSource = self
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            self.btn_close.isHidden = false
        }
        
        timer = Timer.scheduledTimer(timeInterval: 2.5, target: self, selector: #selector(autoScrollOfCollVw), userInfo: nil, repeats: true)
    }
    
    @objc func autoScrollOfCollVw() {
        let nextIndex = (currentIndex + 1) % arrTitle.count
        let indexPath = IndexPath(item: nextIndex, section: 0)
        collVw_rating.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        currentIndex = nextIndex
    }
}

// MARK: - CollectionView (Delegate, DataSource)
extension FirstPremiumVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrTitle.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collVw_rating.dequeueReusableCell(withReuseIdentifier: "CollVw_RatingCell",for: indexPath) as! CollVw_RatingCell
        cell.lbl_title.text = arrTitle[indexPath.row]
        cell.lbl_subTitle.text = arrSubTitle[indexPath.row]
        cell.vw_cellBg.layer.cornerRadius = IpadorIphone(value: 12)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
    }
}

// MARK: - CollectionView Cell
class CollVw_RatingCell: UICollectionViewCell {
    
    @IBOutlet weak var vw_cellBg: UIView!
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var lbl_subTitle: UILabel!
}
