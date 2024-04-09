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
    let selectedStationName: String // 선택한 정류장 이름
    let selectedMobileNo: String // 선택한 정류장 번호
    

    var body: some View {
        NavigationView {
            VStack {
                Text("\(selectedStationName) (\(selectedMobileNo))")
                    .font(.title3)

                content
                    .navigationBarItems(
                        leading: Button(action: onDismiss) {
                            Text("닫기")
                        },
                        trailing: Button(action: onConfirm) {
                            Text("확인")
                        }
                    )
            }
            .navigationBarTitle(title)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
