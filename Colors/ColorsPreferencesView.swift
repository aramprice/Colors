//
//  ColorsPreferencesView.swift
//  Colors
//
//  Created by aram price on 2021-09-11.
//  Copyright © 2021 aram price. All rights reserved.
//

import SwiftUI

struct ColorsPreferencesView: View {
    @State private var window: NSWindow?
    @ObservedObject var colorsSettings = ColorsSettings()

    var body: some View {
        let closePreferences: () -> Void = {
            self.window!.sheetParent?.endSheet(self.window!, returnCode: NSApplication.ModalResponse.cancel)
        }
        let savePreferences: () -> Void = {
            colorsSettings.write()
            self.window!.sheetParent?.endSheet(self.window!, returnCode: NSApplication.ModalResponse.OK)
        }

        VStack() {
            Text("Colors Preferences")
                .fixedSize()
                .padding()

            Stepper(
                value: $colorsSettings.verticies,
                in: 3...11
            ) {
                Text("Verticies: \(colorsSettings.verticies)")
                    .fixedSize()
            }

            Stepper(
                value: $colorsSettings.redrawSeconds,
                in: 3...30
            ) {
                Text("Refresh every: \(colorsSettings.redrawSeconds) seconds")
                    .fixedSize()
            }

            HStack() {
                Button("Cancel", action: closePreferences)
                    .keyboardShortcut(.cancelAction)

                Button("Ok", action: savePreferences)
                    .keyboardShortcut(.defaultAction)
            }
            .padding()
        }
        .padding()
        .background(WindowAccessor(window: self.$window))
    }
}

struct ColorsPreferencesView_Previews: PreviewProvider {
    static var previews: some View {
        ColorsPreferencesView()
    }
}

struct WindowAccessor: NSViewRepresentable {
    @Binding var window: NSWindow?
    
    func makeNSView(context: Context) -> NSView {
        let view = NSView()
        DispatchQueue.main.async {
            self.window = view.window
        }
        return view
    }
    
    func updateNSView(_ nsView: NSView, context: Context) {}
}
