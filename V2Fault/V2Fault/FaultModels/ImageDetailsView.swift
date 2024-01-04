//
//  ImageDetailsView.swift
//  V2Fault
//
//  Created by bo yu on 4/1/2024.
//

import Foundation
import SwiftUI

struct ImageDetailsView: View {
    let image: UIImage

    var body: some View {
        VStack {
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding()

            // Add additional details or controls as needed
        }
        .padding()
    }
}
