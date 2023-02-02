//
//  ContentView.swift
//  DrawingPractice
//
//  Created by Labtanza on 7/10/22.
//  https://swiftui-lab.com/swiftui-animations-part5/
//  https://medium.com/@almalehdev/high-performance-drawing-on-ios-part-2-2cb2bc957f6
//https://www.swiftbysundell.com/articles/ca-gems-using-replicator-layers-in-swift/
//https://developer.apple.com/videos/play/wwdc2021/10021/
//https://developer.apple.com/documentation/swiftui/canvas/init(opaque:colormode:rendersasynchronously:renderer:symbols:)

import SwiftUI

struct ContentView: View {
       let particleRenderer = ParticleRenderer()
    
       let myShape = CustomShape(bezierPath: logo)
    
    static var logo: UIBezierPath {
            let path = UIBezierPath()
            path.move(to: CGPoint(x: 0.534, y: 0.5816))
            path.addCurve(to: CGPoint(x: 0.1877, y: 0.088), controlPoint1: CGPoint(x: 0.534, y: 0.5816), controlPoint2: CGPoint(x: 0.2529, y: 0.4205))
            path.addCurve(to: CGPoint(x: 0.9728, y: 0.8259), controlPoint1: CGPoint(x: 0.4922, y: 0.4949), controlPoint2: CGPoint(x: 1.0968, y: 0.4148))
            path.addCurve(to: CGPoint(x: 0.0397, y: 0.5431), controlPoint1: CGPoint(x: 0.7118, y: 0.5248), controlPoint2: CGPoint(x: 0.3329, y: 0.7442))
            path.addCurve(to: CGPoint(x: 0.6211, y: 0.0279), controlPoint1: CGPoint(x: 0.508, y: 1.1956), controlPoint2: CGPoint(x: 1.3042, y: 0.5345))
            path.addCurve(to: CGPoint(x: 0.6904, y: 0.3615), controlPoint1: CGPoint(x: 0.7282, y: 0.2481), controlPoint2: CGPoint(x: 0.6904, y: 0.3615))
            return path
        }
  
        var body: some View {
            let sizeScale = 0.25
            let location = CGPoint(x:200, y:200)
            let registrationSize = CGSize(width: 200, height: 200)
            
            VStack {
                Canvas { context, size in
                    
                    let shapeWidth = sizeScale*size.width
                    let shapeHeigt = sizeScale*size.height
                    let shapeSize = CGSize(width: shapeWidth, height: shapeHeigt)
                    let shapeRect = CGRect(origin: .zero, size: shapeSize)
                    
                  
                    
                    let registrationTest = Path(roundedRect: CGRect(origin: .zero, size: registrationSize), cornerRadius: 0)
                    context.stroke(registrationTest, with: .color(.green))
                    
//                    //This behavior is very strange.
//                    //A) Remember that it is returning an IMAGE that is truncated at the bounding box.
//                    //B) apparently images render from the center instead of the top left?
//                    let box = context.resolve(particleRenderer.drawRectangle2(width: shapeWidth, height:sizeScale*size.height))
//                    context.draw(box, at: location)
//                    
//                    //context.rotate(by: Angle(degrees: -30))
//
                   
//                    //This works as expected.
                    particleRenderer.drawRectangle3(context: context, location:location, width: shapeWidth, height: shapeHeigt, anchor: .center)
//                    
//                    //confirmation that it draws images from the center.
//                    context.draw(Image(systemName: "square"), at: location)
//                    
//                    let circle = Circle().path(in: shapeRect)
//                    context.stroke(circle, with: .foreground)
//                    
//                    context.withCGContext { context in
//                        particleRenderer.drawRectangle4(cgContext: context, location: location, size: shapeSize)
//                    }
                 
//                    particleRenderer.draw(shape: myShape, context: context, location: location, width: shapeWidth, height: shapeHeigt, anchor: .topLeading)
                    
                    let newLocation = particleRenderer.adjustedOrigin(size: shapeSize, base:location, anchor: .center)
                    print("newLoaction \(newLocation)")
                    
                    let dove = particleRenderer.scaledPath(shape: myShape, size: shapeSize, origin: newLocation)
                    print("doveInfo: \(dove.getAnchors())")
                    
                    context.stroke(dove, with:.foreground)
                    
                }.border(.blue)
                //myShape
                particleRenderer.drawElipse(width: 60.0, height: 20.0)
                particleRenderer.testCanvas
                Text("Did it work???")
            }
            
            
        }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
