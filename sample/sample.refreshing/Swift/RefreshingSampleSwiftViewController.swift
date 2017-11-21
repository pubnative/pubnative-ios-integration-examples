//
//  RefreshingSampleSwiftViewController.swift
//  sample.refreshing
//
//  Created by Can Soykarafakili on 21.11.17.
//  Copyright © 2017 Can Soykarafakili. All rights reserved.
//

import UIKit
import Pubnative

class RefreshingSampleSwiftViewController: UIViewController {

    var smallLayout : PNSmallLayout?
    weak var timer: Timer?
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
    
    override func viewWillDisappear(_ animated: Bool)
    {
        timer?.invalidate()
    }
    
    @IBAction @objc func requestButtonTouchUpInside(_ sender: Any)
    {
        smallAdContainer.isHidden = true;
        loadingIndicator.startAnimating()
        if(smallLayout == nil) {
            smallLayout = PNSmallLayout()
        }
        smallLayout?.load(withAppToken: Settings.appToken(), placement: Settings.placement(), delegate: self)
    }
}

extension RefreshingSampleSwiftViewController : PNLayoutLoadDelegate
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
            
            if(timer == nil) {
                timer = Timer.scheduledTimer(timeInterval: Settings.repeatTime(), target: self, selector: #selector(self.requestButtonTouchUpInside(_:)), userInfo: nil, repeats: true)
            }
        }
    }
    
    func layout(_ layout: PNLayout!, didFailLoading error: Error!)
    {
        loadingIndicator.stopAnimating()
        print("Error: \(error.localizedDescription)")
    }
}

extension RefreshingSampleSwiftViewController : PNLayoutTrackDelegate
{
    func layoutTrackImpression(_ layout: PNLayout!)
    {
        print("Layout impression tracked")
    }
    
    func layoutTrackClick(_ layout: PNLayout!)
    {
        print("Layout click tracked")
        timer?.invalidate()
    }
}
