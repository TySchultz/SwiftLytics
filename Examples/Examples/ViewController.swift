//
//  ViewController.swift
//  Examples
//
//  Created by Tyler Schultz on 02/22/2020.
//  Copyright © 2020 Tyler Schultz. All rights reserved.
//

import UIKit
import SwiftLytics

class ViewController: UIViewController {

    @IBAction func onInfo(_ sender: Any) {
      SwiftLytic.shared.show(action: "Tailwind Dashboard Tapped",
                             properties: ["Category": "App",
                                          "Value": "1234",
                                          "TimelineValue": "Tripleg"])
  }
    @IBAction func onText(_ sender: Any) {
      SwiftLytic.shared.show(action: "Tailwind Dashboard Tapped",
                             properties: ["Category": "App",
                                          "Value": "1234",
                                          "TimelineValue": "Tripleg"])
    }
}
