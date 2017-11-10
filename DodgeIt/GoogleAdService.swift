//
//  GoogleAdService.swift
//  DodgeIt
//
//  Created by Jonathan Oh on 11/10/17.
//  Copyright © 2017 esohjay. All rights reserved.
//

import Foundation
import GoogleMobileAds

class GoogleAdService {
    let interstitial: GADInterstitial
    private var elapsedTime: Timer!
    let timeToCompleteLevelToAvoidAd: Int = 20
    private var timeTrack: Int = 0
    
    init() {
        self.interstitial = GADInterstitial(adUnitID: CONSTANTS.GOOGLE_SERVICES.ADS.AD_MOB_UNIT_ID)
        let request = GADRequest()
        if TEST.SERVE_TEST_ADS {
            request.testDevices = ["49f1a24302c679c5d1896fc1935385ef"]
        }
        interstitial.load(request)
    }
    
    func startTimer() {
        //elapsedTime = Timer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        elapsedTime = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        timeTrack += 1
    }
    
    func getInterstitialIfReady() -> GADInterstitial? {
        if timeTrack >= timeToCompleteLevelToAvoidAd {
            return interstitial.isReady ? interstitial : nil
        } else {
            return nil
        }
    }
}
