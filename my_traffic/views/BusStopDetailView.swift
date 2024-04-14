//
//  BusStopDetailView.swift
//  my_traffic
//
//  Created by yhl on 2024/03/27.
//

import Foundation
import SwiftUI
import CoreData

struct BusStopDetailView: View {
    var busStop: BusStationInfo
    @StateObject var viewModel = BusRouteViewModel()
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedRoutes: Set<BusRouteInfo> = []
    @State private var showAlert = false
    @State private var alertDismissed = false

    var body: some View {
        VStack {
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
                    if !showAlert { // showAlert가 false인 경우에만 화면을 닫습니다.
                        presentationMode.wrappedValue.dismiss()
                    }
                },
                selectedStationName: busStop.stationName,
                selectedMobileNo: busStop.mobileNo
            )
            .onAppear {
                viewModel.searchBusRoutes(stationId: busStop.stationId)
            }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("알림"),
                    message: Text("이미 등록된 정류장입니다."),
                    dismissButton: .default(Text("확인")) {
                        // showAlert를 false로 설정하여 alert를 닫습니다.
                        // alertDismissed 상태는 여기서 직접 사용하지 않습니다.
                    }
                )
            }
            .onChange(of: showAlert) { newValue in
                // showAlert의 값이 변경될 때만 presentationMode를 처리합니다.
                // showAlert이 false가 되면, 즉 alert가 닫히면 presentationMode를 통해 화면을 닫습니다.
                if !newValue {
                    presentationMode.wrappedValue.dismiss()
                }
            }
        }
        .onDisappear {
            if alertDismissed {
                showAlert = false
                alertDismissed = false
            }
        }
    }
    
    func saveSelectedRoutesToCoreData() {
        if let documentsDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last {
            print("Documents Directory: \(documentsDirectoryURL)")
        }
        let context = PersistenceController.shared.container.viewContext
//        let context = coreDataManager.persistentContainer.viewContext
        
        // 중복을 확인하기 위해 이미 저장된 버스 정류장들을 가져옵니다.
        let fetchRequest: NSFetchRequest<BusStop> = BusStop.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "mobileNo == %@", busStop.mobileNo)
        
        do {
            let existingStops = try context.fetch(fetchRequest)
            
            // 이미 등록된 정류장이 있는지 확인합니다.
            guard existingStops.isEmpty else {
                alertDismissed = true // showAlert를 true로 설정하기 전에 이 값을 true로 설정합니다.
                showAlert = true
                return
            }
            
            // 새로운 버스 정류장을 생성하고 저장합니다.
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
            
            
            try context.save()
            print("BusStop and related BusRoutes saved to CoreData")
        } catch {
            print("Error saving data to CoreData: \(error.localizedDescription)")
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
//    @StateObject var viewModel = BusRouteViewModel()
//    @Environment(\.presentationMode) var presentationMode
//    @State private var selectedRoutes: Set<BusRouteInfo> = []
//
//    var body: some View {
//        CustomSheetStyle(
//            content: List(viewModel.busRoutes, id: \.routeId) { route in
//                BusRouteRow(route: route, isSelected: selectedRoutes.contains(route)) {
//                    if selectedRoutes.contains(route) {
//                        selectedRoutes.remove(route)
//                    } else {
//                        selectedRoutes.insert(route)
//                    }
//                }
//            },
//            title: "노선 선택",
//            onDismiss: {
//                presentationMode.wrappedValue.dismiss()
//            },
//            onConfirm: {
//                saveSelectedRoutesToCoreData()
//                presentationMode.wrappedValue.dismiss()
//            },
//            selectedStationName: busStop.stationName,
//            selectedMobileNo: busStop.mobileNo
//        )
//        .onAppear {
//            viewModel.searchBusRoutes(stationId: busStop.stationId)
//        }
//    }
//}
//
////중복 확인1
//extension BusStopDetailView {
//    func saveSelectedRoutesToCoreData() {
//        let context = PersistenceController.shared.container.viewContext
//        
//        // 중복을 확인하기 위해 이미 저장된 버스 정류장들을 가져옵니다.
//        let fetchRequest: NSFetchRequest<BusStop> = BusStop.fetchRequest()
//        fetchRequest.predicate = NSPredicate(format: "mobileNo == %@", busStop.mobileNo)
//        
//        do {
//            let existingStops = try context.fetch(fetchRequest)
//            
//            // 이미 등록된 정류장이 있는지 확인합니다.
//            guard existingStops.isEmpty else {
//                print("이미 등록된 정류장입니다.")
//                // 이미 등록된 정류장이 있으면 경고를 표시하고 저장을 건너뜁니다.
//                return
//            }
//            
//            // 새로운 버스 정류장을 생성하고 저장합니다.
//            let newBusStop = BusStop(context: context)
//            newBusStop.mobileNo = busStop.mobileNo
//            newBusStop.stationName = busStop.stationName
//            
//            for selectedRoute in selectedRoutes {
//                let newBusRoute = BusRoute(context: context)
//                newBusRoute.routeName = selectedRoute.routeName
//                newBusRoute.routeTypeCd = selectedRoute.routeTypeCd
//                // 추가적인 프로퍼티 설정 가능
//                
//                // BusStop과 BusRoute 간의 관계 설정
//                newBusStop.addToRoutes(newBusRoute)
//            }
//            
//            try context.save()
//            print("BusStop and related BusRoutes saved to CoreData")
//        } catch {
//            print("Error saving data to CoreData: \(error.localizedDescription)")
//        }
//    }
//}
//
//

//extension BusStopDetailView {
//    func saveSelectedRoutesToCoreData() {
//        let context = PersistenceController.shared.container.viewContext
//        let newBusStop = BusStop(context: context)
//        newBusStop.mobileNo = busStop.mobileNo
//        newBusStop.stationName = busStop.stationName
//        
//        for selectedRoute in selectedRoutes {
//            let newBusRoute = BusRoute(context: context)
//            newBusRoute.routeName = selectedRoute.routeName
//            newBusRoute.routeTypeCd = selectedRoute.routeTypeCd
//            // 추가적인 프로퍼티 설정 가능
//            
//            // BusStop과 BusRoute 간의 관계 설정
//            newBusStop.addToRoutes(newBusRoute)
//        }
//        
//        do {
//            try context.save()
//            print("BusStop and related BusRoutes saved to CoreData")
//        } catch {
//            print("Error saving data to CoreData: \(error.localizedDescription)")
//        }
//    }
//}

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


//
//struct BusRouteRow: View {
//    var route: BusRouteInfo
//    var isSelected: Bool
//    var onToggle: () -> Void
//
//    var body: some View {
//        HStack {
//            Button(action: {
//                onToggle()
//            }) {
//                Image(systemName: isSelected ? "checkmark.square.fill" : "square")
//            }
//            .buttonStyle(BorderlessButtonStyle())
//            VStack(alignment: .leading) {
//                Text("노선 번호: \(route.routeName)")
//                Text("노선 타입: \(route.routeTypeCd)")
//            }
//        }
//    }
//}


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
