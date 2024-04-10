//
//  RealTimeTrafficLiveActivity.swift
//  RealTimeTraffic
//
//  Created by yhl on 4/10/24.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct RealTimeTrafficAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct RealTimeTrafficLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: RealTimeTrafficAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension RealTimeTrafficAttributes {
    fileprivate static var preview: RealTimeTrafficAttributes {
        RealTimeTrafficAttributes(name: "World")
    }
}

extension RealTimeTrafficAttributes.ContentState {
    fileprivate static var smiley: RealTimeTrafficAttributes.ContentState {
        RealTimeTrafficAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: RealTimeTrafficAttributes.ContentState {
         RealTimeTrafficAttributes.ContentState(emoji: "🤩")
     }
}

//#Preview("Notification", as: .content, using: RealTimeTrafficAttributes.preview) {
//   RealTimeTrafficLiveActivity()
//} contentStates: {
//    RealTimeTrafficAttributes.ContentState.smiley
//    RealTimeTrafficAttributes.ContentState.starEyes
//}
