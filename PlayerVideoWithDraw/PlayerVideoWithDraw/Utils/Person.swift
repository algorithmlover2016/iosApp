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

    // Add your custom init method here if needed.

    enum CodingKeys: String, CodingKey {
        case index
        case name
        case identifier
        case age
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
    decoder.ignoreUnknownKeys = true // Ignore unknown keys during decoding

    do {
        let jsonData = jsonString.data(using: .utf8)!
        let decodedPerson = try decoder.decode(Person.self, from: jsonData)
        print("Decoded Person: \(decodedPerson)")
    } catch {
        print("Error decoding person from JSON: \(error)")
    }

}
