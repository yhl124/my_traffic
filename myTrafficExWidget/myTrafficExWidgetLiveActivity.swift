//
//  myTrafficExWidgetLiveActivity.swift
//  myTrafficExWidget
//
//  Created by yhl on 4/20/24.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct myTrafficExWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct myTrafficExWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: myTrafficExWidgetAttributes.self) { context in
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

extension myTrafficExWidgetAttributes {
    fileprivate static var preview: myTrafficExWidgetAttributes {
        myTrafficExWidgetAttributes(name: "World")
    }
}

extension myTrafficExWidgetAttributes.ContentState {
    fileprivate static var smiley: myTrafficExWidgetAttributes.ContentState {
        myTrafficExWidgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: myTrafficExWidgetAttributes.ContentState {
         myTrafficExWidgetAttributes.ContentState(emoji: "🤩")
     }
}

//#Preview("Notification", as: .content, using: myTrafficExWidgetAttributes.preview) {
//   myTrafficExWidgetLiveActivity()
//} contentStates: {
//    myTrafficExWidgetAttributes.ContentState.smiley
//    myTrafficExWidgetAttributes.ContentState.starEyes
//}
