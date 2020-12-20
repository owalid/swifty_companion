//
//  UrlExtension.swift
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

extension Color {
    static var random: Color {
        return Color(
            red: .random(in: 0...1),
            green: .random(in: 0...1),
            blue: .random(in: 0...1)
        )
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

