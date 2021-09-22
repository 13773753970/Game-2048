//
//  GameView.swift
//  Game-2048
//
//  Created by zhoupeng on 2021/9/6.
//

import SwiftUI

struct GameView: View {
    @EnvironmentObject var gameLogic: GameLogic
    
    var content: some View {
        GeometryReader { proxy in
            VStack {
                HStack {
                    MenuLogoView()
                    VStack {
                        ScoreView(text: "得分", score: gameLogic.score)
                        Button(action: {
                            
                        }, label: {
                            Text("菜单")
                                .font(.system(size: 15))
                                .foregroundColor(.white)
                                .frame(width: 85, height: 30, alignment: .center)
                                .background(Color.orange)
                                .cornerRadius(3)
                        })
                    }
                    VStack {
                        ScoreView(text: "最高分", score: gameLogic.score)
                        Button(action: {
                            gameLogic.restartAction()
                        }, label: {
                            Text("新游戏")
                                .font(.system(size: 15))
                                .foregroundColor(.white)
                                .frame(width: 85, height: 30, alignment: .center)
                                .background(Color.orange)
                                .cornerRadius(3)
                        })
                    }
                }
                .padding(.bottom, 20)
                
                BlockGridView(blocks: gameLogic.existBlocks, gridRows: gameLogic.gridRows)
                
                HStack(spacing: 10) {
                    Button(action: gameLogic.upAction, label: {
                        Text("👆")
                    })
                    Button(action: gameLogic.downAction, label: {
                        Text("👇")
                    })
                    Button(action: gameLogic.leftAction, label: {
                        Text("👈")
                    })
                    Button(action: gameLogic.rightAction, label: {
                        Text("👉")
                    })
                }
            }
            .frame(width: proxy.size.width, height: proxy.size.height, alignment: .center)
            .background(
                Rectangle()
                    .fill(Color(red: 0.96, green: 0.94, blue: 0.90))
                    .edgesIgnoringSafeArea(.all)
            )
        }
    }
    
    var body: some View {
        content
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
            .environmentObject(GameLogic())
    }
}
