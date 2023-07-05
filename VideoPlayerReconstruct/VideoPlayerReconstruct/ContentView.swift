//
//  ContentView.swift
//  VideoPlayerReconstruct
//
//  Created by bo yu on 4/7/2023.
//

import SwiftUI

struct ContentView: View {
    @State private var isVideoPlayerPresented: Bool = false
    @StateObject private var viewControllerDelegate = ViewControllerDelegate()

    /*
    var body: some View {
        NavigationStack {
            VStack {
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundColor(.accentColor)
                Text("Hello, world!")
                Text("Welcome to My App")
                    .font(.largeTitle)


                Button(action: {
                    isVideoPlayerPresented = true
                }) {
                    Text("Open Video Player")
                        .font(.title)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()

            }
            .navigationTitle("Home")
            .navigationDestination(isPresented: $isVideoPlayerPresented) {
                MyVideoPlayer()
            }
        }
    }
    */
        
    // /*
    var body: some View {
        NavigationView {
            VStack {
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundColor(.accentColor)
                Text("Hello, world!")
                Text("Welcome to My App")
                    .font(.largeTitle)
                
                Button(action: {
                    viewControllerDelegate.toggleFileOption()
                }) {
                    Text("Toggle File Option")
                        .font(.title)
                        .padding()
                        .background(Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()
                
                Button(action: {
                    isVideoPlayerPresented = true
                }) {
                    Text("Open Video Player")
                        .font(.title)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()
                
            }
            // .navigationTitle("Home")
            .navigationBarTitle("Home")
            /*
            .background(ViewControllerWrapper(delegate: viewControllerDelegate))
             */
            .sheet(isPresented: $isVideoPlayerPresented) {
                ViewControllerWrapper(delegate: viewControllerDelegate)
            }
            /*
            .sheet(isPresented: $isVideoPlayerPresented) {
                MyVideoPlayer()
            }
             */
        }
    }
    // */
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
