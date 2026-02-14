//
//  WebVC.swift
//  WhatsApp Web
//
//  Created by mac on 11/06/24.
//

import UIKit
import WebKit

class WebVC: UIViewController, WKUIDelegate {
    
    //MARK: - @IBOutlets
    @IBOutlet weak var vw_whatsAppWeb: WKWebView!
    
    // MARK: - Variables
    var btn_reload = UIBarButtonItem()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
}

//MARK: - Private Methods
extension WebVC {
    
    func setUpUI() {
        navigationItem.title = "WhatsApp"
        navigationItem.largeTitleDisplayMode = .never
        btn_reload = UIBarButtonItem(image: UIImage(named: "Reload"), style: .done, target: self, action: #selector(btn_reloadTap))
        navigationItem.rightBarButtonItem = btn_reload
        
        self.vw_whatsAppWeb.scrollView.isScrollEnabled = true
        self.vw_whatsAppWeb.scrollView.panGestureRecognizer.isEnabled = true
        self.vw_whatsAppWeb.scrollView.bounces = true
        
        self.vw_whatsAppWeb.uiDelegate = self
        setWebView()
    }
    
    func setWebView() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }

            let customUserAgent = "Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/63.0.3239.84 Safari/537.36"
            self.vw_whatsAppWeb.customUserAgent = customUserAgent
            
            if Utils().isConnectedToNetwork() == false {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    Utils().showDialouge("No Internet Connection!", "There was a problem trying to connect to the internet. Please try again later.", view: self)
                    Utils().hideLoader()
                    self.navigationController?.popViewController(animated: true)
                }
                return
            }
            
            // Load WhatsApp Web URL
            if let url = URL(string: "https://web.whatsapp.com/") {
                let request = URLRequest(url: url)
                self.vw_whatsAppWeb.load(request)
            }
        }
    }
    
    @objc func btn_reloadTap() {
        setWebView()
    }
}
