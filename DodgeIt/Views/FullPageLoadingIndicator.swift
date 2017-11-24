//
//  FullPageLoadingIndicator.swift
//  DodgeIt
//
//  Created by admin on 11/22/17.
//  Copyright © 2017 esohjay. All rights reserved.
//

import UIKit

class FullPageLoadingIndicator {
    let viewController: UIViewController
    let fadedOverlayView = UIView()
    let loadingSpinner = UIActivityIndicatorView()
    
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    func setupViews() {
        fadedOverlayView.translatesAutoresizingMaskIntoConstraints = false
        fadedOverlayView.backgroundColor = .black
        fadedOverlayView.alpha = 0.0
        let applicationWindow = UIApplication.shared.keyWindow
        applicationWindow?.addSubview(fadedOverlayView)
        fadedOverlayView.topAnchor.constraint(equalTo: applicationWindow!.topAnchor, constant: 0).isActive = true
        fadedOverlayView.rightAnchor.constraint(equalTo: applicationWindow!.rightAnchor, constant: 0).isActive = true
        fadedOverlayView.bottomAnchor.constraint(equalTo: applicationWindow!.bottomAnchor, constant: 0).isActive = true
        fadedOverlayView.leftAnchor.constraint(equalTo: applicationWindow!.leftAnchor, constant: 0).isActive = true
        
        loadingSpinner.startAnimating()
        loadingSpinner.activityIndicatorViewStyle = .whiteLarge
        loadingSpinner.translatesAutoresizingMaskIntoConstraints = false
        fadedOverlayView.addSubview(loadingSpinner)
        loadingSpinner.centerXAnchor.constraint(equalTo: applicationWindow!.centerXAnchor).isActive = true
        loadingSpinner.centerYAnchor.constraint(equalTo: applicationWindow!.centerYAnchor).isActive = true
        loadingSpinner.widthAnchor.constraint(equalToConstant: 100).isActive = true
        loadingSpinner.heightAnchor.constraint(equalToConstant: 100).isActive = true
        viewController.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.fadedOverlayView.alpha = 0.8
        }
    }
    
    func startLoading() {
        setupViews()
        fadedOverlayView.isHidden = false
    }
    func stopLoading() {
        fadedOverlayView.isHidden = true
        fadedOverlayView.removeFromSuperview()
    }
}
