//
//  Api.swift
//  swifty_companion
//
//  Created by owalid on 17/12/2020.
//  Copyright © 2020 owalid. All rights reserved.
//

import Foundation

class Api {
  struct User: Codable, Identifiable {
    var id: Int
    var login: String
    var url: String
  }
  public static let instance = Api()
  var accessToken: String?
  var createdAt: Int?
  var expiresIn: Int?
  
  private init(){}
  
  func requestToken(code: String) {
    let params = "grant_type=client_credentials&client_id=\(FT_CONSUMER_KEY)&client_secret=\(FT_CONSUMER_SECRET)&code=\(code)"
    let url = URL(string: FT_URL_API_TOKEN)!
    
    var request = URLRequest(url: url)
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
      let jsonElmts = try? JSONSerialization.jsonObject(with: data, options: [])
      if let dictionary = jsonElmts as? [String: Any] {
        if let access_token = dictionary["access_token"] as? String {
          self.accessToken = access_token
        }
        if let created_at = dictionary["created_at"] as? Int {
            self.createdAt = created_at
        }
        if let expires_in = dictionary["expires_in"] as? Int {
          self.expiresIn = expires_in
        }
      }
    }
    task.resume()
  }
  
  func searchUser(login: String, cb: @escaping ([Api.User]?, Error?) -> Void) {
    let url = URL(string: "\(FT_BASE_API)/users?search[login]=\(login)&sort=login&page[size]=100")!
    var request = URLRequest(url: url)
    
    request.httpMethod = "GET"
    request.setValue("Bearer \(self.accessToken!)", forHTTPHeaderField: "Authorization")
    
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
      guard let data = data,
         let response = response as? HTTPURLResponse,
         error == nil else {                                              // check for fundamental networking error
         print("error", error ?? "Unknown error")
          cb(nil, error)
         return
       }
       guard (200 ... 299) ~= response.statusCode else {                    // check for http errors
         print("statusCode should be 2xx, but is \(response.statusCode)")
         print("response = \(response)")
         return
       }
      let decoder = JSONDecoder()
      do {
        let decoded = try decoder.decode([User].self, from: data)
        cb(decoded, nil)
      } catch {
        print("Error decode Json")
      }
    }
    task.resume()
  }
}
