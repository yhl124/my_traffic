//
//  structures.swift
//  my_traffic
//
//  Created by yhl on 4/8/24.
//

import Foundation


struct BusStationInfo: Identifiable{
    var id = UUID()
    
    let mobileNo: String
    let stationName: String
    let stationId: String
}

//struct BusRouteInfo: Identifiable{
//    var id = UUID()
//    
//    let routeId: String
//    let routeName: String
//    let routeTypeCd: String
//}

struct BusRouteInfo: Hashable {
    var routeId: String
    var routeName: String
    var routeTypeCd: String
    // 추가적인 프로퍼티들...

    // Hashable 프로토콜 준수를 위한 hashValue 계산
    func hash(into hasher: inout Hasher) {
        hasher.combine(routeId)
        hasher.combine(routeName)
        hasher.combine(routeTypeCd)
        // 추가적인 프로퍼티들에 대해서도 해시값을 결합할 수 있습니다.
    }

    // Equatable 프로토콜 준수를 위한 == 연산자 재정의
    static func == (lhs: BusRouteInfo, rhs: BusRouteInfo) -> Bool {
        return lhs.routeId == rhs.routeId && lhs.routeName == rhs.routeName && lhs.routeTypeCd == rhs.routeTypeCd
        // 추가적인 프로퍼티들에 대해서도 비교 연산을 추가할 수 있습니다.
    }
}

struct BusRealTimeInfo: Identifiable{
    var id = UUID()
    
    let stationId: String
    let routeId: String
    let locationNo1: String
    let locationNo2: String
    let predictTime1: String
    let predictTime2: String
}
