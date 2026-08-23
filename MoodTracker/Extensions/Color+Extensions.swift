//
//  Color+Extensions.swift
//  MoodTracker
//
//  Created by Ngoni Katsidzira  on 23/8/2026.
//

import SwiftUI

extension Color {
    
    func interpolated(
        to color: Color,
        fraction: Double
    ) -> Color {
        
        let fraction = min(max(fraction, 0), 1)
        
        let start = UIColor(self)
        let end = UIColor(color)
        
        var r1: CGFloat = 0
        var g1: CGFloat = 0
        var b1: CGFloat = 0
        var a1: CGFloat = 0
        
        var r2: CGFloat = 0
        var g2: CGFloat = 0
        var b2: CGFloat = 0
        var a2: CGFloat = 0
        
        start.getRed(&r1, green: &g1, blue: &b1, alpha: &a1)
        end.getRed(&r2, green: &g2, blue: &b2, alpha: &a2)
        
        return Color(
            red: Double(r1 + (r2 - r1) * fraction),
            green: Double(g1 + (g2 - g1) * fraction),
            blue: Double(b1 + (b2 - b1) * fraction),
            opacity: Double(a1 + (a2 - a1) * fraction)
        )
    }
}
