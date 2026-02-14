//
//  QuotesVC.swift
//  WhatsApp Web
//
//  Created by mac on 10/06/24.
//

import UIKit

class QuotesVC: UIViewController {
    
    // MARK: - @IBOutlet
    @IBOutlet weak var tblvw_quotes: UITableView!
    
    // MARK: - Variables
    var fromTitle = String()
    var arrQuotes = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
}

// MARK: - Private Methods
extension QuotesVC {
    
    func setUpUI() {
        navigationItem.title = fromTitle
        navigationItem.largeTitleDisplayMode = .never
        
        tblvw_quotes.delegate = self
        tblvw_quotes.dataSource = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(copyQuote(_:)), name: Notification.Name("Copy"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(shareQuote(_:)), name: Notification.Name("Share"), object: nil)
    }
    
    @objc func copyQuote(_ notification: NSNotification) {
        if let text = notification.object as? String {
            UIPasteboard.general.string = text
            Utils().showToast(context: self, msg: "Copied!")
        }
    }
    
    @objc func shareQuote(_ notification: NSNotification) {
        if let txt = notification.object as? String {
            if !txt.isEmpty {
                let activityController = UIActivityViewController(activityItems: [txt as String], applicationActivities: nil)
                activityController.popoverPresentationController?.sourceView = view
                activityController.popoverPresentationController?.sourceRect = view.frame
                
                if let popoverController = activityController.popoverPresentationController {
                    popoverController.sourceView = self.view
                    popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
                    popoverController.permittedArrowDirections = []
                }
                self.present(activityController, animated: true, completion: nil)
            }
        }
    }
}

// MARK: - TableView (Delegate, DataSource)
extension QuotesVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrQuotes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblvw_quotes.dequeueReusableCell(withIdentifier: "TblVw_QuotesCell") as! TblVw_QuotesCell
        cell.lbl_quotes.text = arrQuotes[indexPath.row]
        cell.vw_cellBg.layer.cornerRadius = IpadorIphone(value: 8)
        cell.vw_cellBg.layer.borderColor = UIColor(hex: "#8E8E93").cgColor
        cell.vw_cellBg.layer.borderWidth = IpadorIphone(value: 1)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

//MARK: - TableView Cell
class TblVw_QuotesCell: UITableViewCell {
    
    @IBOutlet weak var vw_cellBg: UIView!
    @IBOutlet weak var lbl_quotes: UILabel!
        
    @IBAction func btn_copyAndShareTapped(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            NotificationCenter.default.post(name: Notification.Name("Copy"), object: lbl_quotes.text)
        case 1:
            NotificationCenter.default.post(name: Notification.Name("Share"), object: lbl_quotes.text)
        default:
            break
        }
    }
}
