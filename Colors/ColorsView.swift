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
import SwiftUI

final class ColorsView: ScreenSaverView {
    // MARK: - Preferences
    public static let bundleIdentifier = "ColorsSaver"
    public static var bundleID: String {
        Bundle(for: ColorsView.self).bundleIdentifier ?? ColorsView.bundleIdentifier
    }

    public static let verticesDefaultsKey = "Vertices"
    public static let minimumVertices: Double = 3
    public static let maximumVertices: Double = 20
    public static let defaultVertices: Double = 10
    public static let changeIntervalDefaultsKey = "ChangeInterval"
    public static let minimumChangeInterval: Double = 1
    public static let maximumChangeInterval: Double = 60
    public static let defaultChangeInterval: Double = 3

    // Computed property backed by ScreenSaverDefaults
    var vertices: Double {
        get { Self.storedVertices }
        set {
            Self.storedVertices = newValue
            setNeedsDisplay(bounds)
        }
    }

    var changeInterval: Double {
        get { Self.storedChangeInterval }
        set {
            Self.storedChangeInterval = newValue
            animationTimeInterval = Self.storedChangeInterval
        }
    }

    static var storedVertices: Double {
        get {
            guard let defaults = makeDefaults() else { return defaultVertices }
            defaults.synchronize()
            guard defaults.object(forKey: verticesDefaultsKey) != nil else {
                return defaultVertices
            }
            return clamped(defaults.double(forKey: verticesDefaultsKey))
        }
        set {
            guard let defaults = makeDefaults() else { return }
            defaults.set(clamped(newValue), forKey: verticesDefaultsKey)
            defaults.synchronize()
        }
    }

    static var storedChangeInterval: Double {
        get {
            guard let defaults = makeDefaults() else { return defaultChangeInterval }
            defaults.synchronize()
            guard defaults.object(forKey: changeIntervalDefaultsKey) != nil else {
                return defaultChangeInterval
            }
            return clampedChangeInterval(defaults.double(forKey: changeIntervalDefaultsKey))
        }
        set {
            guard let defaults = makeDefaults() else { return }
            defaults.set(clampedChangeInterval(newValue), forKey: changeIntervalDefaultsKey)
            defaults.synchronize()
        }
    }

    private static func makeDefaults() -> ScreenSaverDefaults? {
        let defaults = ScreenSaverDefaults(forModuleWithName: bundleID)
        defaults?.register(defaults: [
            verticesDefaultsKey: defaultVertices,
            changeIntervalDefaultsKey: defaultChangeInterval
        ])
        return defaults
    }

    private static func clamped(_ value: Double) -> Double {
        max(minimumVertices, min(value, maximumVertices))
    }

    private static func clampedChangeInterval(_ value: Double) -> Double {
        max(minimumChangeInterval, min(value, maximumChangeInterval))
    }

    override init?(frame: NSRect, isPreview: Bool) {
        super.init(frame: frame, isPreview: isPreview)
        animationTimeInterval = Self.storedChangeInterval
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        animationTimeInterval = Self.storedChangeInterval
    }

    override func animateOneFrame() {
        setNeedsDisplay(bounds)
    }

    override public var hasConfigureSheet: Bool {
        return true
    }

    override var configureSheet: NSWindow? {
        return ColorsPreferences.shared.makeWindow(for: self)
    }

    override func draw(_ rect: NSRect) {
        super.draw(rect)
        guard let context = NSGraphicsContext.current?.cgContext else { return }
        drawScreen(context: context, vertices: Int(vertices))
    }

    // MARK: - Drawing

    private func drawScreen(context: CGContext, vertices: Int) {
        setRandomBackgroundColor(in: context)
        createRandomColoredPolygon(in: context, vertices: vertices)
    }

    private func setRandomBackgroundColor(in context: CGContext) {
        context.saveGState()
        context.setFillColor(randomSolidColor())
        context.fill(self.bounds)
        context.restoreGState()
    }

    private func createRandomColoredPolygon(in context: CGContext, vertices: Int) {
        context.saveGState()
        context.beginPath()
        context.setFillColor(randomColor(withTransparency: true))
        context.move(to: randomPoint())
        for _ in 1..<vertices {
            context.addLine(to: randomPoint())
        }
        context.fillPath(using: CGPathFillRule.evenOdd)
        context.restoreGState()
    }

    private func randomSolidColor() -> CGColor {
        randomColor(withTransparency: false)
    }

    private func randomColor(withTransparency: Bool) -> CGColor {
        CGColor(srgbRed: randomFloat(),
                green: randomFloat(),
                blue: randomFloat(),
                alpha: withTransparency ? randomFloat() : 1.0)
    }

    private func randomPoint() -> CGPoint {
        CGPoint(x: randomFloat(upperBound: bounds.width),
                y: randomFloat(upperBound: bounds.height))
    }

    private func randomFloat(upperBound: CGFloat = 1.0) -> CGFloat {
        SSRandomFloatBetween(0.0, upperBound)
    }
}
