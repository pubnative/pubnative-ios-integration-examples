//
//  NativeSampleSwiftViewController.swift
//  sample.native
//
//  Created by Can Soykarafakili on 07.08.17.
//  Copyright © 2017 Can Soykarafakili. All rights reserved.
//

import UIKit
import Pubnative

class NativeSampleSwiftViewController: UIViewController {

    var request : PNRequest?
    
    @IBOutlet weak var adContainer: UIView!
    @IBOutlet weak var adIcon: UIImageView!
    @IBOutlet weak var adTitle: UILabel!
    @IBOutlet weak var adRating: PNStarRatingView!
    @IBOutlet weak var adBanner: UIImageView!
    @IBOutlet weak var adDescription: UILabel!
    @IBOutlet weak var adCTA: UIButton!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        adContainer.isHidden = true
    }

    @IBAction func requestButtonTouchUpInside(_ sender: Any)
    {
        adContainer.isHidden = true
        loadingIndicator.startAnimating()
        if (request == nil) {
            request = PNRequest()
        }
        request?.start(withAppToken: Settings.appToken(), placementName: Settings.placement(), delegate: self)
    }
    
    func render(ad: PNAdModel!)
    {
        let renderer = PNAdModelRenderer()
        renderer.titleView = adTitle
        renderer.descriptionView = adDescription
        renderer.iconView = adIcon
        renderer.bannerView = adBanner
        renderer.starRatingView = adRating
        renderer.callToActionView = adCTA
        
        ad.renderAd(renderer)
        ad.startTrackingView(self.adContainer, with: self)
        
        adContainer.isHidden = false
        loadingIndicator.stopAnimating()
    }

}

extension NativeSampleSwiftViewController : PNRequestDelegate
{
    func pubnativeRequestDidStart(_ request: PNRequest!)
    {
        print("Request started");
    }
    
    func pubnativeRequest(_ request: PNRequest!, didLoad ad: PNAdModel!)
    {
        print("Request loaded");
        ad.delegate = self
        render(ad: ad)
    }
    
    func pubnativeRequest(_ request: PNRequest!, didFail error: Error!)
    {
        loadingIndicator.stopAnimating()
        print("Error: \(error.localizedDescription)")
    }
}

extension NativeSampleSwiftViewController : PNAdModelDelegate
{
    func pubantiveAdDidConfirmImpression(_ ad: PNAdModel!)
    {
        print("Ad impression confirmed")
    }
    
    func pubnativeAdDidClick(_ ad: PNAdModel!)
    {
        print("Ad click tracked")
    }
}

