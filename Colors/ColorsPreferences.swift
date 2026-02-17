import AppKit
import ScreenSaver

final class ColorsPreferences: NSObject {
    static let shared = ColorsPreferences()
    private override init() {}

    private let key = "Vertices"
    private let minVertices: Int = 3
    private let maxVertices: Int = 25

    func makeWindow(for hostView: ColorsView) -> NSWindow? {
        let bundleID = Bundle(for: ColorsView.self).bundleIdentifier ?? "ColorsSaver"
        guard let defaults = ScreenSaverDefaults(forModuleWithName: bundleID) else { return nil }
        defaults.register(defaults: [key: 10])

        let window = NSWindow(contentRect: NSRect(x: 0, y: 0, width: 360, height: 160),
                              styleMask: [.titled, .closable],
                              backing: .buffered,
                              defer: false)
        window.title = "Colors Preferences"
        window.isReleasedWhenClosed = false

        let contentView = NSView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        window.contentView = contentView

        let label = NSTextField(labelWithString: "Number of vertices:")
        label.translatesAutoresizingMaskIntoConstraints = false

        let valueField = NSTextField(string: "")
        valueField.translatesAutoresizingMaskIntoConstraints = false
        valueField.alignment = .right
        valueField.formatter = NumberFormatter()

        let stepper = NSStepper()
        stepper.translatesAutoresizingMaskIntoConstraints = false
        stepper.minValue = Double(minVertices)
        stepper.maxValue = Double(maxVertices)

        // Load initial value
        let current = max(minVertices, min(defaults.integer(forKey: key), maxVertices))
        stepper.integerValue = current == 0 ? 10 : current
        valueField.integerValue = stepper.integerValue

        stepper.target = self
        stepper.action = #selector(stepperChanged(_:))
        valueField.target = self
        valueField.action = #selector(textFieldChanged(_:))

        let okButton = NSButton(title: "OK", target: nil, action: nil)
        okButton.translatesAutoresizingMaskIntoConstraints = false
        okButton.keyEquivalent = "\r"
        let cancelButton = NSButton(title: "Cancel", target: nil, action: nil)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.keyEquivalent = "\u{1b}"

        // Store controls for callbacks
        let ctx = Context(defaults: defaults, hostView: hostView, valueField: valueField, stepper: stepper, window: window)
        objc_setAssociatedObject(window, &Context.associatedKey, ctx, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        okButton.target = self
        okButton.action = #selector(okPressed(_:))
        cancelButton.target = self
        cancelButton.action = #selector(cancelPressed(_:))

        contentView.addSubview(label)
        contentView.addSubview(valueField)
        contentView.addSubview(stepper)
        contentView.addSubview(okButton)
        contentView.addSubview(cancelButton)

        NSLayoutConstraint.activate([
            contentView.widthAnchor.constraint(equalToConstant: 360),
            contentView.heightAnchor.constraint(equalToConstant: 160),

            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),

            valueField.leadingAnchor.constraint(equalTo: label.trailingAnchor, constant: 12),
            valueField.centerYAnchor.constraint(equalTo: label.centerYAnchor),
            valueField.widthAnchor.constraint(equalToConstant: 60),

            stepper.leadingAnchor.constraint(equalTo: valueField.trailingAnchor, constant: 8),
            stepper.centerYAnchor.constraint(equalTo: valueField.centerYAnchor),

            cancelButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            cancelButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),

            okButton.trailingAnchor.constraint(equalTo: cancelButton.leadingAnchor, constant: -8),
            okButton.bottomAnchor.constraint(equalTo: cancelButton.bottomAnchor)
        ])

        return window
    }

    // MARK: - Actions

    @objc private func stepperChanged(_ sender: NSStepper) {
        guard let ctx = context(from: sender) else { return }
        ctx.valueField.integerValue = sender.integerValue
    }

    @objc private func textFieldChanged(_ sender: NSTextField) {
        guard let ctx = context(from: sender) else { return }
        let value = clamp(sender.integerValue)
        sender.integerValue = value
        ctx.stepper.integerValue = value
    }

    @objc private func okPressed(_ sender: NSButton) {
        guard let ctx = context(from: sender) else { return }
        let value = clamp(ctx.valueField.integerValue)
        ctx.defaults.set(value, forKey: key)
        ctx.defaults.synchronize()
        ctx.hostView.verticies = value
        ctx.hostView.setNeedsDisplay(ctx.hostView.bounds)
        ctx.hostView.window?.endSheet(ctx.window)
    }

    @objc private func cancelPressed(_ sender: NSButton) {
        guard let ctx = context(from: sender) else { return }
        ctx.hostView.window?.endSheet(ctx.window)
    }

    private func clamp(_ value: Int) -> Int { max(3, min(value, 200)) }

    private func context(from control: NSView) -> Context? {
        if let window = control.window,
           let ctx = objc_getAssociatedObject(window, &Context.associatedKey) as? Context {
            return ctx
        }
        return nil
    }

    private class Context: NSObject {
        static var associatedKey: UInt8 = 0
        let defaults: ScreenSaverDefaults
        let hostView: ColorsView
        let valueField: NSTextField
        let stepper: NSStepper
        let window: NSWindow
        init(defaults: ScreenSaverDefaults, hostView: ColorsView, valueField: NSTextField, stepper: NSStepper, window: NSWindow) {
            self.defaults = defaults
            self.hostView = hostView
            self.valueField = valueField
            self.stepper = stepper
            self.window = window
        }
    }
}
