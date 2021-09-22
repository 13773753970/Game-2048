//
//  StarShape.swift
//  Game-2048
//
//  Created by zhoupeng on 2021/9/18.
//

import SwiftUI

struct StarShape: Shape {
    func path(in rect: CGRect) -> Path {
        let h = Double(min(rect.width, rect.height) / 2)
        let c = CGPoint(x: rect.width / 2, y: rect.height / 2)
        let angle = 360 / 5 / 180 * Double.pi
        var points: [CGPoint] = []
        for i in 0..<5 {
            points.append(CGPoint(x: c.x + CGFloat(sin(angle * Double(i)) * h), y: c.y - CGFloat(cos(angle * Double(i)) * h)))
        }
        var path = Path()
        path.addLines([points[0], points[2], points[4], points[1], points[3], points[0]])
        return path
    }
}

struct StarShape_Previews: PreviewProvider {
    static var previews: some View {
        StarShape()
            .fill(Color.red)
//            .stroke(Color.blue)
    }
}
