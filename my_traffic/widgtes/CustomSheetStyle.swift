//
//  CustomSheetStyle.swift
//  my_traffic
//
//  Created by yhl on 2024/04/01.
//

import Foundation
import SwiftUI

struct CustomSheetStyle<Content: View>: View {
    let content: Content
    let title: String
    let onDismiss: () -> Void
    let onConfirm: () -> Void

    var body: some View {
        NavigationView {
            content
                .navigationBarItems(
                    leading: Button(action: onDismiss) {
                        Text("닫기")
                    },
                    trailing: Button(action: onConfirm) {
                        Text("확인")
                    }
                )
                .navigationBarTitle(title)
                .navigationBarTitleDisplayMode(.inline)
        }
    }
}
