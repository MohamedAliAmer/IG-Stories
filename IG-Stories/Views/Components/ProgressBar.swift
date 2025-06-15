//
//  ProgressBar.swift
//  IG-Stories
//
//  Created by Mohamed Ali on 15/6/25.
//

import SwiftUI

struct ProgressBar: View {
    let progress: Double
    let isActive: Bool
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(Color.white.opacity(0.3))
                    .frame(height: 2)
                
                Rectangle()
                    .fill(Color.white)
                    .frame(width: geometry.size.width * progress, height: 2)
                    .animation(.linear(duration: isActive ? 0.05 : 0), value: progress)
            }
        }
        .frame(height: 2)
    }
}

#Preview {
    VStack {
        ProgressBar(progress: 0.3, isActive: true)
            .frame(height: 2)
        ProgressBar(progress: 1.0, isActive: false)
            .frame(height: 2)
        ProgressBar(progress: 0.0, isActive: false)
            .frame(height: 2)
    }
    .padding()
    .background(Color.black)
}
