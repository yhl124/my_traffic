//
//  MainView.swift
//  my_traffic
//
//  Created by yhl on 2024/03/20.
//

import Foundation
import SwiftUI
import CoreData


struct MainView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject private var busRealTimeViewModel = BusRealTimeViewModel()
    @State private var isRefreshing = false // 새로고침 상태 변수 추가
    
    @FetchRequest(sortDescriptors: [], animation: .default)
    private var busStops: FetchedResults<BusStop>
    
    var body: some View {
        NavigationStack {
            ZStack {
                BackgroundView()
                VStack {
                    BusStopListView(busStops: busStops, viewContext: viewContext, isRefreshing: $isRefreshing) // 새로고침 상태 전달
                    NavigationButtons()
                }
            }
            .navigationTitle("실시간 교통 정보")
            .navigationBarItems(trailing: SettingButton())
        }
    }
}


struct BackgroundView: View {
    var body: some View {
        Color(UIColor.systemGray6).edgesIgnoringSafeArea(.all)
    }
}

struct BusStopListView: View {
    var busStops: FetchedResults<BusStop>
    var viewContext: NSManagedObjectContext
    @Binding var isRefreshing: Bool // 새로고침 상태 바인딩
    
    var body: some View {
        List {
            ForEach(busStops) { busStop in
                BusStopView(busStop: busStop, isRefreshing: $isRefreshing) // 새로고침 상태 전달
            }
            .onDelete { indexSet in
                deleteBusStops(at: indexSet)
            }
        }
        .listStyle(PlainListStyle())
        .listRowInsets(EdgeInsets())
        .padding(.top)
        .refreshable {
            isRefreshing = true // 새로고침 시작
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { // 1초 후 새로고침 완료 처리
                isRefreshing = false
            }
        }
    }
    
    private func deleteBusStops(at indexSet: IndexSet) {
        for index in indexSet {
            let busStop = busStops[index]
            viewContext.delete(busStop)
        }
        do {
            try viewContext.save()
        } catch {
            print("Error deleting bus stop: \(error.localizedDescription)")
        }
    }
}

struct BusStopView: View {
    let busStop: BusStop
    @StateObject var busRealTimeViewModel = BusRealTimeViewModel()
    @Binding var isRefreshing: Bool

    var body: some View {
        VStack(alignment: .leading) {
            Text("\(busStop.stationName ?? "Unknown") (\(busStop.mobileNo ?? "No Mobile No"))")
                .font(.headline)

            if busRealTimeViewModel.isLoading {
                ProgressView()
            } else {
                let routesArray = Array(busStop.routes as? Set<BusRoute> ?? [])
                let sortedRoutes = routesArray.sorted(by: { (route1, route2) -> Bool in
                    if let type1 = route1.routeTypeCd, let type2 = route2.routeTypeCd {
                        if type1 != type2 {
                            return type1 < type2
                        } else {
                            return route1.routeName ?? "" < route2.routeName ?? ""
                        }
                    }
                    return false
                })
                
                ForEach(sortedRoutes, id: \.self) { route in
                    // 버스 노선의 위치 정보를 가져와서 표시
                    HStack {
                        //routeId까지 표시
                        //Text("\(route.routeName ?? "") - \(route.routeTypeCd ?? "") - \(route.routeId ?? "")")
                        Text("\(route.routeName ?? "") - \(route.routeTypeCd ?? "")")
                            .frame(maxWidth: .infinity, alignment: .leading) // 왼쪽 정렬
                        if let realTimeInfo = busRealTimeViewModel.busRealTimeInfos.first(where: { $0.routeId == route.routeId }) {
                            Text("\(realTimeInfo.predictTime1)분(\(realTimeInfo.locationNo1)전) \(realTimeInfo.predictTime2)분(\(realTimeInfo.locationNo2)전)")
                                .frame(maxWidth: .infinity, alignment: .trailing) // 오른쪽 정렬
                        } else {
                            Text("도착 정보 없음")
                                .frame(maxWidth: .infinity, alignment: .trailing) // 오른쪽 정렬
                        }
                    }
                }
            }
        }
        .onAppear {
            // 버스 정류장의 stationId를 사용하여 실시간 정보 검색
            busRealTimeViewModel.searchBusRealTimes(stationId: busStop.stationId ?? "") { infos in
                self.busRealTimeViewModel.busRealTimeInfos = infos
            }
        }
        .onChange(of: isRefreshing) { newValue, _ in
            if !newValue {
                // 새로고침이 완료되면 실시간 정보를 다시 가져옴
                busRealTimeViewModel.searchBusRealTimes(stationId: busStop.stationId ?? "") { infos in
                    self.busRealTimeViewModel.busRealTimeInfos = infos
                }
            }
        }
    }
}

struct NavigationButtons: View {
    var body: some View {
        HStack(alignment: .bottom) {
            NavigationLink(destination: SubwayView()) {
                NavigationButton(icon: "train.side.front.car")
            }
            Spacer()
            NavigationLink(destination: BusView()) {
                NavigationButton(icon: "bus")
            }
        }
        .padding()
    }
}

struct NavigationButton: View {
    var icon: String
    
    var body: some View {
        ZStack {
            Circle()
                .foregroundColor(.blue)
                .frame(width: 60, height: 60)
            Image(systemName: icon)
                .foregroundColor(.white)
        }
    }
}

struct SettingButton: View {
    var body: some View {
        NavigationLink(destination: SettingView()) {
            Image(systemName: "gear")
        }
    }
}
