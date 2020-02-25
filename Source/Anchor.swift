//
//  Anchor.swift
//  SwiftLytics
//
//  Created by Tyler Schultz on 02/24/2020.
//  Copyright © 2020 Tyler Schultz. All rights reserved.
//

import UIKit

private func snap(value: CGFloat, scale: CGFloat) -> CGFloat {
    return (value * scale).rounded() / scale
}

internal func anchor(
    view: UIView,
    referenceView: UIView,
    configuration: SwiftLytic.ViewConfiguration
    ) -> CGPoint {
    let safeBottom: CGFloat = referenceView.safeAreaInsets.bottom
    let bounds = referenceView.bounds
    let scale = UIScreen.main.scale
    return CGPoint(
        x: snap(value: bounds.width / 2, scale: scale),
        y: snap(value: bounds.height - safeBottom - configuration.bottomPadding - view.bounds.height / 2, scale: scale)
    )
}
