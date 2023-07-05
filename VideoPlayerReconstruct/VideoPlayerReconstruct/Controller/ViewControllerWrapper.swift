//
//  ViewControllerWrapper.swift
//  VideoPlayerReconstruct
//
//  Created by bo yu on 5/7/2023.
//

import Foundation
import SwiftUI

struct ViewControllerWrapper: UIViewControllerRepresentable {
    typealias UIViewControllerType = ViewController
    
    let delegate: ViewControllerDelegate
    
    func makeUIViewController(context: Context) -> ViewController {
        let viewController = ViewController(useLocalFile: delegate.getUseLocalFile())
        delegate.setViewController(viewController)
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: ViewController, context: Context) {
    }
}
