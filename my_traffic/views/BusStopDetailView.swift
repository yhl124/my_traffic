//
//  BusStopDetailView.swift
//  my_traffic
//
//  Created by yhl on 2024/03/27.
//

import Foundation
import SwiftUI

struct BusStopDetailView: View {
    var busStop: BusStationInfo
    @StateObject var viewModel = BusRouteViewModel()
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedRoutes: Set<BusRouteInfo> = []

    var body: some View {
        CustomSheetStyle(
            content: List(viewModel.busRoutes, id: \.routeId) { route in
                BusRouteRow(route: route, isSelected: selectedRoutes.contains(route)) {
                    if selectedRoutes.contains(route) {
                        selectedRoutes.remove(route)
                    } else {
                        selectedRoutes.insert(route)
                    }
                }
            },
            title: "노선 선택",
            onDismiss: {
                presentationMode.wrappedValue.dismiss()
            },
            onConfirm: {
                // Do something with selectedRoutes
                presentationMode.wrappedValue.dismiss()
            }
        )
        .onAppear {
            viewModel.searchBusRoutes(stationId: busStop.stationId)
        }
    }
}

struct BusRouteRow: View {
    var route: BusRouteInfo
    var isSelected: Bool
    var onToggle: () -> Void

    var body: some View {
        HStack {
            Button(action: {
                onToggle()
            }) {
                Image(systemName: isSelected ? "checkmark.square.fill" : "square")
            }
            .buttonStyle(BorderlessButtonStyle())
            VStack(alignment: .leading) {
                Text("노선 번호: \(route.routeName)")
                Text("노선 타입: \(route.routeTypeCd)")
            }
        }
    }
}


//struct BusStopDetailView: View {
//    var busStop: BusStationInfo
//    @Environment(\.presentationMode) var presentationMode
//
//    var body: some View {
//        CustomSheetStyle(
//            content: Text("Selected Bus Stop: \(busStop.stationName), \(busStop.mobileNo)"),
//            title: "노선 선택",
//            onDismiss: {
//                presentationMode.wrappedValue.dismiss()
//            },
//            onConfirm: {
//                presentationMode.wrappedValue.dismiss()
//            }
//        )
//    }
//}


//struct BusStopDetailView: View {
//    var busStop: BusStationInfo
//    @StateObject var viewModel = BusRouteViewModel()
//    @Environment(\.presentationMode) var presentationMode
//
//    var body: some View {
//        CustomSheetStyle(
//            content: List(viewModel.busRoutes, id: \.routeId) { route in
//                VStack(alignment: .leading) {
//                    //Text("Route ID: \(route.routeId)")
//                    Text("노선 번호: \(route.routeName)")
//                    Text("노선 타입: \(route.routeTypeCd)")
//                }
//            },
//            title: "노선 선택",
//            onDismiss: {
//                presentationMode.wrappedValue.dismiss()
//            },
//            onConfirm: {
//                presentationMode.wrappedValue.dismiss()
//            }
//        )
//        .onAppear {
//            viewModel.searchBusRoutes(stationId: busStop.stationId)
//        }
//    }
//}
