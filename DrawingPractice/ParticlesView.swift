//
//  ParticlesView.swift
//  DrawingPractice
//
//  Created by Labtanza on 7/11/22.
//

import SwiftUI

fileprivate let rects:[CGRect] = [
    (CGRect(origin: CGPoint(x: 0.0, y: 150.0), size:CGSize(width: 12.0, height: 12.0))),
    (CGRect(origin: CGPoint(x: 50.0, y: 16.0), size:CGSize(width: 12.0, height: 12.0))),
    (CGRect(origin: CGPoint(x: 200.0, y: 4.0), size:CGSize(width: 12.0, height: 12.0))),
    (CGRect(origin: CGPoint(x: 142.0, y: 63.0), size:CGSize(width: 12.0, height: 12.0))),
    (CGRect(origin: CGPoint(x: 3.0, y: 126.0), size:CGSize(width: 12.0, height: 12.0)))
]

fileprivate func generateRects(quantity:Int) -> [CGRect] {
    var rects:[CGRect] = []
    
    for _ in (0..<quantity) {
        let size = Int.random(in: 5...20)
        rects.append(CGRect(x: Int.random(in: 0...300), y: Int.random(in: 0...200), width: size, height: size*2))
    }
    return rects
}

struct ParticlesView<Mark: View>: View {
    let rects: [CGRect]
    let mark: Mark


    enum SymbolID: Int {
        case mark
    }


    var body: some View {
        Canvas { context, size in
            if let mark = context.resolveSymbol(id: SymbolID.mark) {
                for rect in rects {
                    var particleContext = context
                    particleContext.translateBy(x: rect.origin.x, y: rect.origin.y)
                    particleContext.rotate(by: Angle(degrees: Double.random(in: 0...85)))
                    let newRect = CGRect(origin: .zero, size: rect.size)
                    particleContext.draw(mark, in: newRect)
                }
            }
        } symbols: {
            mark.tag(SymbolID.mark)
        }
        .frame(width: 300, height: 200)
        .border(Color.blue)
    }
}

//struct ParticleView:View {
//    //let rect:CGRect
//    let color:Color
//    
//    var body: some View {
//        ZStack {
//            Circle().fill(color).opacity(0.5)
//            Circle().stroke(color, style: (StrokeStyle(lineWidth: 20.0)))
//        }
//    }
//}


//M1083.05,636.351C1026.88,596.092 831.474,641.36 788.353,677.806C734.645,723.201 737.399,820.269 757.411,868.725C787.156,940.744 984.407,893.147 1061.84,858.849C1132.37,827.612 1147.27,682.378 1083.05,636.351Z

struct ParticlesView_Previews: PreviewProvider {
    static var previews: some View {
        ParticlesView(rects: generateRects(quantity: 20), mark: ParticleView(color: .blue))
    }
}
