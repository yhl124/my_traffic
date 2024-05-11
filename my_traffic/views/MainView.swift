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
    
    @FetchRequest(sortDescriptors: [], animation: .default)
    private var busStops: FetchedResults<BusStop>
    
    var body: some View {
        NavigationStack {
            ZStack {
                BackgroundView()
                VStack {
                    BusStopListView(busStops: busStops, viewContext: viewContext)
                    NavigationButtons()
                }
            }
            .navigationTitle("위젯 설정")
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
    
    var body: some View {
        List {
            ForEach(busStops) { busStop in
                BusStopView(busStop: busStop)
            }
            .onDelete { indexSet in
                deleteBusStops(at: indexSet)
            }
        }
        .listStyle(PlainListStyle())
        .listRowInsets(EdgeInsets())
        .padding(.top)
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
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("\(busStop.stationName ?? "Unknown") (\(busStop.mobileNo ?? "No Mobile No"))")
                .font(.headline)
            ForEach(Array(busStop.routes as? Set<BusRoute> ?? []), id: \.self) { route in
                Text("\(route.routeName ?? "") - \(route.routeTypeCd ?? "")")
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
