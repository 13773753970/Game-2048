//
//  TestView.swift
//  Game-2048
//
//  Created by zhoupeng on 2021/9/11.
//

import SwiftUI

struct PolygonShape: Shape {
    var sides: Double
    var scale: Double
    
    var animatableData: AnimatablePair<Double, Double> {
        get { AnimatablePair(sides, scale) }
        set {
            sides = newValue.first
            scale = newValue.second
        }
    }
    
    init(sides: Int, scale: Double) {
        self.sides = Double(sides)
        self.scale = scale
    }
    
    func path(in rect: CGRect) -> Path {
        // hypotenuse
        let h = Double(min(rect.size.width, rect.size.height)) / 2.0
        
        // center
        let c = CGPoint(x: rect.size.width / 2.0, y: rect.size.height / 2.0)
        
        var path = Path()
        
        let extra: Int = Double(sides) != Double(Int(sides)) ? 1 : 0
                
        for i in 0..<Int(sides) + extra {
            let angle = (Double(i) * (360.0 / Double(sides))) * Double.pi / 180

            // Calculate vertex position
            let pt = CGPoint(x: c.x + CGFloat(cos(angle) * h), y: c.y + CGFloat(sin(angle) * h))
            
            if i == 0 {
                path.move(to: pt) // move to first vertex
            } else {
                path.addLine(to: pt) // draw line to next vertex
            }
        }
        
        path.closeSubpath()
        
        return path
    }
}

struct Wrapper: View {
    @State var sides: Int = 1
    @State var scale: Double = 1
    
    var body: some View {
        VStack {
            PolygonShape(sides: sides, scale: scale)
                .stroke(Color.blue, lineWidth: 3)
                .frame(width: 300, height: 300, alignment: .center)
                .animation(.easeInOut(duration: 2))
            
            HStack {
                Button(action: {
                    sides = 1
                    scale = 1
                }, label: {
                    Text("1")
                        .foregroundColor(.white)
                        .font(.system(size: 18))
                        .frame(width: 50, height: 35, alignment: .center)
                        .background(Color.green)
                        .cornerRadius(6)
                })
                Button(action: {
                    sides = 3
                    scale = 0.7
                }, label: {
                    Text("3")
                        .foregroundColor(.white)
                        .font(.system(size: 18))
                        .frame(width: 50, height: 35, alignment: .center)
                        .background(Color.green)
                        .cornerRadius(6)
                })
                Button(action: {
                    sides = 7
                    scale = 0.4
                }, label: {
                    Text("7")
                        .foregroundColor(.white)
                        .font(.system(size: 18))
                        .frame(width: 50, height: 35, alignment: .center)
                        .background(Color.green)
                        .cornerRadius(6)
                })
                Button(action: {
                    sides = 30
                    scale = 1
                }, label: {
                    Text("30")
                        .foregroundColor(.white)
                        .font(.system(size: 18))
                        .frame(width: 50, height: 35, alignment: .center)
                        .background(Color.green)
                        .cornerRadius(6)
                })
            }
        }
    }
}

struct A: View {
    var body: some View {
        Text("Hello World")
            .foregroundColor(.black)
            .transition(.opacity.animation(.linear(duration: 2)))
    }
}

struct AWrapper: View {
    @State private var show: Bool = false
    
    var body: some View {
        VStack {
            if show {
                A()
            }
            Button(action: {
                show.toggle()
            }, label: {
                Text("Toggle")
            })
        }
    }
}

struct ExampleView_Previews: PreviewProvider {
    static var previews: some View {
        AWrapper()
    }
}
