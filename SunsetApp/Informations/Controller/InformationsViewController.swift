//
//  InformationsViewController.swift
//  SunsetApp
//
//  Created by Angelique Babin on 24/09/2020.
//

import UIKit
import GoogleMobileAds

final class InformationsViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var bannerView: GADBannerView!
    
    // MARK: - Properties
    
    private let sunriseSunset = "https://sunrise-sunset.org/api"
    private let flaticon = "https://www.flaticon.com/"
    private let freepik = "https://www.flaticon.com/authors/freepik"
    private let adMobService = AdMobService()
    
    // MARK: - Actions

    @IBAction private func flaticonButtonTapped(_ sender: UIButton) {
        openSafari(flaticon)
    }
    
    @IBAction private func freepikButtonTapped(_ sender: UIButton) {
        openSafari(freepik)
    }
    
    @IBAction private func sunriseSunsetButtonTapped(_ sender: UIButton) {
        openSafari(sunriseSunset)
    }

    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        adMobService.setAdMob(bannerView, self)
//        navigationController?.isToolbarHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        navigationController?.isToolbarHidden = true
    }
    
    // MARK: - Methods

    /// open url with safari
    private func openSafari(_ urlString: String) {
        guard let url = URL(string: urlString) else { return }
        guard UIApplication.shared.canOpenURL(url) else { return }
        UIApplication.shared.open(url)
    }
}
