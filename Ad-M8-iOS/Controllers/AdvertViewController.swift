//
//  AdvertViewController.swift
//  Ad-M8-iOS
//
//  Created by James Shaw on 11/10/2017.
//  Copyright © 2017 The Distance. All rights reserved.
//

import UIKit
import GoogleMobileAds

class AdvertViewController: UIViewController {

    @IBOutlet weak var navigationBar: UINavigationBar!

    var interstitial: GADInterstitial!

    class func instantiateFromStoryboard() -> AdvertViewController {
        let storyboard = UIStoryboard(name: "Advert", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "AdvertViewController") as! AdvertViewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationBar.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.interstitial = self.createAndLoadInterstitial()
        self.createAndLoadRewardedVideo()
    }

    func createAndLoadInterstitial() -> GADInterstitial {
        let inter = GADInterstitial(adUnitID: "ca-app-pub-3940256099942544/1033173712")
        inter.delegate = self
        let request = GADRequest()
        inter.load(request)
        return inter
    }

    func createAndLoadRewardedVideo() {
        GADRewardBasedVideoAd.sharedInstance().delegate = self
        GADRewardBasedVideoAd.sharedInstance().load(GADRequest(), withAdUnitID: "ca-app-pub-3940256099942544/1712485313")
    }

    @IBAction func playRewardedVideo(_ sender: UIButton) {
        if GADRewardBasedVideoAd.sharedInstance().isReady == true {
            GADRewardBasedVideoAd.sharedInstance().present(fromRootViewController: self)
        }
    }

    @IBAction func playInterstitial(_ sender: UIButton) {
        self.interstitial.present(fromRootViewController: self)
    }

    @IBAction func close(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension AdvertViewController: GADInterstitialDelegate {
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        self.present(BinaryFeedbackViewController.instantiateFromStoryboard(), animated: true, completion: nil)
    }
}

extension AdvertViewController: GADRewardBasedVideoAdDelegate {
    func rewardBasedVideoAd(_ rewardBasedVideoAd: GADRewardBasedVideoAd, didRewardUserWith reward: GADAdReward) {

    }

    func rewardBasedVideoAdDidClose(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        self.present(BinaryFeedbackViewController.instantiateFromStoryboard(), animated: true, completion: nil)
    }
}

extension AdvertViewController: UINavigationBarDelegate {
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
}
