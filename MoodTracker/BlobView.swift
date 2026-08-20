//
//  BlobView.swift
//  MoodTracker
//
//  Created by Ngoni Katsidzira  on 20/8/2026.
//

import SwiftUI

struct BlobView: View {
    
    var color: Color
    
    var body: some View {
        Circle()
            .foregroundStyle(color.gradient)
            .frame(width: 200, height: 200)
    }
}

#Preview {
    BlobView(color: .red)
}
