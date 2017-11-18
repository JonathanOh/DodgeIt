//
//  GoogleAdService.swift
//  DodgeIt
//
//  Created by Jonathan Oh on 11/10/17.
//  Copyright © 2017 esohjay. All rights reserved.
//

import Foundation
import GoogleMobileAds

class GoogleAdService: NSObject, GADInterstitialDelegate {
    let interstitial: GADInterstitial
    private var elapsedTime: Timer!
    let timeToCompleteLevelToAvoidAd: Int = 15
    private var timeTrack: Int = 0
    
    override init() {
        self.interstitial = GADInterstitial(adUnitID: CONSTANTS.GOOGLE_SERVICES.ADS.AD_MOB_UNIT_ID)
        super.init()
        let request = GADRequest()
        if TEST.SERVE_TEST_ADS {
            request.testDevices = ["49f1a24302c679c5d1896fc1935385ef"]
        }
        interstitial.load(request)
    }
    
    func startTimer() {
        elapsedTime = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        timeTrack += 1
    }
    
    func getInterstitialIfReady() -> GADInterstitial? {
        if let userPurchasedAdRemoval = UserDefaults.standard.object(forKey: "adRemovalPurchase") as? Bool {
            if userPurchasedAdRemoval { return nil }
        }
        if let userIsBeginner = UserDefaults.standard.object(forKey: "isUserBeginner") as? Bool {
            if userIsBeginner { return nil }
        }
        if timeTrack >= timeToCompleteLevelToAvoidAd {
            return interstitial.isReady ? interstitial : nil
        } else {
            return nil
        }
    }
}
