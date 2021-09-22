//
//  MenuLogoView.swift
//  Game-2048
//
//  Created by zhoupeng on 2021/9/18.
//

import SwiftUI

struct MenuLogoView: View {
    @EnvironmentObject var gameLogic: GameLogic
    
    var body: some View {
        ZStack {
            ZStack(alignment: .center) {
                StarShape()
                    .fill(Color(red: 1, green: 1, blue: 1, opacity: 1))
                    .scaleEffect(0.2)
                StarShape()
                    .fill(Color(red: 1, green: 1, blue: 1, opacity: 1))
                    .scaleEffect(0.2)
                    .offset(x: -25, y: 0)
                StarShape()
                    .fill(Color(red: 1, green: 1, blue: 1, opacity: 1))
                    .scaleEffect(0.2)
                    .offset(x: 25, y: 0)
            }
            .offset(x: 0, y: -35)
                
            Text("2048")
                .foregroundColor(.white)
                .font(.system(size: 33))
                .bold()
            
            Text("\(gameLogic.gridRows) x \(gameLogic.gridRows)")
                .foregroundColor(.white)
                .font(.system(size: 14))
                .bold()
                .offset(x: 0, y: 35)
        }
        .frame(width: 100, height: 100, alignment: .center)
        .background(Color.yellow)
        .cornerRadius(3)
        .clipped()
    }
}

struct MenuLogoView_Previews: PreviewProvider {
    static var previews: some View {
        MenuLogoView()
            .environmentObject(GameLogic())
    }
}
