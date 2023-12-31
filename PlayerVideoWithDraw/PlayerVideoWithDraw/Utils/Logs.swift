//
//  Logs.swift
//  PlayerVideoWithDraw
//
//  Created by bo yu on 20/7/2023.
//

import Foundation
import OSLog

/// refer to https://www.avanderlee.com/workflow/oslog-unified-logging/
extension Logger {
    /// Using your bundle identifier is a great way to ensure a unique identifier.
    private static var subsystem = Bundle.main.bundleIdentifier!

    /// Logs the view cycles like a view that appeared.
    static let viewCycle = Logger(subsystem: subsystem, category: "viewcycle")

    /// All logs related to tracking and analytics.
    static let statistics = Logger(subsystem: subsystem, category: "statistics")
}

func printLog(_ message: String, file: String = #file, line: Int = #line, fn: String = #function) {
    let fileName = URL(fileURLWithPath: file).lastPathComponent
    print("[\(fileName):\(fn):\(line)] \(message)")
}

func printLogs() {
    Logger.viewCycle.info("View Appeared!")
    let username = "Example Username"
    Logger.viewCycle.info("User \(username) logged in")
    Logger.viewCycle.info("User \(username, privacy: .private) logged in")
    Logger.viewCycle.notice("Notice example")
    Logger.viewCycle.info("Info example")
    Logger.viewCycle.debug("Debug example")
    Logger.viewCycle.trace("Notice example")
    Logger.viewCycle.warning("Warning example")
    Logger.viewCycle.error("Error example")
    Logger.viewCycle.fault("Fault example")
    Logger.viewCycle.critical("Critical example")
    let data = 2312424
    Logger.viewCycle.log("Critical example \(data, format: .decimal, align: .right(columns:3))")
    Logger.viewCycle.log("Critical example \(username, privacy: .private(mask: .hash))")
    // Logger.statistics.debug("\(person.index) \(person.name, align: .left(columns: Person.maxNameLength)) \(person.identifier) \(person.age, format: .fixed(precision: 2))")
}
