//
//  RubberBandDistance.swift
//  SwiftLytics
//
//  Created by Tyler Schultz on 02/24/2020.
//  Copyright © 2020 Tyler Schultz. All rights reserved.
//

import UIKit

internal func rubberBandDistance(offset: CGFloat, dimension: CGFloat) -> CGFloat {
    let constant: CGFloat = 0.55
    let absOffset = abs(offset)
    let result = (constant * absOffset * dimension) / (dimension + constant * absOffset)
    return offset < 0 ? -result : result
}
