//
//  UserData.swift
//  swifty_companion
//
//  Created by owalid on 15/11/2020.
//  Copyright © 2020 owalid. All rights reserved.
//

import Foundation

class UserRepository {
    enum Key: String, CaseIterable {
        case token, refreshToken
        func make(for userID: String) -> String {
            return self.rawValue + "_" + userID
        }
    }
    let userDefaults: UserDefaults
    // MARK: - Lifecycle
    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }
    // MARK: - API
    func storeInfo(forUserID userID: String, token: String, refreshToken: Data) {
        saveValue(forKey: .token, value: token, userID: userID)
        saveValue(forKey: .refreshToken, value: refreshToken, userID: userID)
    }
    
    func getUserInfo(forUserID userID: String) -> (token: String?, refreshToken: Data?) {
        let token: String? = readValue(forKey: .token, userID: userID)
        let refreshToken: Data? = readValue(forKey: .refreshToken, userID: userID)
        return (token, refreshToken)
    }
    
    func removeUserInfo(forUserID userID: String) {
        Key
            .allCases
            .map { $0.make(for: userID) }
            .forEach { key in
                userDefaults.removeObject(forKey: key)
        }
    }
    // MARK: - Private
    private func saveValue(forKey key: Key, value: Any, userID: String) {
        userDefaults.set(value, forKey: key.make(for: userID))
    }
    private func readValue<T>(forKey key: Key, userID: String) -> T? {
        return userDefaults.value(forKey: key.make(for: userID)) as? T
    }
}
