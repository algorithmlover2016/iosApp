//
//  ContentView.swift
//  PlayerVideoWithDraw
//
//  Created by bo yu on 20/7/2023.
//

import SwiftUI
import OSLog

struct ContentView: View {
    @State private var isPrintLog = false

    var body: some View {
        NavigationView {
            VStack {
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundColor(.accentColor)
                Text("Hello, world!")
                
                Button(action: {
                    isPrintLog.toggle()
                }) {
                    Text(isPrintLog ? "Start Printing Log" : "Stop Printing Log")
                        .padding()
                        .foregroundColor(.white)
                        .background(isPrintLog ? Color.blue : Color.gray)
                        .cornerRadius(10)
                }
                .padding()
                .foregroundColor(.red)
                .background(Color.black)
                .cornerRadius(10)
                
                Button("Tap Me") {
                    printLogs()
                }
                .padding()
                .foregroundColor(.red)
                .background(Color.black)
                .cornerRadius(10)
                
            }
            .padding()
            .onChange(of: isPrintLog) { newValue in
                Logger.viewCycle.info("isPrintLog: \(isPrintLog)")
                if newValue {
                    Logger.viewCycle.notice("Notice example")
                    Logger.viewCycle.info("Info example")
                    Logger.viewCycle.debug("Debug example")
                    Logger.viewCycle.trace("Notice example")
                    Logger.viewCycle.warning("Warning example")
                    Logger.viewCycle.error("Error example")
                    Logger.viewCycle.fault("Fault example")
                    Logger.viewCycle.critical("Critical example")
                    printLog("True")
                } else {
                    printLogs()
                    test()
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
