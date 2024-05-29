////
////  CustomSheetStyle.swift
////  my_traffic
////
////  Created by yhl on 2024/04/01.
////
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
        VStack {
            HStack {
                Button(action: onDismiss) {
                    Text("취소")
                }
                Spacer()
                Text(title)
                    .font(.headline)
                    .padding()
                Spacer()
                Button(action: onConfirm) {
                    Text("저장")
                }
            }
            
            Text("\(selectedStationName) (\(selectedMobileNo))")
                .font(.title3)
            
            content
        }
        .padding(.horizontal)
        .background(Color(UIColor.systemGray6).edgesIgnoringSafeArea(.all))
        .cornerRadius(20)
        .shadow(radius: 10)
    }
}


////struct CustomSheetStyle<Content: View>: View {
////    let content: Content
////    let title: String
////    let onDismiss: () -> Void
////    let onConfirm: () -> Void
////    let selectedStationName: String // 선택한 정류장 이름
////    let selectedMobileNo: String // 선택한 정류장 번호
////    
////
////    var body: some View {
////        NavigationView {
////            VStack {
////                Text("\(selectedStationName) (\(selectedMobileNo))")
////                    .font(.title3)
////
////                content
////                    .navigationBarItems(
////                        leading: Button(action: onDismiss) {
////                            Text("닫기")
////                        },
////                        trailing: Button(action: onConfirm) {
////                            Text("확인")
////                        }
////                    )
////            }
////            .navigationBarTitle(title)
////            .navigationBarTitleDisplayMode(.inline)
////        }
////    }
////}
