//
//  ScatterPlotView.swift
//  DrawingPractice
//
//
// https://developer.apple.com/documentation/swiftui/canvas/init(opaque:colormode:rendersasynchronously:renderer:symbols:)

import SwiftUI

fileprivate let rects:[CGRect] = [(CGRect(origin: CGPoint(x: 0.0, y: 0.0), size:CGSize(width: 12.0, height: 12.0)))]

struct ScatterPlotView<Mark: View>: View {
    let rects: [CGRect]
    let mark: Mark


    enum SymbolID: Int {
        case mark
    }


    var body: some View {
        Canvas { context, size in
            if let mark = context.resolveSymbol(id: SymbolID.mark) {
                for rect in rects {
                    context.draw(mark, in: rect)
                }
            }
        } symbols: {
            mark.tag(SymbolID.mark)
        }
        .frame(width: 300, height: 200)
        .border(Color.blue)
    }
}

struct ScatterPlotView_Previews: PreviewProvider {
    static var previews: some View {
        ScatterPlotView(rects: rects, mark: Image(systemName: "circle"))
    }
}
