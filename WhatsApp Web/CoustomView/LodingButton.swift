//
//  LodingButton.swift
//  WhatsApp Web
//
//  Created by mac on 18/06/24.
//

import Foundation
import UIKit

class LoadingButton: UIButton {

    private var activityIndicator: UIActivityIndicatorView!

    override func awakeFromNib() {
        super.awakeFromNib()
        setupActivityIndicator()
    }

    private func setupActivityIndicator() {
        if UIDevice.current.userInterfaceIdiom == .pad {
            activityIndicator = UIActivityIndicatorView(style: .large)
        } else {
            activityIndicator = UIActivityIndicatorView(style: .medium)
        }
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = .white
        addSubview(activityIndicator)

        NSLayoutConstraint.activate([
            activityIndicator.trailingAnchor.constraint(equalTo: titleLabel!.leadingAnchor, constant: -8),
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    func startLoading() {
        DispatchQueue.main.async {
            self.activityIndicator.startAnimating()
            self.isEnabled = false
        }
    }

    func stopLoading() {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.isEnabled = true
        }
    }
}
