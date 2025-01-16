//
//  ColorsSettings.swift
//  Colors
//
//  Created by aram price on 2021-10-17.
//  Copyright © 2021 aram price. All rights reserved.
//

import Combine
import Foundation
import ScreenSaver

class ColorsSettings: ObservableObject {
    private var screenSaverDefaults: UserDefaults

    private let identifier = Bundle(for: ColorsSettings.self).bundleIdentifier
    private let keyForRedrawSeconds = "redrawSeconds"
    private let defaultRedrawSeconds = 3
    private let keyForVerticies = "numberOfVerticies"
    private let defaultVerticies = 10

    init() {
        screenSaverDefaults = ScreenSaverDefaults(forModuleWithName: identifier!)!

        self.redrawSeconds = screenSaverDefaults.object(forKey: keyForRedrawSeconds) as? Int ?? defaultRedrawSeconds
        self.verticies = screenSaverDefaults.object(forKey: keyForVerticies) as? Int ?? defaultVerticies
    }

    func write() {
        screenSaverDefaults.synchronize()
    }

    var redrawSeconds: Int {
        didSet {
            screenSaverDefaults.set(redrawSeconds, forKey: keyForRedrawSeconds)
        }
    }

    var verticies: Int {
        didSet {
            screenSaverDefaults.set(verticies, forKey: keyForVerticies)
        }
    }
}
