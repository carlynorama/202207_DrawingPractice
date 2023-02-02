//
//  ParticleRenderer.swift
//  Wind
//
//  Created by Labtanza on 7/10/22.
//

import Foundation
import SwiftUI




final class ParticleRenderer {
    
    //https://nshipster.com/rawrepresentable/
    enum AnchorPoint {
        case topLeading
        case center
        case random
        case arbitrary(CGPoint)
        
        var scalePoint:CGPoint {
            switch self {
            case .topLeading:
                return CGPoint(x: 0, y: 0)
            case .center:
                return CGPoint(x: -0.5, y: -0.5)
            case .random:
                return CGPoint(x: CGFloat.random(in: 0...1), y: CGFloat.random(in: 0...1))
            case .arbitrary(let point):
                return point
            }
        }
        
        func locationForSize(_ size:CGSize) -> CGPoint {
            let point = self.scalePoint
            let x = (size.width * point.x)
            let y = (size.height * point.y)
            return CGPoint(x: x, y: y)
        }
    }
    
    struct viewTest:View {
        var body: some View {
            Text("I'm here.")
        }
    }

    
    func drawRectangle() -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))

        let img = renderer.image { ctx in
            let rectangle = CGRect(x: 0, y: 0, width: 512, height: 512)

            ctx.cgContext.setFillColor(UIColor.red.cgColor)
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.setLineWidth(10)

            ctx.cgContext.addRect(rectangle)
            ctx.cgContext.drawPath(using: .fillStroke)
        }

        return img
    }
    
    
    func drawRectangle2(width:Double, height:Double, anchor:AnchorPoint = .topLeading) -> Image {
        let size = CGSize(width: width, height: height)
        print("anchor: \(anchor)")
        let anchorForSize = anchor.locationForSize(size)
        print("anchorForSize: \(anchorForSize)")
        let renderer = UIGraphicsImageRenderer(size: size)

        let img = renderer.image { ctx in
            //let rectangle = CGRect(origin:CGPoint(x:0, y: 0), size: size)
            let rectangle = CGRect(origin:anchorForSize, size: size)

            ctx.cgContext.setFillColor(UIColor.red.cgColor)
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.setLineWidth(10)

            ctx.cgContext.addRect(rectangle)
            ctx.cgContext.drawPath(using: .fillStroke)
        }

        return Image(uiImage: img)
    }
    
    func drawElipse(width:Double, height:Double, anchor:AnchorPoint = .topLeading) -> some View {
        let size = CGSize(width: width, height: height)
        print("anchor: \(anchor)")
        let anchorForSize = anchor.locationForSize(size)
        print("anchorForSize: \(anchorForSize)")
        
        let layer = Canvas { context, size in
            context.fill(
                    Path(ellipseIn: CGRect(origin: .zero, size: size)),
                    with: .color(.green))
        }
        return layer.frame(width: size.width, height: size.height)
    }
    
//    func draw(shape:any Shape, context:GraphicsContext, location:CGPoint, width:Double, height:Double, anchor:AnchorPoint = .topLeading) {
//        var localContext = context
//        let size = CGSize(width: width, height: height)
//        print("anchor: \(anchor)")
//
//
//        let scaledPath = shape.path(in: CGRect(origin: .zero, size: size))
//        //TODO: More test cases of which size to use??
//        let scaledSize = scaledPath.cgPath.boundingBoxOfPath.size
//
//        let registrationTest = Path(roundedRect: CGRect(origin: location, size: scaledSize), cornerRadius: 0)
//        context.stroke(registrationTest, with: .color(.blue))
//
//        let anchorForSize = anchor.locationForSize(size)
//        print("anchorForSize: \(anchorForSize)")
//
//        let origin = CGPoint(x: (anchorForSize.x + location.x), y: (anchorForSize.y + location.y))
//        print(origin)
//
//        print(scaledPath.getAnchors())
//        //let rectangle = CGRect(origin:anchorForSize, size: size)
//        localContext.translateBy(x: origin.x, y: origin.y)
//
//        localContext.fill(scaledPath, with: .color(.blue))
//
//    }
    func draw(shape:any Shape, context:GraphicsContext, location:CGPoint, width:Double, height:Double, anchor:AnchorPoint = .topLeading) {
        var localContext = context
        
        let size = CGSize(width: width, height: height)
        let scaledPath = scaledPath(shape:shape, size:size)
        let origin = adjustedOrigin(size: size, base: location, anchor: anchor)

        localContext.translateBy(x: origin.x, y: origin.y)
        localContext.fill(scaledPath, with: .color(.blue))
    }
    
    func scaledPath(shape: any Shape, size:CGSize, origin:CGPoint = .zero) -> Path {
        shape.path(in: CGRect(origin: origin, size: size)).offsetBy(dx: origin.x, dy: origin.y)
    }
    
    func adjustedOrigin(size:CGSize, base:CGPoint = .zero, anchor:AnchorPoint = .topLeading) -> CGPoint {
        //print("anchor: \(anchor)")
        
        let locationAdjustment = anchor.locationForSize(size)
        //print("anchorForSize: \(anchorForSize)")
        
        //PSVector could do it as a +
        let origin = CGPoint(x: (locationAdjustment.x + base.x), y: (locationAdjustment.y + base.y))
        //print(origin)
        return origin
    }

    
    func drawRectangle3(context:GraphicsContext, location:CGPoint, width:Double, height:Double, anchor:AnchorPoint = .topLeading) {
        let size = CGSize(width: width, height: height)
        print("anchor: \(anchor)")
        let anchorForSize = anchor.locationForSize(size)
        print("anchorForSize: \(anchorForSize)")
        
        let origin = CGPoint(x: (anchorForSize.x + location.x), y: (anchorForSize.y + location.y))
        
        let registrationTest = Path(roundedRect: CGRect(origin: location, size: size), cornerRadius: 0)
        context.stroke(registrationTest, with: .color(.green))
        
        //let rectangle = CGRect(origin:anchorForSize, size: size)
        context.fill(
                    Path(ellipseIn: CGRect(origin: origin, size: size)),
                    with: .color(.green))
        
        //return layer

    }
    
    func drawRectangle4(cgContext:CGContext, location:CGPoint, size:CGSize) {
        let rectangle = CGRect(origin: location, size: size)

        cgContext.setFillColor(UIColor.red.cgColor)
        cgContext.setStrokeColor(UIColor.black.cgColor)
        cgContext.setLineWidth(10)

        cgContext.addRect(rectangle)
        cgContext.drawPath(using: .fillStroke)

    }
    
//    //https://www.hackingwithswift.com/quick-start/swiftui/how-to-convert-a-swiftui-view-to-an-image
//    extension View {
//        func snapshot() -> UIImage {
//            let controller = UIHostingController(rootView: self)
//            let view = controller.view
//
//            let targetSize = controller.view.intrinsicContentSize
//            view?.bounds = CGRect(origin: .zero, size: targetSize)
//            view?.backgroundColor = .clear
//
//            let renderer = UIGraphicsImageRenderer(size: targetSize)
//
//            return renderer.image { _ in
//                view?.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
//            }
//        }
//    }
    
    //WORKS! Returns a View
    //see https://developer.apple.com/documentation/swiftui/canvas/init(opaque:colormode:rendersasynchronously:renderer:)
    var testCanvas:Canvas<EmptyView> {
        Canvas { context, size in
            let rect = CGRect(origin: .zero, size: size).insetBy(dx: 25, dy: 25)

            // Path
            let path = Path(roundedRect: rect, cornerRadius: 35.0)

            // Gradient
            let gradient = Gradient(colors: [.green, .blue])
            let from = rect.origin
            let to = CGPoint(x: rect.width + from.x, y: rect.height + from.y)
            
            // Stroke path
            context.stroke(path, with: .color(.blue), lineWidth: 25)
            
            // Fill path
            context.fill(path, with: .linearGradient(gradient,
                                                     startPoint: from,
                                                     endPoint: to))
        }
    }
}


