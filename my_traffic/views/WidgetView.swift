//
//  WidgetView.swift
//  my_traffic
//
//  Created by yhl on 4/10/24.
//

import Foundation
import SwiftUI

struct WidgetView: View {
    var busStops: [BusStop] // 홈 화면 위젯에 표시할 버스 정류장 정보

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("내가 자주 이용하는 정류장") // 제목

            ForEach(busStops) { busStop in
                VStack(alignment: .leading) {
                    Text(busStop.stationName ?? "Unknown") // 정류장 이름
                        .font(.headline)
                    ForEach(Array(busStop.routes as? Set<BusRoute> ?? []), id: \.self) { route in
                        Text("\(route.routeName ?? "") - \(route.routeTypeCd ?? "")") // 노선 정보
                            .font(.subheadline)
                    }
                }
                .padding(.vertical, 5)
            }
        }
        .padding()
    }
}




