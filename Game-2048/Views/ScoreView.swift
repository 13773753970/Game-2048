//
//  ScoreView.swift
//  Game-2048
//
//  Created by zhoupeng on 2021/9/20.
//

import SwiftUI

struct ScoreView: View {
    var text: String
    var score: Int
    
    var body: some View {
        Rectangle()
            .fill(Color.gray)
            .frame(width: 85, height: 60, alignment: .center)
            .cornerRadius(3.0)
            .overlay(
                VStack(spacing: 3) {
                    Text(text)
                        .foregroundColor(Color(red: 255, green: 255, blue: 255, opacity: 0.6))
                        .font(.system(size: 15))
                    Text(String(score))
                        .foregroundColor(Color(red: 255, green: 255, blue: 255))
                        .font(.system(size: 22))
                }
            )
    }
}

struct ScoreView_Previews: PreviewProvider {
    static var previews: some View {
        ScoreView(text: "得分", score: 60)
    }
}
