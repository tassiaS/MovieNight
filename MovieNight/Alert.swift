//
//  Alert.swift
//  MovieNight
//
//  Created by Tassia Serrao on 26/07/2017.
//  Copyright © 2017 Tassia Serrao. All rights reserved.
//

import Foundation
import UIKit

struct Alert {
    
    static func create(alertTitle: String, message: String, actionTitle: String) -> UIAlertController {
        let alert = UIAlertController(title: alertTitle, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: actionTitle, style: UIAlertActionStyle.default, handler: nil))
        return alert
    }
}
