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
//        /*새로 만드는거*/
//        let context = CoreDataManager.shared.persistentContainer.viewContext
//        let entity = NSEntityDescription.entity(forEntityName: "BusStop", in: context)
//        let entity2 = NSEntityDescription.entity(forEntityName: "BusRoute", in: context)
//        print("save")
//        
//        if let entity{
//            let busstop = NSManagedObject(entity: entity, insertInto: context)
//            busstop.setValue(busStop.stationName, forKey: "stationName")
//            print(busStop.stationName)
//            busstop.setValue(busStop.mobileNo, forKey: "mobileNo")
//            print(busStop.mobileNo)
            
//            for selectedRoute in selectedRoutes {
//                if let entity2{
//                    let busroute = NSManagedObject(entity: entity2, insertInto: context)
//                    busroute.setValue(selectedRoute.routeName, forKey: "routeName")
//                    busroute.setValue(selectedRoute.routeTypeCd, forKey: "routeTypeCd")
//                    
//                    //busstop : busroute = 1 : N 관계 설정
//                    busstop.mutableSetValue(forKey: "routes").add(busroute)
////                    busstop.addToRoute(busroute)
//                }
//            }
//        }
        
//        let context = CoreDataManager.shared.persistentContainer.viewContext
//        // Create a new BusStop instance
//        let busStopEntity = NSEntityDescription.entity(forEntityName: "BusStop", in: context)!
//        let busStop = NSManagedObject(entity: busStopEntity, insertInto: context) as! BusStop
//        busStop.stationName = busStop.stationName // Assign the stationName
//        busStop.mobileNo = busStop.mobileNo // Assign the mobileNo
//        
//        // Create BusRoute instances and associate them with the BusStop
//        for selectedRoute in selectedRoutes {
//            let busRouteEntity = NSEntityDescription.entity(forEntityName: "BusRoute", in: context)!
//            let busRoute = NSManagedObject(entity: busRouteEntity, insertInto: context) as! BusRoute
//            busRoute.routeName = selectedRoute.routeName // Assign the routeName
//            busRoute.routeTypeCd = selectedRoute.routeTypeCd // Assign the routeTypeCd
//            
//            // Associate the BusRoute with the BusStop
//            busStop.addToRoutes(busRoute)
////            busRoute.busStop = busStop
//        }
        
//        do{
////            print(context)
//            try context.save()
//        } catch {
//            let nserror = error as NSError
//            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
//        }
        
        
        
//        // App Group의 컨테이너 내에 Core Data 스택 구성
//        guard let containerURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.mytraffic") else { return }
//        let storeURL = containerURL.appendingPathComponent("my_traffic.sqlite")
//        let description = NSPersistentStoreDescription(url: storeURL)
//        
//        let container = NSPersistentContainer(name: "my_traffic")
//        container.persistentStoreDescriptions = [description]
//        container.loadPersistentStores { (storeDescription, error) in
//            if let error = error {
//                // 오류 처리
//                print("Unresolved error \(error)")
//            }
//        }
//        
//        let context = container.viewContext
//        
//        // 중복된 정류장이 있는지 확인
//        let fetchRequest: NSFetchRequest<BusStop> = BusStop.fetchRequest()
//        fetchRequest.predicate = NSPredicate(format: "stationName == %@", busStop.stationName)
//        
//        do {
//            let matchingStops = try context.fetch(fetchRequest)
//            if matchingStops.isEmpty {
//                // 새로운 BusStop 객체 생성
//                let newBusStop = BusStop(context: context)
//                newBusStop.stationName = busStop.stationName
//                newBusStop.mobileNo = busStop.mobileNo
//                
//                // 선택된 노선들을 Core Data에 저장
//                for routeInfo in selectedRoutes {
//                    let newBusRoute = BusRoute(context: context)
//                    newBusRoute.routeName = routeInfo.routeName
//                    newBusRoute.routeTypeCd = routeInfo.routeTypeCd
//                    
//                    newBusStop.addToRoutes(newBusRoute)
//                    //                    newBusRoute.busStop = newBusStop // 1:N 관계 설정
//                }
//                
//                try context.save()
//            } else {
//                // 중복된 정류장이 있으면 저장하지 않음
//                self.showAlert = true
//            }
//        } catch {
//            print("저장 중 오류 발생: \(error)")
//        }
//    }
        //========처음에 쓰던거, 일단 된거 같기도??=============
        let context = PersistenceController.shared.container.viewContext
       
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

//extension BusStop {
//    // 이 메서드는 CoreData에 새로운 노선을 추가합니다.
//    func addRoute(_ route: BusRoute) {
//        let routes = self.mutableSetValue(forKey: #keyPath(BusStop.routes))
//        routes.add(route)
//    }
//}


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
