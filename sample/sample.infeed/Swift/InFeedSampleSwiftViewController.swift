//
//  InFeedSampleSwiftViewController.swift
//  sample.infeed
//
//  Created by Can Soykarafakili on 09.01.18.
//  Copyright © 2018 Can Soykarafakili. All rights reserved.
//

import UIKit
import Pubnative

class InFeedSampleSwiftViewController: UIViewController {
    
    var dataSource : [Any] = Settings.initialDataSource()
    var smallLayout : PNSmallLayout?
    var mediumLayout : PNMediumLayout?
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var layoutSegmentedControl: UISegmentedControl!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        tableView.isHidden = true
    }
    
    override func viewDidDisappear(_ animated: Bool)
    {
        super.viewDidDisappear(animated)
    }
    
    @IBAction func requestButtonTouchUpInside(_ sender: Any)
    {
        dataSource = Settings.initialDataSource()
        tableView.reloadData()
        loadingIndicator.startAnimating()
        // In order to be more efficient this ViewController is handling both Small and Medium Layout Integrations..
        // That's why some of the methods are generealized..
        // You can always choose one of them and integrate like you are integrating a Small or Medium Layout and remove the codes that is related with other Layout.
        switch layoutSegmentedControl.selectedSegmentIndex {
        case 0:
            if(smallLayout == nil) {
                smallLayout = PNSmallLayout()
            }
            smallLayout?.load(withAppToken: Settings.appToken(), placement: Settings.placementSmall(), delegate: self)
            break
        case 1:
            if(mediumLayout == nil) {
                mediumLayout = PNMediumLayout()
            }
            mediumLayout?.load(withAppToken: Settings.appToken(), placement: Settings.placementMedium(), delegate: self)
            break
        default:
            break
        }
    }
}

extension InFeedSampleSwiftViewController : UITableViewDelegate
{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        //You can add your own logic to here...
        print("Cell pressed")
    }
}

extension InFeedSampleSwiftViewController : UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        // You can add your own data source to here...
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if (dataSource[indexPath.row] is PNSmallLayout) {
            return 80
        } else if (dataSource[indexPath.row] is PNMediumLayout) {
            return 250
        } else {
            // You can give the necessary height parameter to your UITableViewCells in here...
            return 100
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if (dataSource[indexPath.row] is PNSmallLayout) {
            let smallAdCell = tableView.dequeueReusableCell(withIdentifier: "SmallLayoutSwiftCell", for: indexPath) as! SmallLayoutSwiftCell
            let layoutView = smallLayout?.viewController.view
            smallAdCell.smallAdContainer.addSubview(layoutView!)
            smallLayout?.startTrackingView()
            return smallAdCell
            
        } else if (dataSource[indexPath.row] is PNMediumLayout) {
            let mediumAdCell = tableView.dequeueReusableCell(withIdentifier: "MediumLayoutSwiftCell", for: indexPath) as! MediumLayoutSwiftCell
            let layoutView = mediumLayout?.viewController.view
            mediumAdCell.mediumAdContainer.addSubview(layoutView!)
            mediumLayout?.startTrackingView()
            return mediumAdCell;
        }
            // You can add your own UITableViewCell implementations from here...
        else {
            let defaultcell = tableView.dequeueReusableCell(withIdentifier: "DefaultCell", for: indexPath)
            return defaultcell;
        }
    }
}

extension InFeedSampleSwiftViewController : PNLayoutLoadDelegate
{
    func layoutDidFinishLoading(_ layout: PNLayout!)
    {
        print("Layout loaded")
        // You can insert the Layout at any index... For example we added into the 7th index.
        layout.trackDelegate = self
        dataSource.insert(layout, at: 7)
        tableView.reloadData()
        loadingIndicator.stopAnimating()
        tableView.isHidden = false
        // You can access layout.viewController and customize the ad appearance with the predefined methods.
    }
    
    func layout(_ layout: PNLayout!, didFailLoading error: Error!)
    {
        loadingIndicator.stopAnimating()
        print("Error: \(error.localizedDescription)")
    }
}

extension InFeedSampleSwiftViewController : PNLayoutTrackDelegate
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
