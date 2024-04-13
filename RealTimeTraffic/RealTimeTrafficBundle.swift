//
//  RealTimeTrafficBundle.swift
//  RealTimeTraffic
//
//  Created by yhl on 4/13/24.
//

import WidgetKit
import SwiftUI

@main
struct RealTimeTrafficBundle: WidgetBundle {
    var body: some Widget {
        RealTimeTraffic()
        RealTimeTrafficLiveActivity()
    }
}
