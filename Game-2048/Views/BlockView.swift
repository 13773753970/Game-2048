//
//  BlockView.swift
//  Game-2048
//
//  Created by zhoupeng on 2021/9/7.
//

import SwiftUI

struct BlockView: View {
    let colorScheme: [(Color, Color)] = [
        // 2
        (Color(red:0.91, green:0.87, blue:0.83, opacity:1.00), Color(red:0.42, green:0.39, blue:0.35, opacity:1.00)),
        // 4
        (Color(red:0.90, green:0.86, blue:0.76, opacity:1.00), Color(red:0.42, green:0.39, blue:0.35, opacity:1.00)),
        // 8
        (Color(red:0.93, green:0.67, blue:0.46, opacity:1.00), Color.white),
        // 16
        (Color(red:0.94, green:0.57, blue:0.38, opacity:1.00), Color.white),
        // 32
        (Color(red:0.95, green:0.46, blue:0.33, opacity:1.00), Color.white),
        // 64
        (Color(red:0.94, green:0.35, blue:0.23, opacity:1.00), Color.white),
        // 128
        (Color(red:0.91, green:0.78, blue:0.43, opacity:1.00), Color.white),
        // 256
        (Color(red:0.91, green:0.78, blue:0.37, opacity:1.00), Color.white),
        // 512
        (Color(red:0.90, green:0.77, blue:0.31, opacity:1.00), Color.white),
        // 1024
        (Color(red:0.91, green:0.75, blue:0.24, opacity:1.00), Color.white),
        // 2048
        (Color(red:0.91, green:0.74, blue:0.18, opacity:1.00), Color.white),
    ]
    
    var number: Int?
    var blockSize: CGFloat
    var textOpacity: Double
    
    init(number: Int? = nil, blockSize: CGFloat, textOpacity: Double = 1) {
        self.number = number
        self.blockSize = blockSize
        self.textOpacity = textOpacity
    }
    
    var colorPair: (Color, Color) {
        guard let number = self.number else {
            return (Color(red:0.78, green:0.73, blue:0.68, opacity:1.00), Color.black)
        }
        let index = Int(log2(Double(number))) - 1
        if index < 0 || index > self.colorScheme.count - 1 {
            fatalError("No color for such number: \(number)")
        }
        return index < colorScheme.count ? colorScheme[index] : colorScheme.last!
    }
    
    var numberText: String {
        guard let number = self.number else {
            return ""
        }
        return String(number)
    }
    
    var fontSize: CGFloat {
        let textLength = numberText.count
        if textLength < 3 {
            return 32
        } else if textLength < 4 {
            return 18
        } else {
            return 12
        }
    }
    
    var body: some View {
        Text(numberText)
            .font(.system(size: self.fontSize).bold())
            .opacity(textOpacity)
            .foregroundColor(self.colorPair.1)
            .frame(width: blockSize, height: blockSize, alignment: .center)
            .background(self.colorPair.0)
            .cornerRadius(6)
    }
}

struct BlockViewWithAnimation: View {
    var number: Int?
    var blockSize: CGFloat
    
    @State private var numberDisplay: Int?
    @State private var opacity: Double = 1
    @State private var scale: CGFloat = 1
    
    init(number: Int? = nil, blockSize: CGFloat) {
        self.number = number
        self.blockSize = blockSize
    }
    
    var body: some View {
        BlockView(number: numberDisplay, blockSize: blockSize, textOpacity: opacity)
            .scaleEffect(scale)
            .onChange(of: number, perform: { value in
                let task1 = DispatchWorkItem {
                    numberDisplay = value
                    opacity = 0
                    scale = 1
                    withAnimation(.linear(duration: 0.2)) {
                        opacity = 1
                        scale = 1.2
                    }
                }
                let task2 = DispatchWorkItem {
                    withAnimation(.linear(duration: 0.2)) {
                        scale = 1
                    }
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: task1)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: task2)
            })
            .onAppear(perform: {
                numberDisplay = number
            })
    }
}

private struct BlockViewWrapper: View {
    @State var number = 2
    
    var body: some View {
        VStack {
            BlockViewWithAnimation(number: number, blockSize: 65)
            
            Button(action: {
                number = number * 2
            }, label: {
                Text("Button")
            })
        }
    }
}

struct BlockView_Previews: PreviewProvider {
    static var previews: some View {
        BlockViewWrapper()
    }
}
