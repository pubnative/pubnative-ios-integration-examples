//
//  TargetingSampleSwiftViewController.swift
//  sample.targeting
//
//  Created by Can Soykarafakili on 21.11.17.
//  Copyright © 2017 Can Soykarafakili. All rights reserved.
//

import UIKit
import Pubnative

class TargetingSampleSwiftViewController: UIViewController {

    var mediumLayout : PNMediumLayout?
    @IBOutlet weak var mediumAdContainer: UIView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    override func viewDidDisappear(_ animated: Bool)
    {
        super.viewDidDisappear(animated)
        mediumLayout?.stopTrackingView()
    }
    
    @IBAction func requestButtonTouchUpInside(_ sender: Any)
    {
        let targeting = PNAdTargetingModel()
        targeting.age = 25
        targeting.gender = "m"
        Pubnative.setTargeting(targeting)
        
        mediumAdContainer.isHidden = true;
        loadingIndicator.startAnimating()
        if (mediumLayout == nil) {
            mediumLayout = PNMediumLayout()
        }
        mediumLayout?.load(withAppToken: Settings.appToken(), placement: Settings.placement(), delegate: self)
    }
}

extension TargetingSampleSwiftViewController : PNLayoutLoadDelegate
{
    func layoutDidFinishLoading(_ layout: PNLayout!)
    {
        print("Layout loaded")
        if (mediumLayout == layout) {
            mediumAdContainer.isHidden = false;
            loadingIndicator.stopAnimating()
            layout.trackDelegate = self
            let layoutView = mediumLayout?.viewController.view
            mediumAdContainer.addSubview(layoutView!)
            mediumLayout?.startTrackingView()
            
            // You can access layout.viewController and customize the ad appearance with the predefined methods.
        }
    }
    
    func layout(_ layout: PNLayout!, didFailLoading error: Error!)
    {
        loadingIndicator.stopAnimating()
        print("Error: \(error.localizedDescription)")
    }
}

extension TargetingSampleSwiftViewController : PNLayoutTrackDelegate
{
    func layoutTrackImpression(_ layout: PNLayout!)
    {
        print("Layout impression tracked")
    }
    
    func layoutTrackClick(_ layout: PNLayout!)
    {
        print("Layout click tracked")
    }
}
