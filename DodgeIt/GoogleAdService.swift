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
    static let shared = GoogleAdService()
    private var interstitial: GADInterstitial?
    
    func loadNewAd() {
        interstitial = GADInterstitial(adUnitID: CONSTANTS.GOOGLE_SERVICES.ADS.AD_MOB_UNIT_ID)
        let request = GADRequest()
        if TEST.SERVE_TEST_ADS {
            request.testDevices = ["49f1a24302c679c5d1896fc1935385ef"]
        }
        interstitial?.load(request)
    }
    
    func getInterstitialIfReady() -> GADInterstitial? {
        guard let interstitialToReturn = interstitial else { return nil }
        return interstitialToReturn.isReady ? interstitial : nil
    }
    
    private init() {}
}
