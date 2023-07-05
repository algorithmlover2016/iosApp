//
//  ViewControllerDelegate.swift
//  VideoPlayerReconstruct
//
//  Created by bo yu on 5/7/2023.
//

import Foundation

class ViewControllerDelegate: ObservableObject {
    private var viewController: ViewController?
    @Published private var useLocalFile: Bool = false
    
    func setViewController(_ viewController: ViewController) {
        self.viewController = viewController
    }
    
    func toggleFileOption() {
        // print("press toggle button, the former value is: \(useLocalFile)")
        useLocalFile.toggle()
        // print("after toggle, the value is: \(useLocalFile)")
        viewController?.toggleFileOption()
    }
    func getUseLocalFile() -> Bool {
        return useLocalFile
    }
}
