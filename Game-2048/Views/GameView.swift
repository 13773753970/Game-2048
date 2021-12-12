//
//  GameView.swift
//  Game-2048
//
//  Created by zhoupeng on 2021/9/6.
//

import SwiftUI

struct GameView: View {
    @EnvironmentObject var store: AppStore
    
    var content: some View {
        GeometryReader { proxy in
            VStack {
                HStack {
                    MenuLogoView()
                    VStack {
                        ScoreView(text: "得分", score: store.state.game.score)
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
                        ScoreView(text: "最高分", score: store.state.game.score)
                        Button(action: {
                            store.dispatch(GameRestartAction())
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
                
                BlockGridView(blocks: store.state.game.existBlocks, gridRows: store.state.game.gridRows)
                
                HStack(spacing: 10) {
                    Button(action: {
                        store.dispatch(GameUpAction())
                    }, label: {
                        Text("👆")
                    })
                    Button(action: {
                        store.dispatch(GameDownAction())
                    }, label: {
                        Text("👇")
                    })
                    Button(action: {
                        store.dispatch(GameLeftAction())
                    }, label: {
                        Text("👈")
                    })
                    Button(action: {
                        store.dispatch(GameRightAction())
                    }, label: {
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
            .environmentObject(createStore())
    }
}
