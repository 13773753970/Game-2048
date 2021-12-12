//
//  RootReducer.swift
//  Game-2048
//
//  Created by 周鹏 on 2021/12/9.
//

import Foundation
import Redux

struct InitialAction: Action {}

func rootReducer(state: AppState? = nil, action: Action = InitialAction()) -> AppState {
    return AppState(
        game: persistentGameReducer(state?.game, action)
    )
}
