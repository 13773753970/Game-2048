//
//  Game_2048App.swift
//  Game-2048
//
//  Created by zhoupeng on 2021/9/6.
//

import SwiftUI

@main
struct Game_2048App: App {
    @StateObject private var store: AppStore = createStore()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(store)
        }
    }
}
