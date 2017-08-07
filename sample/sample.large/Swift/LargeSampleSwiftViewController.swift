//
//  LargeSampleSwiftViewController.swift
//  sample.large
//
//  Created by Can Soykarafakili on 04.08.17.
//  Copyright © 2017 Can Soykarafakili. All rights reserved.
//

import UIKit
import Pubnative

class LargeSampleSwiftViewController: UIViewController {
    
    var largeLayout : PNLargeLayout?

    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    @IBAction func requestButtonTouchUpInside(_ sender: Any)
    {
        loadingIndicator.startAnimating()
        if(largeLayout == nil) {
            largeLayout = PNLargeLayout()
        }
        largeLayout?.loadDelegate = self
        largeLayout?.load(withAppToken: Settings.appToken(), placement: Settings.placement())
    }
}

extension LargeSampleSwiftViewController : PNLayoutLoadDelegate
{
    func layoutDidFinishLoading(_ layout: PNLayout!)
    {
        print("Layout loaded")
        if (largeLayout == layout) {
            loadingIndicator.stopAnimating()
            largeLayout?.trackDelegate = self
            largeLayout?.viewDelegate = self
            largeLayout?.show()
        }
    }
    
    func layout(_ layout: PNLayout!, didFailLoading error: Error!)
    {
        loadingIndicator.stopAnimating()
        print("Error: \(error.localizedDescription)")
    }
}

extension LargeSampleSwiftViewController : PNLayoutTrackDelegate
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

extension LargeSampleSwiftViewController : PNLayoutViewDelegate
{
    func layoutDidShow(_ layout: PNLayout!)
    {
        print("Layout shown")
    }
    
    func layoutDidHide(_ layout: PNLayout!)
    {
        print("Layout hidden")
    }
}
