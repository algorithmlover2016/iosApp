//
//  ContentView.swift
//  VideoPlayerReconstruct
//
//  Created by bo yu on 4/7/2023.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        /*
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
            
        }
        .padding()
        */
        MyVideoPlayer()
    }
}


struct MyVideoPlayer: UIViewControllerRepresentable {
    typealias UIViewControllerType = ViewController
    
    func makeUIViewController(context: Context) -> ViewController {
        return ViewController()
    }
    
    func updateUIViewController(_ uiViewController: ViewController, context: Context) {
        // You can perform any necessary updates here
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
