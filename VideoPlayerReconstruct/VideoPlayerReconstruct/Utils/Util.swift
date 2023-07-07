//
//  Util.swift
//  VideoPlayerReconstruct
//
//  Created by bo yu on 7/7/2023.
//

import Foundation

class ProcessData {

    static func loadJson<T: Codable>(filepath: String, completion: @escaping (T?) -> Void) {
        printLog("loadJson filepath is : \(filepath)")
        // let filepath = "ResponseDataPipeline"
        recognizeFilePath(filepath: filepath) { fileURL in
            guard let fileURL = fileURL else {
                completion(nil)
                return
            }

            do {
                printLog("try to load json's fileURL is : \(fileURL)")
                let data = try Data(contentsOf: fileURL)
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase

                let jsonData = try decoder.decode(T.self, from: data)
                completion(jsonData)
            } catch {
                printLog("Error loading local JSON data: \(error.localizedDescription)")
                completion(nil)
            }
        }
    }

    static func recognizeFilePath(filepath: String, completion: @escaping (URL?) -> Void) {
        if let url = URL(string: filepath) {
            if let scheme = url.scheme {
                if scheme.lowercased().starts(with: "http") {
                    printLog("start with http url")
                    let session = URLSession.shared
                    let task = session.dataTask(with: url) { (data, response, error) in
                        guard let data = data, error == nil else {
                            printLog("Error loading URL: \(error?.localizedDescription ?? "")")
                            completion(nil)
                            return
                        }
                        let tempDirectoryURL = FileManager.default.temporaryDirectory.appendingPathComponent(url.deletingLastPathComponent().path)
                        let tempFileURL = tempDirectoryURL.appendingPathComponent(url.lastPathComponent)
                        printLog("url PathComponents: \(url.pathComponents)")
                        printLog("url PathExtension: \(url.pathExtension)")
                        printLog("url Path file: \(url.path)")
                        printLog("url Path: \(url.deletingLastPathComponent().path)")

                        do {
                            printLog("tempFileURL: \(tempFileURL)")
                            let fileManager = FileManager.default
                            try fileManager.createDirectory(at: tempDirectoryURL, withIntermediateDirectories: true, attributes: nil)
                            printLog("Directory created: \(tempDirectoryURL.path)")
                            try data.write(to: tempFileURL)
                            completion(tempFileURL)
                        } catch {
                            printLog("Error saving file: \(error.localizedDescription)")
                            completion(nil)
                        }
                    }
                    task.resume()
                } else if scheme.lowercased().starts(with: "file") {
                    // File URL
                    printLog("start with file url")
                    return completion(url)
                    // return completion(Bundle.main.url(forResource: filepath, withExtension: nil))
                } else {
                    // Other URL scheme
                    printLog("Recognized as a different URL scheme: \(url)")
                }
                // } else if url.isFileURL {
                //     // Local fileurl
                //     printLog("file url path")
                //     return completion(Bundle.main.url(forResource: filepath, withExtension: nil))
            } else {
                printLog("load local module")
                let fileURL = URL(fileURLWithPath: Bundle.main.path(forResource: filepath, ofType: "json") ?? "")
                return completion(fileURL)
            }
        } else {
            // Invalid file path
            printLog("After URL Invalid file path: \(filepath)")
            completion(nil)
        }

        return completion(nil)
    }
}

func printLog(_ message: String, file: String = #file, line: Int = #line) {
    let fileName = URL(fileURLWithPath: file).lastPathComponent
    print("[\(fileName):\(line)] \(message)")
}
