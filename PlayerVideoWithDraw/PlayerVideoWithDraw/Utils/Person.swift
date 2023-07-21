//
//  Person.swift
//  PlayerVideoWithDraw
//
//  Created by bo yu on 20/7/2023.
//

import Foundation

struct Person: Codable {
    let index: Int
    let name: String
    let identifier: String
    let age: Double

    enum CodingKeys: String, CodingKey {
        case index
        case name
        case identifier
        case age
    }

    init(index: Int, name: String, identifier: String, age: Double) {
        self.index = index
        self.name = name
        self.identifier = identifier
        self.age = age
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        index = try container.decode(Int.self, forKey: .index)
        name = try container.decode(String.self, forKey: .name)
        identifier = try container.decode(String.self, forKey: .identifier)

        // Handle missing age key by using a default value
        if let age = try container.decodeIfPresent(Double.self, forKey: .age) {
            self.age = age
        } else {
            self.age = 0.0 // Default age value when the key is missing
        }
    }
}

func test() {
    // Example usage:
    let person = Person(index: 1, name: "John Doe", identifier: "ABC123", age: 30.5)

    // Encoding to JSON
    let encoder = JSONEncoder()
    encoder.outputFormatting = .prettyPrinted

    do {
        let jsonData = try encoder.encode(person)
        if let jsonString = String(data: jsonData, encoding: .utf8) {
            print(jsonString)
        }
    } catch {
        print("Error encoding person to JSON: \(error)")
    }

    // Decoding from JSON
    let jsonString = """
{
    "index": 1,
    "name": "John Doe",
    "identifier": "ABC123",
    "age": 30.5
}
"""

    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase

    do {
        let jsonData = jsonString.data(using: .utf8)!
        let decodedPerson = try decoder.decode(Person.self, from: jsonData)
        print("Decoded Person: \(decodedPerson)")
    } catch {
        print("Error decoding person from JSON: \(error)")
    }

}
