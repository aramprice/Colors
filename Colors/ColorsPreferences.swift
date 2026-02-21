import AppKit
import SwiftUI

final class ColorsPreferences: NSObject {
    static let shared = ColorsPreferences()
    private override init() {}

    private static let preferencesWidth: CGFloat = 400
    private static let preferencesHeight: CGFloat = 285
    private let preferencesRect = NSRect(
        x: 0,
        y: 0,
        width: preferencesWidth,
        height: preferencesHeight
    )
    private lazy var window: NSWindow = {
        let window = NSWindow(
            contentRect: preferencesRect,
            styleMask: [.titled, .closable],
            backing: .buffered,
            defer: false
        )
        window.title = "Colors Settings"
        window.isReleasedWhenClosed = false
        return window
    }()

    func makeWindow(for hostView: ColorsView) -> NSWindow? {
        let rootView = ColorsPreferencesView(
            value: ColorsView.storedVertices,
            changeInterval: ColorsView.storedChangeInterval,
            minVertices: ColorsView.minimumVertices,
            maxVertices: ColorsView.maximumVertices,
            minChangeInterval: ColorsView.minimumChangeInterval,
            maxChangeInterval: ColorsView.maximumChangeInterval,
            width: Self.preferencesWidth,
            height: Self.preferencesHeight,
            onOK: { [weak window] newValue, changeInterval in
                hostView.vertices = Double(newValue)
                hostView.changeInterval = changeInterval
                hostView.displayIfNeeded()
                if let window { Self.dismiss(window) }
            },
            onCancel: { [weak window] in
                if let window { Self.dismiss(window) }
            }
        )

        let hostingView = NSHostingView(rootView: rootView)
        hostingView.frame = preferencesRect
        window.contentView = hostingView

        return window
    }

    private static func dismiss(_ window: NSWindow) {
        if let parent = window.sheetParent {
            parent.endSheet(window)
        } else {
            window.orderOut(nil)
        }
    }
}
