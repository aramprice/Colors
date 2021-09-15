//
//  ColorsView.swift
//
//  Copyright (c) 2013 aram price.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of 
//  this software and associated documentation files (the "Software"), to deal in the 
//  Software without restriction, including without limitation the rights to use, copy, 
//  modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, 
//  and to permit persons to whom the Software is furnished to do so, subject to the 
//  following conditions:
//
//  The above copyright notice and this permission notice shall be included in all copies 
//  or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, 
//  INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A 
//  PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT 
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF 
//  CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE 
//  OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

import Foundation
import ScreenSaver

class ColorsView: ScreenSaverView {
    var context: CGContext! = nil

    override init(frame: NSRect, isPreview: Bool) {
        super.init(frame: frame, isPreview: isPreview)!
        self.animationTimeInterval = TimeInterval(3)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func startAnimation() {
        super.startAnimation()
    }

    override func stopAnimation() {
        super.stopAnimation()
    }
    
    override func animateOneFrame() {
        setNeedsDisplay(bounds)
    }

    override func draw(_ rect: NSRect) {
        super.draw(rect)
        drawScreen()
    }
    
    func drawScreen() {
        context = NSGraphicsContext.current!.cgContext

        setRandomBackgroundColor()
        createRandomColoredPolygon()
    }

    func setRandomBackgroundColor() {
        context.saveGState()
        context.setFillColor(randomSolidColor())
        context.fill(self.bounds)
        context.restoreGState()
    }

    func createRandomColoredPolygon() {
        context.saveGState()

        context.beginPath()
        context.setFillColor(randomColor(withTransparency: true))
        context.move(to: randomPoint())
        for _ in 1...10 {
            context.addLine(to: randomPoint())
        }
        context.fillPath(using: CGPathFillRule.evenOdd)
        
        context.restoreGState()
    }
    
    func randomSolidColor() -> CGColor {
        return randomColor(withTransparency: false)
    }

    func randomColor(withTransparency: Bool) -> CGColor {
        return CGColor.init(srgbRed: randomFloat(),
                            green: randomFloat(),
                            blue: randomFloat(),
                            alpha: withTransparency ? randomFloat() : 1.0)
    }

    func randomPoint() -> CGPoint {
        return CGPoint.init(x: SSRandomFloatBetween(0.0, CGFloat(bounds.width)),
                            y: SSRandomFloatBetween(0.0, CGFloat(bounds.height)));
    }

    func randomFloat() -> CGFloat {
        return SSRandomFloatBetween(0.0, 1.0);
    }
}