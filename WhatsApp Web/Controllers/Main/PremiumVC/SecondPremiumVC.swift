//
//  SecondPremiumVC.swift
//  WhatsApp Web
//
//  Created by mac on 15/06/24.
//

import UIKit

class SecondPremiumVC: UIViewController {
    
    // MARK: - @IBOutlet
    @IBOutlet weak var collVw_pricing: UICollectionView!
    
    @IBOutlet weak var btn_close: UIButton!
    @IBOutlet weak var btn_countinue: UIButton!
    
    @IBOutlet weak var vw_bottom: UIView!
    @IBOutlet var vw_rating: [UIView]!
    
    // MARK: - Variable
    var arrDay = ["Weekly","Monthly","Yearly"]
    var arrPrice = ["₹199.00","₹449.00","₹1,999.00"]
    var arrPriceAndDay = ["₹199.00/Week","₹124.75/Week","₹38.32/Week"]
    var arrImgOffer = ["","BestOffer","Popular"]
    
    var selectedIndex = 2
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.async { [self] in
            btn_countinue.flash()
            btn_countinue.playBounceAnimation()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        btn_countinue.stopFlash()
        btn_countinue.stopBounceAnimation()
    }
    
    @IBAction func btn_closeTapped(_ sender: UIButton) {
        dismiss(animated: true)
    }
}

// MARK: - Private Methods
extension SecondPremiumVC {
    
    func setUpUI() {
        setupCollection()
        
        vw_rating.forEach { $0.layer.cornerRadius = IpadorIphone(value: 12) }
        btn_countinue.layer.cornerRadius = IpadorIphone(value: 25)
        vw_bottom.layer.cornerRadius = IpadorIphone(value: 16)
        vw_bottom.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        DispatchQueue.main.async { [self] in
            vw_bottom.layer.shadowColor = UIColor.systemGray.withAlphaComponent(0.5).cgColor
            vw_bottom.layer.shadowOpacity = 0.5
            vw_bottom.layer.shadowRadius = 3
            vw_bottom.layer.shadowOffset = CGSize(width: 0, height: -3)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            self.btn_close.isHidden = false
        }
    }
    
    func setupCollection() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            var height = CGFloat()
            var width = CGFloat()
            
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
            
            if UIDevice.current.userInterfaceIdiom == .pad {
                layout.minimumLineSpacing = 18
                layout.minimumInteritemSpacing = 18
                layout.sectionInset = UIEdgeInsets(top: 0, left: 18, bottom: 0, right: 18)
                
                height = 280
                width = (self.view.bounds.width - layout.sectionInset.left - layout.sectionInset.right - (2 * layout.minimumInteritemSpacing)) / 3
            } else {
                layout.minimumLineSpacing = 12
                layout.minimumInteritemSpacing = 12
                layout.sectionInset = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
                
                width = (self.view.bounds.width - layout.sectionInset.left - layout.sectionInset.right - (2 * layout.minimumInteritemSpacing)) / 3
                height = 160
            }
            
            let size = CGSize(width: width, height: height)
            layout.itemSize = size
            
            self.collVw_pricing.collectionViewLayout = layout
            self.collVw_pricing.dataSource = self
            self.collVw_pricing.delegate = self
        }
    }
}

// MARK: - CollectionView (Delegate, DataSource)
extension SecondPremiumVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrDay.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collVw_pricing.dequeueReusableCell(withReuseIdentifier: "CollVw_PricingCell", for: indexPath) as! CollVw_PricingCell
        cell.lbl_day.text = arrDay[indexPath.row]
        cell.lbl_price.text = arrPrice[indexPath.row]
        cell.lbl_priceAndDay.text = arrPriceAndDay[indexPath.row]
        cell.imgVw_offer.image = UIImage(named: arrImgOffer[indexPath.row])
        
        cell.vw_cellTrialBg.backgroundColor = .clear
        cell.vw_cellOfferBg.backgroundColor = .secondarySystemBackground
        cell.lbl_trial.isHidden = true
        cell.vw_cellOfferBg.layer.cornerRadius = IpadorIphone(value: 16)
        cell.vw_cellTrialBg.layer.cornerRadius = IpadorIphone(value: 16)
        cell.ve_cellBg.layer.cornerRadius = IpadorIphone(value: 16)
        cell.vw_cellOfferBg.layer.borderWidth = 0
        cell.lbl_trial.textColor = .systemGray
        
        if indexPath.row == 2 {
            cell.vw_cellTrialBg.backgroundColor = .systemGray5
            cell.lbl_trial.isHidden = false
        }
        
        if selectedIndex == indexPath.row {
            if selectedIndex == 2 {
                cell.vw_cellTrialBg.backgroundColor = .link
                cell.lbl_trial.textColor = .white
                cell.vw_cellOfferBg.layer.borderWidth = IpadorIphone(value: 0.5)
                cell.vw_cellOfferBg.backgroundColor = .link.withAlphaComponent(0.1)
                btn_countinue.setTitle("Start My 3 Days Free Trial", for: .normal)
            } else {
                cell.vw_cellOfferBg.layer.borderWidth = IpadorIphone(value: 2)
                cell.vw_cellOfferBg.layer.borderColor = UIColor.link.cgColor
                cell.vw_cellOfferBg.backgroundColor = .link.withAlphaComponent(0.1)
                btn_countinue.setTitle("Buy Now", for: .normal)
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        collVw_pricing.reloadData()
    }
}

// MARK: - CollectionView Cell
class CollVw_PricingCell: UICollectionViewCell {
    
    @IBOutlet weak var lbl_trial: UILabel!
    @IBOutlet weak var lbl_day: UILabel!
    @IBOutlet weak var lbl_price: UILabel!
    @IBOutlet weak var lbl_priceAndDay: UILabel!
    
    @IBOutlet weak var imgVw_offer: UIImageView!
    
    @IBOutlet weak var vw_cellTrialBg: UIView!
    @IBOutlet weak var vw_cellOfferBg: UIView!
    @IBOutlet weak var ve_cellBg: UIView!
}
