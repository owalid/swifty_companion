//
//  Api.swift
//  swifty_companion
//
//  Created by owalid on 17/12/2020.
//  Copyright © 2020 owalid. All rights reserved.
//

import Foundation

class Api: ObservableObject {
  
  public static let instance = Api()
  @Published var accessToken: String?
  @Published var createdAt: Int?
  @Published var expiresIn: Int?
  @Published var expertises: [Expertise]?
  let store = UserDefaults.standard
  
  private init() {
    if let accessToken = self.store.string(forKey: "accessToken") {
      print("aaaa: \(accessToken)")
      self.accessToken = accessToken
    }
    let createdAt = self.store.integer(forKey: "createdAt")
    if createdAt > 0 {
      print("bbbb: \(createdAt)")
      self.createdAt = createdAt
    }
    let expiresIn = self.store.integer(forKey: "expiresIn")
    if expiresIn > 0 {
      print("cccc: \(expiresIn)")
      self.expiresIn = expiresIn
    }
    let data = self.store.data(forKey: "expertises")
    let decoder = JSONDecoder()
    if data != nil {
      do {
        let decoded = try decoder.decode([Expertise].self, from: data!)
        self.expertises = decoded
      } catch let DecodingError.dataCorrupted(context) {
        print(context)
      } catch let DecodingError.keyNotFound(key, context) {
        print("Key '\(key)' not found:", context.debugDescription)
        print("codingPath:", context.codingPath)
      } catch let DecodingError.valueNotFound(value, context) {
        print("Value '\(value)' not found:", context.debugDescription)
        print("codingPath:", context.codingPath)
      } catch let DecodingError.typeMismatch(type, context)  {
        print("Type '\(type)' mismatch:", context.debugDescription)
        print("codingPath:", context.codingPath)
      } catch {
        print("error: ", error)
      }
    }
  }
  
  func requestToken(code: String) {
    let params = "grant_type=client_credentials&client_id=\(FT_CONSUMER_KEY)&client_secret=\(FT_CONSUMER_SECRET)&code=\(code)"
    let url = URL(string: FT_URL_API_TOKEN)!
    
    var request = URLRequest(url: url)
    
    request.httpMethod = "POST"
    request.httpBody = params.data(using: String.Encoding.utf8)
    
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
      guard let data = data,
            let response = response as? HTTPURLResponse,
            error == nil else { // check for fundamental networking error
        print("error", error ?? "Unknown error")
        return
      }
      guard (200 ... 299) ~= response.statusCode else { // check for http errors
        print("statusCode should be 2xx, but is \(response.statusCode)")
        print("response = \(response)")
        return
      }
      let jsonElmts = try? JSONSerialization.jsonObject(with: data, options: [])
      if let dictionary = jsonElmts as? [String: Any] {
        if let access_token = dictionary["access_token"] as? String {
          DispatchQueue.main.async {
            self.accessToken = access_token
            self.store.set(self.accessToken!, forKey: "accessToken")
          }
        }
        if let created_at = dictionary["created_at"] as? Int {
          DispatchQueue.main.async {
            self.createdAt = created_at
            self.store.set(self.createdAt!, forKey: "createdAt")
          }
        }
        if let expires_in = dictionary["expires_in"] as? Int {
          DispatchQueue.main.async {
            self.expiresIn = expires_in
            self.store.set(self.expiresIn!, forKey: "expiresIn")
          }
        }
      }
    }
    
    task.resume()
  }
  
  func searchUser(login: String, page: Int, cb: @escaping ([User]?, Error?) -> Void) {
    let timestamp = Date().timeIntervalSince1970
    
    if self.accessToken == nil || Int(timestamp) > self.createdAt! + self.expiresIn! {
      self.accessToken = nil
      self.createdAt = nil
      self.expiresIn = nil
      self.store.set(nil, forKey: "accessToken")
      self.store.set(nil, forKey: "createdAt")
      self.store.set(nil, forKey: "expiresIn")
      cb(nil, nil)
      return
    } else {
      let url = URL(string: "\(FT_BASE_API)/users?search[login]=\(login)&sort=login&page[size]=100&page[number]=\(page)")!
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
          if (response.statusCode == 401) {
            self.accessToken = nil
            self.createdAt = nil
            self.expiresIn = nil
            self.store.set(nil, forKey: "accessToken")
            self.store.set(nil, forKey: "createdAt")
            self.store.set(nil, forKey: "expiresIn")
            cb(nil, nil)
            return
          }
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
  
  func getUserDetail(id: Int, cb: @escaping (UserDetailStruct?, Error?) -> Void) {
    let timestamp = Date().timeIntervalSince1970
    
    if self.accessToken == nil || Int(timestamp) > self.createdAt! + self.expiresIn! {
      print("fesse")
      self.accessToken = nil
      self.createdAt = nil
      self.expiresIn = nil
      self.store.set(nil, forKey: "accessToken")
      self.store.set(nil, forKey: "createdAt")
      self.store.set(nil, forKey: "expiresIn")
      cb(nil, nil)
      return
    } else {
      let url = URL(string: "\(FT_BASE_API)/users/\(id)")!
      var request = URLRequest(url: url)
      
      request.httpMethod = "GET"
      request.setValue("Bearer \(self.accessToken!)", forHTTPHeaderField: "Authorization")
      
      let task = URLSession.shared.dataTask(with: request) { data, response, error in
        guard let data = data,
              let response = response as? HTTPURLResponse,
              error == nil else {// check for fundamental networking error
          print("error", error ?? "Unknown error")
          cb(nil, error)
          return
        }
        guard (200 ... 299) ~= response.statusCode else { // check for http errors
          if (response.statusCode == 401) {
            self.accessToken = nil
            self.createdAt = nil
            self.expiresIn = nil
            self.store.set(nil, forKey: "accessToken")
            self.store.set(nil, forKey: "createdAt")
            self.store.set(nil, forKey: "expiresIn")
            cb(nil, nil)
            return
          }
          print("statusCode should be 2xx, but is \(response.statusCode)")
          print("response = \(response)")
          return
        }
        let decoder = JSONDecoder()
        do {
          let decoded = try decoder.decode(UserDetailStruct.self, from: data)
          cb(decoded, nil)
        } catch let DecodingError.dataCorrupted(context) {
          print(context)
        } catch let DecodingError.keyNotFound(key, context) {
          print("Key '\(key)' not found:", context.debugDescription)
          print("codingPath:", context.codingPath)
        } catch let DecodingError.valueNotFound(value, context) {
          print("Value '\(value)' not found:", context.debugDescription)
          print("codingPath:", context.codingPath)
        } catch let DecodingError.typeMismatch(type, context)  {
          print("Type '\(type)' mismatch:", context.debugDescription)
          print("codingPath:", context.codingPath)
        } catch {
          print("error: ", error)
        }
      }
      task.resume()
    }
  }
  
  func getExpertises(cb: @escaping ([Expertise]?, Error?) -> Void) {
    let timestamp = Date().timeIntervalSince1970
    if self.expertises != nil {
      cb(self.expertises, nil)
      return
    } else {
      if self.accessToken == nil || Int(timestamp) > self.createdAt! + self.expiresIn! {
        self.accessToken = nil
        self.createdAt = nil
        self.expiresIn = nil
        self.store.set(nil, forKey: "accessToken")
        self.store.set(nil, forKey: "createdAt")
        self.store.set(nil, forKey: "expiresIn")
        cb(nil, nil)
        return
      } else {
        let url = URL(string: "\(FT_BASE_API)/expertises?page[size]=100")!
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"
        request.setValue("Bearer \(self.accessToken!)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
          guard let data = data,
                let response = response as? HTTPURLResponse,
                error == nil else {// check for fundamental networking error
            print("error", error ?? "Unknown error")
            cb(nil, error)
            return
          }
          guard (200 ... 299) ~= response.statusCode else { // check for http errors
            print("statusCode should be 2xx, but is \(response.statusCode)")
            print("response = \(response)")
            return
          }
          let decoder = JSONDecoder()
          do {
            let decoded = try decoder.decode([Expertise].self, from: data)
            self.expertises = decoded
            self.store.set(data, forKey: "expertises")
            cb(decoded, nil)
          } catch let DecodingError.dataCorrupted(context) {
            print(context)
          } catch let DecodingError.keyNotFound(key, context) {
            print("Key '\(key)' not found:", context.debugDescription)
            print("codingPath:", context.codingPath)
          } catch let DecodingError.valueNotFound(value, context) {
            print("Value '\(value)' not found:", context.debugDescription)
            print("codingPath:", context.codingPath)
          } catch let DecodingError.typeMismatch(type, context)  {
            print("Type '\(type)' mismatch:", context.debugDescription)
            print("codingPath:", context.codingPath)
          } catch {
            print("error: ", error)
          }
        }
        task.resume()
      }
    }
  }
  func getUserCoalition(id: Int, cb: @escaping (Coalition?, Error?) -> Void) {
    let timestamp = Date().timeIntervalSince1970
    if self.accessToken == nil || Int(timestamp) > self.createdAt! + self.expiresIn! {
      self.accessToken = nil
      self.createdAt = nil
      self.expiresIn = nil
      self.store.set(nil, forKey: "accessToken")
      self.store.set(nil, forKey: "createdAt")
      self.store.set(nil, forKey: "expiresIn")
      cb(nil, nil)
      return
    } else {
      let url = URL(string: "\(FT_BASE_API)/users/\(id)/coalitions")!
      var request = URLRequest(url: url)
      let defaultCoalition = Coalition(id: -1,
                                       name: "default",
                                       slug: "default",
                                       imageURL: "https://cdn.intra.42.fr/coalition/cover/48/assembly_background.jpg",
                                       coverURL: "https://cdn.intra.42.fr/coalition/cover/48/assembly_background.jpg",
                                       color: "#00BABC",
                                       score: 0,
                                       userID: -1
      )
      
      request.httpMethod = "GET"
      request.setValue("Bearer \(self.accessToken!)", forHTTPHeaderField: "Authorization")
      
      let task = URLSession.shared.dataTask(with: request) { data, response, error in
        guard let data = data,
              let response = response as? HTTPURLResponse,
              error == nil else {// check for fundamental networking error
          print("error", error ?? "Unknown error")
          cb(nil, error)
          return
        }
        guard (200 ... 299) ~= response.statusCode else { // check for http errors
          print("statusCode should be 2xx, but is \(response.statusCode)")
          print("response = \(response)")
          return
        }
        let decoder = JSONDecoder()
        do {
          let decoded = try decoder.decode([Coalition].self, from: data)
          if decoded.count > 0 && decoded.count != 0 {
            cb(decoded[0], nil)
          } else {
            cb(defaultCoalition, nil)
          }
        } catch let DecodingError.dataCorrupted(context) {
          print(context)
        } catch let DecodingError.keyNotFound(key, context) {
          print("Key '\(key)' not found:", context.debugDescription)
          print("codingPath:", context.codingPath)
        } catch let DecodingError.valueNotFound(value, context) {
          print("Value '\(value)' not found:", context.debugDescription)
          print("codingPath:", context.codingPath)
        } catch let DecodingError.typeMismatch(type, context)  {
          print("Type '\(type)' mismatch:", context.debugDescription)
          print("codingPath:", context.codingPath)
        } catch {
          print("error: ", error)
        }
      }
      task.resume()
    }
  }
}
