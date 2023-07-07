//
//  ProcessingData.swift
//  VideoPlayerReconstruct
//
//  Created by bo yu on 7/7/2023.
//

import Foundation
class ProcessingData {
    static func loadJsonFile() {
        // Implement the logic to load the JSON file into memory
        printLog("try to call ProcessData.loadJson")
        // /*
        ProcessData.loadJson(filepath: "http://10.16.104.42:8080/DataManager/response_data.json") { (responseData: ResponseData?) in
            if let responseData = responseData {
                // JSON data is loaded and available as 'responseData' of type 'ResponseData'
                // Use the data as needed
                printLog("load http responseData success\n\(responseData)")
                DispatchQueue.main.async {
                    // Perform UI updates on the main thread
                    // ...
                    printLog("load http responseData success to run codes here")
                }
            } else {
                printLog("load http responseData fail")
                // Failed to load JSON data
                DispatchQueue.main.async {
                    // Perform UI updates on the main thread
                    // ...
                    printLog("load http responseData fail to run codes here")
                }
            }
        }
        // */

        ProcessData.loadJson(filepath: "file:///Users/boyu/work_root/codes/VADTest/LittlestarTest/VAIosPlayer/VADIosPlayerApp/VADIosPlayerApp/DataManager/response_data.json") { (responseData: ResponseData?) in
            if let responseData = responseData {
                // JSON data is loaded and available as 'responseData' of type 'ResponseData'
                // Use the data as needed
                printLog("load fileurl responseData success\n\(responseData)")
                DispatchQueue.main.async {
                    // Perform UI updates on the main thread
                    // ...
                    printLog("load fileurl success to run codes here")
                }
            } else {
                printLog("load fileurl responseData fail")
                // Failed to load JSON data
                DispatchQueue.main.async {
                    // Perform UI updates on the main thread
                    // ...
                    printLog("load fileurl responseData fail to run codes here")
                }
            }
        }

        // /*
        ProcessData.loadJson(filepath: "ResponseDataPipeline") { (responseData: PipelineResData?) in
            if let responseData = responseData {
                // JSON data is loaded and available as 'responseData' of type 'ResponseData'
                // Use the data as needed
                printLog("load PipelineResData success\n\(responseData)")
                DispatchQueue.main.async {
                    // Perform UI updates on the main thread
                    // ...
                }
            } else {
                // Failed to load JSON data
                printLog("load PipelineResData fail")
                DispatchQueue.main.async {
                    // Perform UI updates on the main thread
                    // ...
                }
            }
        }
        // */

        printLog("Down to call ProcessData.loadJson")
    }
}
