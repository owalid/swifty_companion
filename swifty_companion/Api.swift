//
//  Api.swift
//  swifty_companion
//
//  Created by owalid on 17/12/2020.
//  Copyright © 2020 owalid. All rights reserved.
//

import Foundation

class Api {
  
  func requestToken(code: String) {
    let params = "grant_type=client_credentials&client_id=\(FT_CONSUMER_KEY)&client_secret=\(FT_CONSUMER_SECRET)&code=\(code)"
    let target = URL(string: FT_URL_API_TOKEN)!
    
    var request = URLRequest(url: target)
    request.httpMethod = "POST"
    request.httpBody = params.data(using: String.Encoding.utf8)

    let task = URLSession.shared.dataTask(with: request) { data, response, error in
      guard let data = data,
         let response = response as? HTTPURLResponse,
         error == nil else {                                              // check for fundamental networking error
         print("error", error ?? "Unknown error")
         return
       }
       guard (200 ... 299) ~= response.statusCode else {                    // check for http errors
         print("statusCode should be 2xx, but is \(response.statusCode)")
         print("response = \(response)")
         return
       }
       let responseString = String(data: data, encoding: .utf8)
       print("responseString = \(responseString)")
    }
    task.resume()
  }
}
