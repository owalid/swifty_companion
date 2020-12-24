//
//  Extension.swift
//  swifty_companion
//
//  Created by owalid on 17/12/2020.
//  Copyright © 2020 owalid. All rights reserved.
//

import Foundation
import SwiftUI

extension URL {
  func valueOf(_ queryParamaterName: String) -> String? {
    guard let url = URLComponents(string: self.absoluteString) else { return nil }
    return url.queryItems?.first(where: { $0.name == queryParamaterName })?.value
  }
}

extension Double {
  func rounded(toPlaces places:Int) -> Double {
    let divisor = pow(10.0, Double(places))
    return (self * divisor).rounded() / divisor
  }
}

extension Date {
  func timeAgoDisplay() -> String {
    let calendar = Calendar.current
    let minuteAgo = calendar.date(byAdding: .minute, value: -1, to: Date())!
    let hourAgo = calendar.date(byAdding: .hour, value: -1, to: Date())!
    let dayAgo = calendar.date(byAdding: .day, value: -1, to: Date())!
    let weekAgo = calendar.date(byAdding: .day, value: -7, to: Date())!
    let monthAgo = calendar.date(byAdding: .month, value: -1, to: Date())!
    let yearAgo = calendar.date(byAdding: .year, value: -1, to: Date())!

    if minuteAgo < self {
        let diff = Calendar.current.dateComponents([.second], from: self, to: Date()).second ?? 0
      return "Il y a \(diff) seconde\((diff > 1) ? "s" : "")"
    } else if hourAgo < self {
        let diff = Calendar.current.dateComponents([.minute], from: self, to: Date()).minute ?? 0
      return "Il y a \(diff) minute\((diff > 1) ? "s" : "")"
    } else if dayAgo < self {
        let diff = Calendar.current.dateComponents([.hour], from: self, to: Date()).hour ?? 0
      return "Il y a \(diff) heure\((diff > 1) ? "s" : "")"
    } else if weekAgo < self {
        let diff = Calendar.current.dateComponents([.day], from: self, to: Date()).day ?? 0
      return "Il y a \(diff) jour\((diff > 1) ? "s" : "")"
    } else if monthAgo < self {
      let diff = Calendar.current.dateComponents([.weekOfYear], from: self, to: Date()).weekOfYear ?? 0
      return "Il y a \(diff) semaines"
    } else if yearAgo < self {
      let diff = Calendar.current.dateComponents([.month], from: self, to: Date()).month ?? 0
      return "Il y a \(diff) mois"
    }
    let diff = Calendar.current.dateComponents([.year], from: self, to: Date()).year ?? 0
    return "Il y a \(diff) an\((diff > 1) ? "s" : "")"
  }
}

extension Color {
  init(hex: String) {
    let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
    var int: UInt64 = 0
    Scanner(string: hex).scanHexInt64(&int)
    let a, r, g, b: UInt64
    switch hex.count {
      case 3: // RGB (12-bit)
      (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
      case 6: // RGB (24-bit)
      (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
      case 8: // ARGB (32-bit)
      (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
      default:
      (a, r, g, b) = (1, 1, 1, 0)
    }

    self.init(
      .sRGB,
      red: Double(r) / 255,
      green: Double(g) / 255,
      blue:  Double(b) / 255,
      opacity: Double(a) / 255
    )
  }
}
