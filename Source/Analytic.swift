//
//  File.swift
//  
//
//  Created by Tyler Schultz on 2/24/20.
//

import Foundation

public protocol Analytic: Codable {
  var title: String { get set }
  var properties: [String: String] { get set }
  var createdDate: Date { get set }
}
