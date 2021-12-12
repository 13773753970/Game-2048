//
//  createStore.swift
//  Game-2048
//
//  Created by 周鹏 on 2021/12/9.
//

import Foundation
import Redux
import SwiftyBeaver

typealias AppStore = Store<AppState, Action>

func createStore() -> AppStore {
    let log = SwiftyBeaver.self
//    clearPersistentState()
    let console = ConsoleDestination()
    console.levelString.info = "REDUX"
    console.asynchronously = true
    console.format = "$L $C$M$c: $X"
    log.addDestination(console)
    log.info("SwiftReduxExampleApp init")
    return Store(
        initialState: rootReducer(),
        reducer: rootReducer,
        enhancer: createLogMiddleware({ message, obj in
            log.info(message, context: obj)
        }))
}
