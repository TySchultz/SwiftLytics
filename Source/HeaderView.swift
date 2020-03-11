//
//  File.swift
//  
//
//  Created by Tyler Schultz on 3/11/20.
//

import Foundation
import UIKit

class HeaderView: UIView {

  override init(frame: CGRect) {
    super.init(frame: frame)

    self.backgroundColor = UIColor.systemGray.withAlphaComponent(0.2)
    let enableLabel = UILabel(frame: CGRect(x: 16, y: 0, width: frame.width/2, height: frame.height))
    let toggle      = UISwitch(frame: CGRect(x: frame.width - 64, y: frame.height/4, width: 64, height: frame.height/2))

    self.addSubview(enableLabel)
    self.addSubview(toggle)

    enableLabel.text = "Reporting Enabled"
    enableLabel.font = UIFont.boldSystemFont(ofSize: 18)

    toggle.isOn = true
    toggle.addTarget(self, action: #selector(toggleChanged), for: .valueChanged)
  }


  @objc private func toggleChanged() {
    SwiftLytic.shared.stopShowingAnalytics()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }


  
}
