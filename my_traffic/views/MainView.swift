//
//  MainView.swift
//  my_traffic
//
//  Created by yhl on 2024/03/20.
//

import Foundation
import SwiftUI

struct MainView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
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
                                ForEach(Array(busStop.routes as? Set<BusRoute> ?? []), id: \.self) { route in
                                    Text("\(route.routeName ?? "") - \(route.routeTypeCd ?? "")")
                                }
                            }
                        }
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
