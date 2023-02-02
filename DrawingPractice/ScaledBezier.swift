//
//  Path+Shape.swift
//  DrawingPractice
//
//  Created by Labtanza on 7/11/22.
//
//TODO: Make shadows
//https://www.hackingwithswift.com/articles/155/advanced-uiview-shadow-effects-using-shadowpath
//WHAT. There is a whole Emitter class already? https://www.hackingwithswift.com/articles/151/how-to-create-a-snow-scene-with-core-animation

import SwiftUI

//https://www.hackingwithswift.com/quick-start/swiftui/how-to-use-uibezierpath-and-cgpath-in-swiftui
//https://www.hackingwithswift.com/books/ios-swiftui/paths-vs-shapes-in-swiftui

//Option 1
struct ScaledBezier: Shape {
    let bezierPath: UIBezierPath
    
    func path(in rect: CGRect) -> Path {
        let path = Path(bezierPath.cgPath)
        // Figure out how much bigger we need to make our path in order for it to fill the available space without clipping.
        let multiplier = min(rect.width, rect.height)
        
        // Create an affine transform that uses the multiplier for both dimensions equally.
        let transform = CGAffineTransform(scaleX: multiplier, y: multiplier)
        
        // Apply that scale and send back the result.
        return path.applying(transform)
    }
}

//Option 2



extension Path {
    func scaled(toFit rect: CGRect) -> Path {
        // Figure out how much bigger we need to make our path in order for it to fill the available space without clipping.
        let multiplier = min(rect.width, rect.height)
        // Create an affine transform that uses the multiplier for both dimensions equally.
        let  transform = CGAffineTransform(translationX: rect.origin.x, y: rect.origin.y)
        let dual = transform.concatenating(CGAffineTransform(scaleX: multiplier , y: multiplier))
        return applying(dual)
    }
    
    func scaled(toFill rect: CGRect) -> Path {
        //let translate =
        //let  transform = CGAffineTransform(translationX: rect.origin.x, y: rect.origin.y)
//        let dual = transform.concatenating(CGAffineTransform(scaleX: rect.width, y: rect.height))
        let transform = CGAffineTransform(scaleX: rect.width, y: rect.height)
        return applying(transform)
    }
}

struct CustomShape: Shape {
    var bezierPath:UIBezierPath
    
    //var prefered render style? To Fill to Fit, "Real Size", preserve aspect ratio?
    
    func path(in rect: CGRect) -> Path {
        print("requested rect:\(rect)")
        print("expected aspect ratio:\(rect.width/rect.height)")
        let path = Path(bezierPath.cgPath)
        let scaled = path.scaled(toFill: rect)
        print("Aspect Ratio from Custom Shape: \(scaled.naturalAspectRatio)")
        return scaled
    }
    
}

//Option 3
//From SVG Parser
extension CGPath {
    func transformToFit(maxDimension: Double) -> CGAffineTransform {
        let maximumDimension = max(boundingBoxOfPath.width, boundingBoxOfPath.height)
        let scale = maximumDimension == 0 ? 1 : 1/maximumDimension
        return CGAffineTransform.identity
            .scaledBy(x: scale * maxDimension, y: scale * maxDimension)
            .translatedBy(x: -boundingBoxOfPath.minX, y: -boundingBoxOfPath.minY)
    }
    
//    func transformToFit(rect: CGRect, preserveAspectRatio:Bool = true) -> CGAffineTransform {
//        if preserveAspectRatio {
//            let maximumDimension = max(boundingBoxOfPath.width, boundingBoxOfPath.height)
//            let scale = maximumDimension == 0 ? 1 : 1/maximumDimension
//            return CGAffineTransform.identity
//                .scaledBy(x: scale * maxDimension, y: scale * maxDimension)
//                .translatedBy(x: -boundingBoxOfPath.minX, y: -boundingBoxOfPath.minY)
//        } else {
//
//        }
//    }
}

//THIS IS THE CORRECT BEHAVIOR
struct ScaledToFit:Shape {
        let bezierPath: UIBezierPath
        
        func path(in rect: CGRect) -> Path {
            
            let bounds = bezierPath.cgPath.boundingBoxOfPath
            var multiplier = 1.0
            
            let aspectRatioOP = bounds.width/bounds.height
            let aspectRatioRect = rect.width/rect.height
            
            if aspectRatioOP > aspectRatioRect {
                multiplier = rect.width/bounds.width
            } else {
                multiplier = rect.height/bounds.height
            }
            
            let path = Path(bezierPath.cgPath)
            
            let transform = CGAffineTransform.identity.scaledBy(x: multiplier , y: multiplier)
            
            return path.applying(transform)
        }
}

struct ScaledView:View {
    let bezierPath:UIBezierPath
    
    var body: some View {
        Group {
            ScaledToFit(bezierPath: bezierPath).aspectRatio(aspectRatio, contentMode: .fit)
        }
    }
    
    var aspectRatio:Double {
        Path(bezierPath.cgPath).naturalAspectRatio
    }
}


struct ScaledToAspect:Shape {
        let bezierPath:UIBezierPath
        
        func path(in rect: CGRect) -> Path {
            
            let bounds = bezierPath.cgPath.boundingBoxOfPath
            var multiplier = 1.0
            
            let aspectRatioOP = bounds.width/bounds.height
            let aspectRatioRect = rect.width/rect.height
            
            if aspectRatioOP > aspectRatioRect {
                multiplier = rect.width/bounds.width
            } else {
                multiplier = rect.height/bounds.height
            }
            
            let path = Path(bezierPath.cgPath)
            
            let transform = CGAffineTransform.identity.scaledBy(x: multiplier , y: multiplier)
            
            return path.applying(transform)
        }
    
    
//    func sizeThatFits(_ proposal: ProposedViewSize) -> CGSize {
//        let aspectRatio = Path(bezierPath.cgPath).naturalAspectRatio
//        print("proposed size\(proposal)")
//        return (CGSize(width:100.0*aspectRatio, height: 100.0/aspectRatio))
//    }
}

//THIS IS THE CORRECT BEHAVIOR
struct ScaledToFill: Shape {
    let bezierPath: UIBezierPath
    
    func path(in rect: CGRect) -> Path {
//        let aspectRatioOP = bezierPath.cgPath.boundingBoxOfPath.width/bezierPath.cgPath.boundingBoxOfPath.height
//        let aspectRatioRect = rect.width/rect.height
//
        //1/(percentage of the actual size to proposed sized.)
        let widthMultiplier = rect.width/bezierPath.cgPath.boundingBoxOfPath.width
        let heightMultiplier = rect.height/bezierPath.cgPath.boundingBoxOfPath.height
        
        let path = Path(bezierPath.cgPath)
        
        let transform = CGAffineTransform.identity.scaledBy(x: widthMultiplier, y: heightMultiplier)
        
        return path.applying(transform)
    }
}

extension Path {
    func getAnchors() -> [CGPoint] {
        var resultingPoints = [CGPoint]()
        self.forEach { element in
            switch element {
            case .move(let point):
                resultingPoints.append(point)
            case .closeSubpath:
                break
            case .line(to: let to):
                resultingPoints.append(to)
            case .quadCurve(to: let to, control: _):
                resultingPoints.append(to)
            case .curve(to: let to, control1: _, control2: _):
                resultingPoints.append(to)
            }
        }
        return resultingPoints
    }
    
    func getAllPoints() -> [CGPoint] {
        var resultingPoints = [CGPoint]()
        self.forEach { element in
            switch element {
            case .move(let point):
                resultingPoints.append(point)
            case .closeSubpath:
                break
            case .line(to: let to):
                resultingPoints.append(to)
            case .quadCurve(to: let to, control: let control):
                resultingPoints.append(to)
                resultingPoints.append(control)
            case .curve(to: let to, control1: let control1, control2: let control2):
                resultingPoints.append(to)
                resultingPoints.append(control1)
                resultingPoints.append(control2)
            }
        }
        return resultingPoints
    }
    
    var longDescription:String {
        var description:String = "let shape = UIBezierPath()\n"
        self.forEach { element in
            switch element {
            case .move(let point):
                description.append("shape.move(to:CGPoint(x:\(point.x), y:\(point.y)))\n")
            case .closeSubpath:
                description.append("shape.close()")
                break
            case .line(to: let point):
                description.append("shape.line(to:CGPoint(x:\(point.x), y:\(point.y)))\n")
            case .quadCurve(to: let to, control: let control):
                description.append("shape.addCurve(to: CGPoint(x: \(to.x), y: \(to.y)), controlPoint1: CGPoint(x: \(control.x), y: \(control.y)))\n")
            case .curve(to: let to, control1: let control1, control2: let control2):
                description.append("shape.addCurve(to: CGPoint(x: \(to.x), y: \(to.y)), controlPoint1: CGPoint(x: \(control1.x), y: \(control1.y)), controlPoint2: CGPoint(x: \(control2.x), y:\(control2.y)))\n")
            }
        }
        return description
    }
    
    //use self.boundingBox.min in most cases.
    var minXAnchor:CGPoint? {
        let points = self.getAnchors()
        return points.min(by: {$0.x < $1.x})
    }
    
    var minYAnchor:CGPoint? {
        let points = self.getAnchors()
        return points.min(by: {$0.y < $1.y})
    }
    
    var maxXAnchor:CGPoint? {
        let points = self.getAnchors()
        return points.max(by: {$0.x < $1.x})
    }
    
    var maxYAnchor:CGPoint? {
        let points = self.getAnchors()
        return points.max(by: {$0.y < $1.y})
    }
    
    //boundingBoxOfPath excludes control path points
    //boundingBox includes control points
    //interestingly enough, this spits out the correct value
    //but .aspectRatio does not seem to render it correctly but
    //using .scaledToFit does??
    var naturalAspectRatio:Double {
        //48.8/37.0//
        let ratio = self.cgPath.boundingBoxOfPath.width/self.cgPath.boundingBoxOfPath.height
        print("ratio: \(ratio)")
        return ratio
        //let what = self.scaledToFit()
        //return what
    }
}
