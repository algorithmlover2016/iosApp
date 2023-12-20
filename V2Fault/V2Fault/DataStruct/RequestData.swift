//
//  SendRequest.swift
//  V2Fault
//
//  Created by bo yu on 20/12/2023.
//

import Foundation
struct DataToSend: Codable {
    var textInput: String?
    var audioBase64: String?
    var imageBase64: String?

    init(textInput: String? = nil, audioBase64: String? = nil, imageBase64: String? = nil) {
        self.textInput = textInput
        self.audioBase64 = audioBase64
        self.imageBase64 = imageBase64
    }
}
struct ServerResponse: Codable {
    let code: Int
    let errormsg: String
    let data: DataContainer
}
struct DataContainer: Codable {
    let text: String?
    let audio: String?
    // Add other fields as needed
}
extension String {
    var base64DecodedData: Data? {
        Data(base64Encoded: self)
    }
}
