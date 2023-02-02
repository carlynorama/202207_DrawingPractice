//
//  Shapes.swift
//  CarmenH
//
//  Created by Carlyn Maw on 9/14/20.
//  Copyright © 2020 carlynorama. All rights reserved.
//

import SwiftUI

struct Shapes: View {
    var body: some View {
        ZStack {
            Triangle(scalarTop: 0.5, scalarTrailing: 1, scalarLeading: 1)
        }
    }
}

struct Diamond: Shape {
    func path(in rect: CGRect) -> Path {
        Path { path in
            let width = rect.width
            let height = rect.height
            
            path.addLines([
                CGPoint(x: width/2, y: 0),
                CGPoint(x: width, y: height/2),
                CGPoint(x: width/2, y: height),
                CGPoint(x: 0, y: height/2)
            ])
            path.closeSubpath()
        }
    }
}



struct DiamondEQ: Shape {
    func path(in rect: CGRect) -> Path {
        Path { path in
            let width = rect.width
            let height = rect.height
            
            let size = min(width, height)
            
            path.addLines([
                CGPoint(x: size/2, y: 0),
                CGPoint(x: size, y: size/2),
                CGPoint(x: size/2, y: size),
                CGPoint(x: 0, y: size/2)
            ])
            path.closeSubpath()
        }
    }
}

struct IsoscelesTriangle: Shape {
    let yscalar:CGFloat
    
    init() {
        yscalar = 1
    }
    
    init(heightScalar ys:CGFloat) {
        yscalar = ys
    }
    
    func path(in rect: CGRect) -> Path {
        Path { path in
            let width = rect.width
            let height = rect.height
            
            path.addLines([
                CGPoint(x: width/2, y: height * (CGFloat(1.0)-yscalar)),
                CGPoint(x: width, y: height),
                CGPoint(x: 0, y: height)
            ])
            path.closeSubpath()
        }
    }
}

struct Triangle: Shape {
    let scalarTop:CGFloat
    let scalarTrailing:CGFloat
    let scalarLeading:CGFloat
    
    func path(in rect: CGRect) -> Path {
        Path { path in
            let width = rect.width
            let height = rect.height
            
            path.addLines([
                CGPoint(x: width*scalarTop, y: 0),
                CGPoint(x: width, y: height*scalarTrailing),
                CGPoint(x: 0, y: height*scalarLeading)
            ])
            path.closeSubpath()
        }
    }
}

struct RightTriangle: Shape {
    func path(in rect: CGRect) -> Path {
        Path { path in
            let width = rect.width
            let height = rect.height
            
            path.addLines([
                CGPoint(x: width, y: 0),
                CGPoint(x: width, y: height),
                CGPoint(x: 0, y: height)
            ])
            path.closeSubpath()
        }
    }
}

struct Shapes_Previews: PreviewProvider {
    static var previews: some View {
        Shapes()
    }
}
