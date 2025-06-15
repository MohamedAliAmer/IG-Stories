//
//  StoryNavigationAreas.swift
//  IG-Stories
//
//  Created by Mohamed Ali on 15/6/25.
//

import SwiftUI

struct StoryNavigationAreas: View {
    let onPrevious: () -> Void
    let onNext: () -> Void
    
    var body: some View {
        HStack(spacing: 0) {
            Rectangle()
                .fill(Color.clear)
                .contentShape(Rectangle())
                .onTapGesture {
                    onPrevious()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .allowsHitTesting(true)
            
            Rectangle()
                .fill(Color.clear)
                .frame(width: 120)
                .allowsHitTesting(false)
            
            Rectangle()
                .fill(Color.clear)
                .contentShape(Rectangle())
                .onTapGesture {
                    onNext()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .allowsHitTesting(true)
        }
        .padding(.top, 120)
        .padding(.bottom, 140)
    }
}

#Preview {
    StoryNavigationAreas(
        onPrevious: { print("Previous story") },
        onNext: { print("Next story") }
    )
    .background(Color.red.opacity(0.1))
}
