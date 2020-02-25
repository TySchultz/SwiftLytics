//
//  SwiftLyticViewDelegate.swift
//  SwiftLytic
//
//  Created by Tyler Schultz on 02/24/2020.
//  Copyright © 2020 Tyler Schultz. All rights reserved.
//

import Foundation

internal protocol SwiftLyticViewDelegate: class {
    func didTapInfo(for view: SwiftLyticView)
}
