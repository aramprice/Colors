import SwiftUI

struct ColorsPreferencesView: View {
    @State private var value: Double
    @State private var changeInterval: Double
    let minVertices: Double
    let maxVertices: Double
    let minChangeInterval: Double
    let maxChangeInterval: Double
    let width: CGFloat
    let height: CGFloat
    let onOK: (Int, Double) -> Void
    let onCancel: () -> Void

    init(
        value: Double,
        changeInterval: Double,
        minVertices: Double,
        maxVertices: Double,
        minChangeInterval: Double,
        maxChangeInterval: Double,
        width: CGFloat,
        height: CGFloat,
        onOK: @escaping (Int, Double) -> Void,
        onCancel: @escaping () -> Void
    ) {
        _value = State(initialValue: value)
        _changeInterval = State(initialValue: changeInterval)
        self.minVertices = minVertices
        self.maxVertices = maxVertices
        self.minChangeInterval = minChangeInterval
        self.maxChangeInterval = maxChangeInterval
        self.width = width
        self.height = height
        self.onOK = onOK
        self.onCancel = onCancel
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            PolygonComplexitySection(
                value: $value,
                range: minVertices...maxVertices
            )

            Divider()

            ChangeIntervalSection(
                value: $changeInterval,
                range: minChangeInterval...maxChangeInterval
            )

            Spacer(minLength: 0)

            HStack {
                Spacer()
                Button("Cancel") { onCancel() }
                    .keyboardShortcut(.cancelAction)
                Button("OK") { onOK(Int(value), changeInterval) }
                    .keyboardShortcut(.defaultAction)
            }
        }
        .padding(24)
        .frame(width: width, height: height)
    }
}

private struct PolygonComplexitySection: View {
    @Binding var value: Double
    let range: ClosedRange<Double>

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Polygon Complexity")
                    .font(.headline)
                Text("Choose how many vertices are used to draw each shape.")
                    .foregroundStyle(.secondary)
            }

            HStack {
                Slider(value: $value, in: range, step: 1)
                    .accessibilityLabel("Number of vertices")

                Stepper(value: $value, in: range, step: 1) {
                    Text("\(Int(value))")
                        .monospacedDigit()
                        .frame(minWidth: 24, alignment: .trailing)
                }
                .accessibilityLabel("Number of vertices")
            }
        }
    }
}

private struct ChangeIntervalSection: View {
    @Binding var value: Double
    let range: ClosedRange<Double>

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Change Interval")
                    .font(.headline)
                Text("Choose how often a new composition appears.")
                    .foregroundStyle(.secondary)
            }

            HStack {
                Text("Change every")
                Stepper(value: $value, in: range, step: 1) {
                    Text("\(Int(value)) sec")
                        .monospacedDigit()
                        .frame(minWidth: 78, alignment: .trailing)
                }
                .accessibilityLabel("Change interval in seconds")
                Spacer()
            }
        }
    }
}

#Preview("Colors Preferences") {
    ColorsPreferencesView(
        value: 5.0,
        changeInterval: 3.0,
        minVertices: 3.0,
        maxVertices: 20.0,
        minChangeInterval: 1.0,
        maxChangeInterval: 60.0,
        width: 400,
        height: 285,
        onOK: { _, _ in },
        onCancel: {}
    )
}
