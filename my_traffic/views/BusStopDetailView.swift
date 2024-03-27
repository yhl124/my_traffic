//
//  BusStopDetailView.swift
//  my_traffic
//
//  Created by yhl on 2024/03/27.
//

import Foundation
import SwiftUI

struct BusStopDetailView: View {
    @State var busStop: BusStop
    //@Binding var isPresented: Bool
    
    var body: some View {
        // 여기에 버스 정류장 세부 정보를 표시하는 코드를 작성합니다.
        Text("Bus Stop Detail: \(busStop.nodenm)")
    }
}
