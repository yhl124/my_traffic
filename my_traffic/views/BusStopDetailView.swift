//
//  BusStopDetailView.swift
//  my_traffic
//
//  Created by yhl on 2024/03/27.
//

import Foundation
import SwiftUI

struct BusStopDetailView: View {
    var busStop: BusStop
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        CustomSheetStyle(
            content: Text("Selected Bus Stop: \(busStop.nodenm), \(busStop.nodeno)"),
            title: "노선 선택",
            onDismiss: {
                presentationMode.wrappedValue.dismiss()
            },
            onConfirm: {
                presentationMode.wrappedValue.dismiss()
            }
        )
    }
}
