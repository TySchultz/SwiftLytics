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
      let analytic = TESTANALYTIC(title: "Tailwind Dashboard Tapped",
                   properties: ["Category": "App",
                                "Value": "1234",
                                "TimelineValue": "Tripleg"])
      SwiftLytic.shared.show(analytic: analytic)
  }

    @IBAction func onText(_ sender: Any) {
      let analytic = TESTANALYTIC(title: "Tailwind Dashboard Tapped",
                                  properties: ["Category": "App",
                                               "Action": "Tailwind Dashboard Tapped",
                                               "Value": "1234",
                                               "TimelineValue": "Tripleg"])
      SwiftLytic.shared.show(analytic: analytic)

    }

}

struct TESTANALYTIC: Analytic {
  var title: String = ""
  var properties: [String: String] = [:]
  var createdDate: Date = Date()
}

