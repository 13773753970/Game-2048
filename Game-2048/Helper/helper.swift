//
//  helper.swift
//  Game-2048
//
//  Created by zhoupeng on 2021/9/16.
//

import Foundation

enum Extrapolation {
    case CLAMP
    case IDENTITY
    case EXTEND
}

func createLinearEquation(pointA: (x: Float, y: Float), pointB: (x: Float, y: Float)) -> (Float) -> Float {
    if pointA.x == pointB.x {
        fatalError("createLinearEquation pointA.x == pointB.x. x: \(pointA.x)")
    }
    let slope = (pointB.y - pointA.y) / (pointB.x - pointA.x)
    let diff = pointA.y - pointA.x * slope
    return { x in
        slope * x + diff
    }
}

// @pure create linear interpolate value e.g.,
// var valueB = interpolate(valueA, [0, 1], [0, 5])
// when valueA == 0.5, then valueB == 2.5
func interpolate(value: Float, inputRange: [Float], outputRange: [Float], extrapolation: (Extrapolation, Extrapolation)) -> Float {
    if inputRange.count < 2 || outputRange.count < 2 {
        fatalError("interpolate inputRange or outputRange count < 2. Parameters: inputRange: \(inputRange.description), outputRange: \(outputRange.description)")
    }
    if inputRange.count != outputRange.count {
        fatalError("interpolate inputRange count != outputRange count. Parameters: inputRange: \(inputRange.description), outputRange: \(outputRange.description)")
    }
    if !inputRange.isAscend {
        fatalError("interpolate inputRange or outputRange not ascend. Parameters: inputRange: \(inputRange.description), outputRange: \(outputRange.description)")
    }
    let count = inputRange.count
    if value < inputRange[0] {
        switch extrapolation.0 {
        case Extrapolation.CLAMP:
            return outputRange[0]
        case Extrapolation.IDENTITY:
            return inputRange[0]
        case Extrapolation.EXTEND:
            return createLinearEquation(pointA: (inputRange[0], outputRange[0]), pointB: (inputRange[1], outputRange[1]))(value)
        }
    }
    if value > inputRange[count - 1] {
        switch extrapolation.1 {
        case Extrapolation.CLAMP:
            return outputRange[count - 1]
        case Extrapolation.IDENTITY:
            return inputRange[count - 1]
        case Extrapolation.EXTEND:
            return createLinearEquation(pointA: (inputRange[count - 2], outputRange[count - 2]), pointB: (inputRange[count - 1], outputRange[count - 1]))(value)
        }
    }
    for i in 1..<count {
        if value <= inputRange[i] {
            return createLinearEquation(pointA: (inputRange[i - 1], outputRange[i - 1]), pointB: (inputRange[i], outputRange[i]))(value)
        }
    }
    fatalError("interpolate have some internal error")
}

func interpolate(value: Float, inputRange: [Float], outputRange: [Float], extrapolation: Extrapolation = Extrapolation.EXTEND) -> Float {
    interpolate(value: value, inputRange: inputRange, outputRange: outputRange, extrapolation: (extrapolation, extrapolation))
}
