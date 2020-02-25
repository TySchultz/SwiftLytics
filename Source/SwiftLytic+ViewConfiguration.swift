//
//  SwiftLytic+Configuration.swift
//  SwiftLytics
//
//  Created by Tyler Schultz on 02/24/2020.
//  Copyright © 2020 Tyler Schultz. All rights reserved.
//

import UIKit


public extension SwiftLytic {

    public struct ViewConfiguration {
        let textColor: UIColor
        let backgroundColor: UIColor
        let insets: UIEdgeInsets
        let maxWidth: CGFloat
        let hintMargin: CGFloat
        let hintSize: CGSize
        let cornerRadius: CGFloat
        let bottomPadding: CGFloat
        let borderColor: UIColor
        let dismissDuration: TimeInterval
        let buttonVisible: Bool
        let buttonLeftMargin: CGFloat
        let buttonTapHandler: (() -> Void)?

        public init(
            textColor: UIColor               = .white,
            backgroundColor: UIColor         = UIColor(white: 0.2, alpha: 0.7),
            insets: UIEdgeInsets             = UIEdgeInsets(top: 8, left: 15, bottom: 8, right: 15),
            maxWidth: CGFloat                = 300,
            hintMargin: CGFloat              = 4,
            hintSize: CGSize                 = CGSize(width: 40, height: 4),
            cornerRadius: CGFloat            = 6,
            bottomPadding: CGFloat           = 15,
            borderColor: UIColor             = UIColor(white: 0, alpha: 0.4),
            dismissDuration: TimeInterval    = 4,
            buttonVisible: Bool              = true,
            buttonLeftMargin: CGFloat        = 8,
            buttonTapHandler: (() -> Void)?  = nil
            ) {
            self.textColor        = textColor
            self.backgroundColor  = backgroundColor
            self.insets           = insets
            self.maxWidth         = maxWidth
            self.hintMargin       = hintMargin
            self.hintSize         = hintSize
            self.cornerRadius     = cornerRadius
            self.bottomPadding    = bottomPadding
            self.borderColor      = borderColor
            self.dismissDuration  = dismissDuration
            self.buttonVisible    = buttonVisible
            self.buttonLeftMargin = buttonLeftMargin
          if buttonTapHandler == nil {
            self.buttonTapHandler = { SwiftLytic.shared.showSessionAnalyticsList() }
          } else {
            self.buttonTapHandler = buttonTapHandler
          }
        }
    }

}
