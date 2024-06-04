//
//  AppIntent.swift
//  myTrafficExWidget
//
//  Created by yhl on 4/20/24.
//

import WidgetKit
import AppIntents

struct ConfigurationAppIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "Configuration"
    static var description = IntentDescription("This is an example widget.")

    // An example configurable parameter.
    @Parameter(title: "Favorite Emoji", default: "😃")
    var favoriteEmoji: String
}

struct ReloadWidgetIntent: AppIntent {
    static var title: LocalizedStringResource = "Reload widget"
    static var description = IntentDescription("Reload widget.")

    init() {}

    func perform() async throws -> some IntentResult {
        return .result()
    }
}
