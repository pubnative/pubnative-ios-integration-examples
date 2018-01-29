//
//  Settings.swift
//  sample.infeed
//
//  Created by Can Soykarafakili on 09.01.18.
//  Copyright © 2018 Can Soykarafakili. All rights reserved.
//

import Foundation

@objc public class Settings: NSObject
{
    @objc public class func appToken() -> String
    {
        return "2c6fdfd723dd4a6ba52e8e6878138145"
    }
    
    @objc public class func placementSmall() -> String
    {
        return "iOS_asset_group_1"
    }
    
    @objc public class func placementMedium() -> String
    {
        return "iOS_asset_group_3"
    }
    
    @objc public class func initialDataSource() -> Array<Any>
    {
        let dataArray : [Any] = ["Element 0","Element 1","Element 0","Element 2","Element 3","Element 4","Element 5","Element 6","Element 7","Element 8"]
        return dataArray
    }
}
