//
//  ParticleView.swift
//  DrawingPractice
//
//  Created by Labtanza on 7/12/22.
//

import SwiftUI

struct ParticleView:View {
    //let rect:CGRect
    let color:Color
    
    var body: some View {
        VStack(alignment: .center) {
            
            ScaledToFit(bezierPath: anotherShape).stroke(color, style: (StrokeStyle(lineWidth: 20.0))).border(.black)//.aspectRatio((Path(anotherShape.cgPath).naturalAspectRatio), contentMode: .fit).border(.black)
            ScaledView(bezierPath: anotherShape).border(.black)
            Circle().size(width: 40, height: 40).border(.black)
            Circle().stroke(color, style: (StrokeStyle(lineWidth: 20.0)))
            ScaledToAspect(bezierPath: anotherShape).stroke(color, style: (StrokeStyle(lineWidth: 20.0))).border(.green)
            DiamondEQ().border(.black)
            ScaledToFill(bezierPath: anotherShape).stroke(color, style: (StrokeStyle(lineWidth: 20.0))).aspectRatio((Path(anotherShape.cgPath).naturalAspectRatio), contentMode: .fit).border(.black)
            ScaledToFit(bezierPath: testRecPath).stroke(color, style: (StrokeStyle(lineWidth: 20.0))).aspectRatio((Path(testRecPath.cgPath).naturalAspectRatio), contentMode: .fit).border(.black)

            Text("Hello?")
            //Circle().fill(color).opacity(0.5)
            //Circle().stroke(color, style: (StrokeStyle(lineWidth: 20.0)))
            Button("print scaled") {
                printScaled(bezierPath: anotherShape, rect:CGRect(x: 0, y: 0, width: 1, height: 1))
            }
        }
    }
}



struct ParticleView_Previews: PreviewProvider {
    static var previews: some View {
        ParticleView(color: .blue)
    }
}
