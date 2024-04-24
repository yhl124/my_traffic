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
    @StateObject private var busRealTimeViewModel = BusRealTimeViewModel() // BusRealTimeViewModel 추가
    
    @FetchRequest(
        sortDescriptors: [],
        animation: .default)
    private var busStops: FetchedResults<BusStop>
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(UIColor.systemGray6).edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                VStack {
                    List {
                        ForEach(busStops) { busStop in
                            VStack(alignment: .leading) {
                                Text("\(busStop.stationName ?? "Unknown") (\(busStop.mobileNo ?? "No Mobile No"))")
                                    .font(.headline)
                                
                                // XML 데이터를 가져오는 부분
                                ForEach(Array(busStop.routes as? Set<BusRoute> ?? []), id: \.self) { route in
                                    VStack(alignment: .leading) {
                                        HStack {
                                            Text("\(route.routeName ?? "") (\(route.routeTypeCd ?? ""))")
                                            Spacer()
                                            // 실시간 정보를 표시합니다.
                                            if let realTimeInfo = busRealTimeViewModel.busRealTimeInfos.first(where: { $0.routeId == route.routeId }) {
                                                HStack {
                                                    Text("\(realTimeInfo.predictTime1)분 ")
                                                    Text("\(realTimeInfo.predictTime2)분")
                                                }
                                            } else {
                                                Text("실시간 정보 없음")
                                                    .foregroundColor(.red)
                                            }
                                        }
                                    }
                                }
                                .onAppear {
                                    busRealTimeViewModel.fetchRealTimeInfo()
                                }
                            }
                        }
            
//                    List {
//                        ForEach(busStops) { busStop in
//                            VStack(alignment: .leading) {
//                                Text("\(busStop.stationName ?? "Unknown") (\(busStop.mobileNo ?? "No Mobile No"))")
//                                    .font(.headline)
//                                ForEach(Array(busStop.routes as? Set<BusRoute> ?? []), id: \.self) { route in
//                                    VStack(alignment: .leading) {
//                                        HStack {
//                                            Text("\(route.routeName ?? "") (\(route.routeTypeCd ?? ""))")
//                                            Spacer()
//                                            if let realTimeInfo = busRealTimeViewModel.busRealTimeInfos.first(where: { $0.routeId == route.routeId }) {
//                                                HStack {
//                                                    Text("\(realTimeInfo.predictTime1)분 ")
//                                                    Text("\(realTimeInfo.predictTime2)분")
//                                                }
//                                            } else {
//                                                Text("실시간 정보 없음")
//                                                    .foregroundColor(.red) // 원하는 스타일 및 색상으로 설정
//                                            }
//                                        }
//                                    }
//                                }
//                            }
//                        }
//                    List {
//                        ForEach(busStops) { busStop in
//                            VStack(alignment: .leading) {
//                                Text("\(busStop.stationName ?? "Unknown") (\(busStop.mobileNo ?? "No Mobile No"))")
//                                    .font(.headline)
//                                ForEach(Array(busStop.routes as? Set<BusRoute> ?? []), id: \.self) { route in
//                                    Text("\(route.routeName ?? "") - \(route.routeTypeCd ?? "")")
//                                }
//                            }
//                        }
                        .onDelete { indexSet in
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
                    .listStyle(PlainListStyle())
                    .listRowInsets(EdgeInsets()) // 리스트 행의 좌우 여백 제거
                    .padding(.top)
                    
                    HStack(alignment: .bottom) {
                        NavigationLink(destination: SubwayView()) {
                            ZStack {
                                Circle()
                                    .foregroundColor(.blue)
                                    .frame(width: 60, height: 60)
                                Image(systemName: "train.side.front.car")
                                    .foregroundColor(.white)
                            }
                        }
                        Spacer()
                        NavigationLink(destination: BusView()) {
                            ZStack {
                                Circle()
                                    .foregroundColor(.blue)
                                    .frame(width: 60, height: 60)
                                Image(systemName: "bus")
                                    .foregroundColor(.white)
                            }
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("위젯 설정")
            .navigationBarItems(
                trailing: NavigationLink(destination: SettingView()) {
                    Image(systemName: "gear")
                }
            )
//            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
