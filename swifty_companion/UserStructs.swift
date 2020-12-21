//
//  UserStructs.swift
//  swifty_companion
//
//  Created by owalid on 18/12/2020.
//  Copyright © 2020 owalid. All rights reserved.
//

import Foundation

// MARK: - User
struct User: Codable, Identifiable, Equatable {
  var id: Int
  var login: String
  var url: String
}

// MARK: - Coalition
struct Coalition: Codable {
    let id: Int
    let name, slug: String
    let imageURL: String
    let coverURL: String
    let color: String
    let score, userID: Int

    enum CodingKeys: String, CodingKey {
        case id, name, slug
        case imageURL = "image_url"
        case coverURL = "cover_url"
        case color, score
        case userID = "user_id"
    }
}

// MARK: - Expertise
struct Expertise: Codable {
    let id: Int
    let name, slug: String
    let url: String
    let kind, createdAt: String
    let expertisesUsersURL: String

    enum CodingKeys: String, CodingKey {
        case id, name, slug, url, kind
        case createdAt = "created_at"
        case expertisesUsersURL = "expertises_users_url"
    }
}

// MARK: - UserDetailStruct
struct UserDetailStruct: Codable, Identifiable {
    let id: Int
    let email, login, firstName, lastName: String
    let usualFirstName: String?
    let url: String
    let phone: String?
    let displayname, usualFullName: String
    let imageURL: String
    let staff: Bool
    let correctionPoint: Int
    let location, poolMonth, poolYear: String?
    let wallet: Int
    let anonymizeDate: String
    let groups: [JSONAny]
    let cursusUsers: [CursusUser]
    let projectsUsers: [ProjectUser]
    let languagesUsers: [LanguagesUser]
    let achievements: [Achievement]
    let titles, titlesUsers, partnerships: [JSONAny]
    let patroned: [Patroned]
    let patroning: [JSONAny]
    let expertisesUsers: [ExpertisesUser]
    let campus: [Campus]
    let campusUsers: [CampusUser]

    enum CodingKeys: String, CodingKey {
        case id, email, login
        case firstName = "first_name"
        case lastName = "last_name"
        case usualFirstName = "usual_first_name"
        case url, phone, displayname
        case usualFullName = "usual_full_name"
        case imageURL = "image_url"
        case staff = "staff?"
        case correctionPoint = "correction_point"
        case poolMonth = "pool_month"
        case poolYear = "pool_year"
        case location, wallet
        case anonymizeDate = "anonymize_date"
        case groups
        case cursusUsers = "cursus_users"
        case projectsUsers = "projects_users"
        case languagesUsers = "languages_users"
        case achievements, titles
        case titlesUsers = "titles_users"
        case partnerships, patroned, patroning
        case expertisesUsers = "expertises_users"
        case campus
        case campusUsers = "campus_users"
    }
}

// MARK: - Achievement
struct Achievement: Codable, Identifiable {
    let id: Int
    let name, achievementDescription, tier, kind: String
    let visible: Bool
    let image: String
    let nbrOfSuccess: Int?
    let usersURL: String

    enum CodingKeys: String, CodingKey {
        case id, name
        case achievementDescription = "description"
        case tier, kind, visible, image
        case nbrOfSuccess = "nbr_of_success"
        case usersURL = "users_url"
    }
}

// MARK: - ProjectUser
struct ProjectUser: Codable, Identifiable {
    let id, occurrence: Int
    let finalMark: Int?
    let status: String
    let validated: Bool?
    let currentTeamID: Int?
    let project: Project
    let cursusIDS: [Int]
    let markedAt: String?
    let marked: Bool
    let retriableAt: String?

    enum CodingKeys: String, CodingKey {
        case id, occurrence
        case finalMark = "final_mark"
        case status
        case validated = "validated?"
        case currentTeamID = "current_team_id"
        case project
        case cursusIDS = "cursus_ids"
        case markedAt = "marked_at"
        case marked
        case retriableAt = "retriable_at"
    }
}

// MARK: - Project
struct Project: Codable {
    let id: Int
    let name, slug: String
    let parentID: Int?

    enum CodingKeys: String, CodingKey {
        case id, name, slug
        case parentID = "parent_id"
    }
}

// MARK: - Campus
struct Campus: Codable {
    let id: Int
    let name, timeZone: String
    let language: Language
    let usersCount, vogsphereID: Int

    enum CodingKeys: String, CodingKey {
        case id, name
        case timeZone = "time_zone"
        case language
        case usersCount = "users_count"
        case vogsphereID = "vogsphere_id"
    }
}

// MARK: - Language
struct Language: Codable {
    let id: Int
    let name, identifier, createdAt, updatedAt: String

    enum CodingKeys: String, CodingKey {
        case id, name, identifier
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

// MARK: - CampusUser
struct CampusUser: Codable {
    let id, userID, campusID: Int
    let isPrimary: Bool

    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case campusID = "campus_id"
        case isPrimary = "is_primary"
    }
}

// MARK: - CursusUser
struct CursusUser: Codable {
    let id: Int
    let beginAt: String
    let endAt, grade: String?
    let level: Double
    let skills: [Skill]
    let cursusID: Int
    let hasCoalition: Bool
    let user: User
    let cursus: Cursus

    enum CodingKeys: String, CodingKey {
        case id
        case beginAt = "begin_at"
        case endAt = "end_at"
        case grade, level, skills
        case cursusID = "cursus_id"
        case hasCoalition = "has_coalition"
        case user, cursus
    }
}

// MARK: - Skill
struct Skill: Codable, Identifiable {
  let id: Int
  let name: String
  let level: Double
}


// MARK: - Cursus
struct Cursus: Codable {
    let id: Int
    let createdAt, name, slug: String

    enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
        case name, slug
    }
}

// MARK: - ExpertisesUser
struct ExpertisesUser: Codable {
    let id, expertiseID: Int
    let interested: Bool
    let value: Int
    let contactMe: Bool
    let createdAt: String
    let userID: Int

    enum CodingKeys: String, CodingKey {
        case id
        case expertiseID = "expertise_id"
        case interested, value
        case contactMe = "contact_me"
        case createdAt = "created_at"
        case userID = "user_id"
    }
}

// MARK: - LanguagesUser
struct LanguagesUser: Codable {
    let id, languageID, userID, position: Int
    let createdAt: String

    enum CodingKeys: String, CodingKey {
        case id
        case languageID = "language_id"
        case userID = "user_id"
        case position
        case createdAt = "created_at"
    }
}

// MARK: - Patroned
struct Patroned: Codable {
    let id, userID, godfatherID: Int
    let ongoing: Bool
    let createdAt, updatedAt: String

    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case godfatherID = "godfather_id"
        case ongoing
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}

class JSONCodingKey: CodingKey {
    let key: String

    required init?(intValue: Int) {
        return nil
    }

    required init?(stringValue: String) {
        key = stringValue
    }

    var intValue: Int? {
        return nil
    }

    var stringValue: String {
        return key
    }
}

class JSONAny: Codable {

    let value: Any

    static func decodingError(forCodingPath codingPath: [CodingKey]) -> DecodingError {
        let context = DecodingError.Context(codingPath: codingPath, debugDescription: "Cannot decode JSONAny")
        return DecodingError.typeMismatch(JSONAny.self, context)
    }

    static func encodingError(forValue value: Any, codingPath: [CodingKey]) -> EncodingError {
        let context = EncodingError.Context(codingPath: codingPath, debugDescription: "Cannot encode JSONAny")
        return EncodingError.invalidValue(value, context)
    }

    static func decode(from container: SingleValueDecodingContainer) throws -> Any {
        if let value = try? container.decode(Bool.self) {
            return value
        }
        if let value = try? container.decode(Int64.self) {
            return value
        }
        if let value = try? container.decode(Double.self) {
            return value
        }
        if let value = try? container.decode(String.self) {
            return value
        }
        if container.decodeNil() {
            return JSONNull()
        }
        throw decodingError(forCodingPath: container.codingPath)
    }

    static func decode(from container: inout UnkeyedDecodingContainer) throws -> Any {
        if let value = try? container.decode(Bool.self) {
            return value
        }
        if let value = try? container.decode(Int64.self) {
            return value
        }
        if let value = try? container.decode(Double.self) {
            return value
        }
        if let value = try? container.decode(String.self) {
            return value
        }
        if let value = try? container.decodeNil() {
            if value {
                return JSONNull()
            }
        }
        if var container = try? container.nestedUnkeyedContainer() {
            return try decodeArray(from: &container)
        }
        if var container = try? container.nestedContainer(keyedBy: JSONCodingKey.self) {
            return try decodeDictionary(from: &container)
        }
        throw decodingError(forCodingPath: container.codingPath)
    }

    static func decode(from container: inout KeyedDecodingContainer<JSONCodingKey>, forKey key: JSONCodingKey) throws -> Any {
        if let value = try? container.decode(Bool.self, forKey: key) {
            return value
        }
        if let value = try? container.decode(Int64.self, forKey: key) {
            return value
        }
        if let value = try? container.decode(Double.self, forKey: key) {
            return value
        }
        if let value = try? container.decode(String.self, forKey: key) {
            return value
        }
        if let value = try? container.decodeNil(forKey: key) {
            if value {
                return JSONNull()
            }
        }
        if var container = try? container.nestedUnkeyedContainer(forKey: key) {
            return try decodeArray(from: &container)
        }
        if var container = try? container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key) {
            return try decodeDictionary(from: &container)
        }
        throw decodingError(forCodingPath: container.codingPath)
    }

    static func decodeArray(from container: inout UnkeyedDecodingContainer) throws -> [Any] {
        var arr: [Any] = []
        while !container.isAtEnd {
            let value = try decode(from: &container)
            arr.append(value)
        }
        return arr
    }

    static func decodeDictionary(from container: inout KeyedDecodingContainer<JSONCodingKey>) throws -> [String: Any] {
        var dict = [String: Any]()
        for key in container.allKeys {
            let value = try decode(from: &container, forKey: key)
            dict[key.stringValue] = value
        }
        return dict
    }

    static func encode(to container: inout UnkeyedEncodingContainer, array: [Any]) throws {
        for value in array {
            if let value = value as? Bool {
                try container.encode(value)
            } else if let value = value as? Int64 {
                try container.encode(value)
            } else if let value = value as? Double {
                try container.encode(value)
            } else if let value = value as? String {
                try container.encode(value)
            } else if value is JSONNull {
                try container.encodeNil()
            } else if let value = value as? [Any] {
                var container = container.nestedUnkeyedContainer()
                try encode(to: &container, array: value)
            } else if let value = value as? [String: Any] {
                var container = container.nestedContainer(keyedBy: JSONCodingKey.self)
                try encode(to: &container, dictionary: value)
            } else {
                throw encodingError(forValue: value, codingPath: container.codingPath)
            }
        }
    }

    static func encode(to container: inout KeyedEncodingContainer<JSONCodingKey>, dictionary: [String: Any]) throws {
        for (key, value) in dictionary {
            let key = JSONCodingKey(stringValue: key)!
            if let value = value as? Bool {
                try container.encode(value, forKey: key)
            } else if let value = value as? Int64 {
                try container.encode(value, forKey: key)
            } else if let value = value as? Double {
                try container.encode(value, forKey: key)
            } else if let value = value as? String {
                try container.encode(value, forKey: key)
            } else if value is JSONNull {
                try container.encodeNil(forKey: key)
            } else if let value = value as? [Any] {
                var container = container.nestedUnkeyedContainer(forKey: key)
                try encode(to: &container, array: value)
            } else if let value = value as? [String: Any] {
                var container = container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key)
                try encode(to: &container, dictionary: value)
            } else {
                throw encodingError(forValue: value, codingPath: container.codingPath)
            }
        }
    }

    static func encode(to container: inout SingleValueEncodingContainer, value: Any) throws {
        if let value = value as? Bool {
            try container.encode(value)
        } else if let value = value as? Int64 {
            try container.encode(value)
        } else if let value = value as? Double {
            try container.encode(value)
        } else if let value = value as? String {
            try container.encode(value)
        } else if value is JSONNull {
            try container.encodeNil()
        } else {
            throw encodingError(forValue: value, codingPath: container.codingPath)
        }
    }

    public required init(from decoder: Decoder) throws {
        if var arrayContainer = try? decoder.unkeyedContainer() {
            self.value = try JSONAny.decodeArray(from: &arrayContainer)
        } else if var container = try? decoder.container(keyedBy: JSONCodingKey.self) {
            self.value = try JSONAny.decodeDictionary(from: &container)
        } else {
            let container = try decoder.singleValueContainer()
            self.value = try JSONAny.decode(from: container)
        }
    }

    public func encode(to encoder: Encoder) throws {
        if let arr = self.value as? [Any] {
            var container = encoder.unkeyedContainer()
            try JSONAny.encode(to: &container, array: arr)
        } else if let dict = self.value as? [String: Any] {
            var container = encoder.container(keyedBy: JSONCodingKey.self)
            try JSONAny.encode(to: &container, dictionary: dict)
        } else {
            var container = encoder.singleValueContainer()
            try JSONAny.encode(to: &container, value: self.value)
        }
    }
}
