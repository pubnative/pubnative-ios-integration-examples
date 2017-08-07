//
//  SmallSampleSwiftViewController.swift
//  sample.small
//
//  Created by Can Soykarafakili on 03.08.17.
//  Copyright © 2017 Can Soykarafakili. All rights reserved.
//

import UIKit
import Pubnative

class SmallSampleSwiftViewController: UIViewController {

    var smallLayout : PNSmallLayout?
    @IBOutlet weak var smallAdContainer: UIView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    override func viewDidDisappear(_ animated: Bool)
    {
        super.viewDidDisappear(animated)
        smallLayout?.stopTrackingView()
    }
    
    @IBAction func requestButtonTouchUpInside(_ sender: Any)
    {
        smallAdContainer.isHidden = true;
        loadingIndicator.startAnimating()
        if(smallLayout == nil) {
            smallLayout = PNSmallLayout()
        }
        smallLayout?.loadDelegate = self
        smallLayout?.load(withAppToken: Settings.appToken(), placement: Settings.placement())
    }
}

extension SmallSampleSwiftViewController : PNLayoutLoadDelegate
{
    func layoutDidFinishLoading(_ layout: PNLayout!)
    {
        print("Layout loaded")
        if (smallLayout == layout) {
            smallAdContainer.isHidden = false;
            loadingIndicator.stopAnimating()
            layout.trackDelegate = self
            let layoutView = smallLayout?.viewController.view
            smallAdContainer.addSubview(layoutView!)
            smallLayout?.startTrackingView()
            
            // You can access layout.viewController and customize the ad appearance with the predefined methods.
        }
    }
    
    func layout(_ layout: PNLayout!, didFailLoading error: Error!)
    {
        loadingIndicator.stopAnimating()
        print("Error: \(error.localizedDescription)")
    }
}

extension SmallSampleSwiftViewController : PNLayoutTrackDelegate
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

