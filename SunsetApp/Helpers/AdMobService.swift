//
//  AdMobService.swift
//  SunsetApp
//
//  Created by Angelique Babin on 20/05/2021.
//  Copyright © 2021 Angelique Babin. All rights reserved.
//

import Foundation
import GoogleMobileAds

final class AdMobService {
    
    func setAdMob(_ bannerView: GADBannerView, _ viewController: UIViewController) {
        bannerView.delegate = viewController
        bannerView.adUnitID = Cst.AdMobAdUnitIDTest // Test
        bannerView.rootViewController = viewController
        bannerView.load(GADRequest())
    }
    
}
