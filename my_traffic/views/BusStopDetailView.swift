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
                saveSelectedRoutesToCoreData()
                presentationMode.wrappedValue.dismiss()
            },
            selectedStationName: busStop.stationName,
            selectedMobileNo: busStop.mobileNo
        )
        .onAppear {
            viewModel.searchBusRoutes(stationId: busStop.stationId)
        }
    }
}

extension BusStopDetailView {
    func saveSelectedRoutesToCoreData() {
        let context = PersistenceController.shared.container.viewContext
        let newBusStop = BusStop(context: context)
        newBusStop.mobileNo = busStop.mobileNo
        newBusStop.stationName = busStop.stationName
        
        for selectedRoute in selectedRoutes {
            let newBusRoute = BusRoute(context: context)
            newBusRoute.routeName = selectedRoute.routeName
            newBusRoute.routeTypeCd = selectedRoute.routeTypeCd
            // 추가적인 프로퍼티 설정 가능
            
            // BusStop과 BusRoute 간의 관계 설정
            newBusStop.addToRoutes(newBusRoute)
        }
        
        do {
            try context.save()
            print("BusStop and related BusRoutes saved to CoreData")
        } catch {
            print("Error saving data to CoreData: \(error.localizedDescription)")
        }
    }
}

//extension BusStop {
//    //@NSManaged public var mobileNo: String
//    //@NSManaged public var stationName: String
//    @NSManaged public var routes: Set<BusRoute> // 이 속성은 CoreData 모델에서 관계로 정의되어야 함
//}

extension BusStop {
    // 이 메서드는 CoreData에 새로운 노선을 추가합니다.
    func addRoute(_ route: BusRoute) {
        let routes = self.mutableSetValue(forKey: #keyPath(BusStop.routes))
        routes.add(route)
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
