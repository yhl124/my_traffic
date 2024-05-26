//
//  myTrafficExWidget.swift
//  myTrafficExWidget
//
//  Created by yhl on 4/20/24.
//

import WidgetKit
import SwiftUI
import CoreData


//기존
//struct BusStopWidgetEntryView: View {
//    var entry: BusStopProvider.Entry
//
//    var body: some View {
//        GeometryReader { geometry in
//            VStack {
//                if let busStops = entry.busStops {
//                    let itemWidth = geometry.size.width / 2
//
//                    let columns = [
//                        GridItem(.fixed(itemWidth)),
//                        GridItem(.fixed(itemWidth))
//                    ]
//                    
//                    LazyVGrid(columns: columns, spacing: 1) {
//                        ForEach(busStops, id: \.objectID) { busStop in
//                            BusStopView(busStop: busStop, itemWidth: itemWidth)
//                        }
//                    }
//                } else {
//                    Text("No bus stops found")
//                }
//            }
//        }
//    }
//}
//
//struct BusStopView: View {
//    var busStop: BusStop
//    var itemWidth: CGFloat
//
//    var body: some View {
//        VStack(alignment: .leading) {
//            Text("\(busStop.stationName ?? "") (\(busStop.mobileNo ?? ""))")
//                .font(.system(size: 14))
//                .lineLimit(1)
//                .truncationMode(.tail)
//            
//            if let routes = busStop.routes?.allObjects as? [BusRoute] {
//                ForEach(routes, id: \.objectID) { route in
//                    BusRouteView(route: route)
//                }
//            }
//        }
//        .frame(width: itemWidth)
//        .background(Color.gray.opacity(0.1))
//        .cornerRadius(8)
//    }
//}
//
//struct BusRouteView: View {
//    var route: BusRoute
//
//    var body: some View {
//        Text(route.routeName ?? "")
//            .font(.caption)
//            .foregroundColor(.secondary)
//    }
//}
//
//struct myTrafficExWidget: Widget {
//    let kind: String = "BusStopWidget"
//
//    var body: some WidgetConfiguration {
//        StaticConfiguration(kind: kind, provider: BusStopProvider()) { entry in
//            BusStopWidgetEntryView(entry: entry)
//        }
//        .configurationDisplayName("Bus Stops")
//        .description("Shows nearby bus stops.")
//    }
//}
//
//
//
//struct BusStopProvider: TimelineProvider {
//    typealias Entry = BusStopEntry
//
//    func placeholder(in context: Context) -> BusStopEntry {
//        BusStopEntry(date: Date(), busStops: nil)
//    }
//
//    func getSnapshot(in context: Context, completion: @escaping (BusStopEntry) -> ()) {
//        let entry = BusStopEntry(date: Date(), busStops: nil)
//        completion(entry)
//    }
//
//    func getTimeline(in context: Context, completion: @escaping (Timeline<BusStopEntry>) -> ()) {
//        var entries: [BusStopEntry] = []
//        
//        let container = NSPersistentContainer(name: "my_traffic")
//        let storeURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.mytraffic")!.appendingPathComponent("my_traffic.sqlite")
//        let storeDescription = NSPersistentStoreDescription(url: storeURL)
//        container.persistentStoreDescriptions = [storeDescription]
//        container.loadPersistentStores { _, error in
//            guard error == nil else {
//                print("Error loading store: \(error!)")
//                return
//            }
//            
//            let context = container.viewContext
//            
//            let fetchRequest: NSFetchRequest<BusStop> = NSFetchRequest<BusStop>(entityName: "BusStop")
//            do {
//                let busStops = try context.fetch(fetchRequest)
//                //print("fffffffffffffffffffffffffffffffffffffffffff")
//                //print(busStops)
//                let currentDate = Date()
//                let entry = BusStopEntry(date: currentDate, busStops: busStops)
//                entries.append(entry)
//            } catch {
//                print("Error fetching bus stops: \(error)")
//            }
//
//            let timeline = Timeline(entries: entries, policy: .atEnd)
//            completion(timeline)
//        }
//    }
//}
//
//struct BusStopEntry: TimelineEntry {
//    let date: Date
//    let busStops: [BusStop]?
//}

import Foundation
import Combine

class BusRealTimeViewModel: ObservableObject {
    @Published var busRealTimeInfos: [BusRealTimeInfo] = []
    @Published var isLoading = false

    func fetchBusRealTimes(stationId: String, completion: @escaping ([BusRealTimeInfo]) -> Void) {
        isLoading = true
        let apiKey = KeyOutput.getAPIKey(for: "BusStopSearch")

        guard let encodedStationId = stationId.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            print("Failed to encode stationId")
            isLoading = false
            return
        }

        let urlString = "https://apis.data.go.kr/6410000/busarrivalservice/getBusArrivalList?serviceKey=\(apiKey)&stationId=\(encodedStationId)"
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            isLoading = false
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Error fetching data: \(error?.localizedDescription ?? "Unknown error")")
                DispatchQueue.main.async {
                    self.isLoading = false
                }
                return
            }

            DispatchQueue.main.async {
                let realTimeInfos = self.parseXMLRealTimeData(data: data)
                self.isLoading = false
                completion(realTimeInfos)
            }
        }.resume()
    }

    private func parseXMLRealTimeData(data: Data) -> [BusRealTimeInfo] {
        var realtimes = [BusRealTimeInfo]()
        let parser = XMLParser(data: data)
        let xmlDelegate = XMLParserDelegateKKRtime()
        parser.delegate = xmlDelegate

        if parser.parse() {
            realtimes = xmlDelegate.busRealTimes
        }
        return realtimes
    }
}


struct BusStopWidgetEntryView: View {
    var entry: BusStopProvider.Entry

    var body: some View {
        GeometryReader { geometry in
            VStack {
                if let busStops = entry.busStops {
                    let itemWidth = geometry.size.width / 2

                    let columns = [
                        GridItem(.fixed(itemWidth)),
                        GridItem(.fixed(itemWidth))
                    ]
                    
                    LazyVGrid(columns: columns, spacing: 1) {
                        ForEach(busStops, id: \.objectID) { busStop in
                            BusStopView(busStop: busStop, itemWidth: itemWidth)
                        }
                    }
                } else {
                    Text("No bus stops found")
                }
            }
        }
    }
}

struct BusStopView: View {
    var busStop: BusStop
    var itemWidth: CGFloat

    var body: some View {
        VStack(alignment: .leading) {
            //gpt4o
            if let stationName = busStop.stationName, let mobileNo = busStop.mobileNo {
                Text("\(stationName) (\(mobileNo))")
                    .font(.system(size: 14))
                    .lineLimit(1)
                    .truncationMode(.tail)
            }
//            //기존
//            Text("\(busStop.stationName ?? "") (\(busStop.mobileNo ?? ""))")
//                .font(.system(size: 14))
//                .lineLimit(1)
//                .truncationMode(.tail)
            
            if let routes = busStop.routes?.allObjects as? [BusRoute] {
                ForEach(routes, id: \.objectID) { route in
                    BusRouteView(route: route)
                }
            }
        }
        .frame(width: itemWidth)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(8)
    }
}

struct BusRouteView: View {
    var route: BusRoute

    var body: some View {
        Text(route.routeName ?? "")
            .font(.caption)
            .foregroundColor(.secondary)
    }
}

struct myTrafficExWidget: Widget {
    let kind: String = "BusStopWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: BusStopProvider()) { entry in
            BusStopWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Bus Stops")
        .description("Shows nearby bus stops.")
    }
}

struct BusStopProvider: TimelineProvider {
    typealias Entry = BusStopEntry

    func placeholder(in context: Context) -> BusStopEntry {
        BusStopEntry(date: Date(), busStops: nil, busRealTimes: nil)
    }

    func getSnapshot(in context: Context, completion: @escaping (BusStopEntry) -> ()) {
        let entry = BusStopEntry(date: Date(), busStops: nil, busRealTimes: nil)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<BusStopEntry>) -> ()) {
        var entries: [BusStopEntry] = []

        let container = NSPersistentContainer(name: "my_traffic")
        let storeURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.mytraffic")!.appendingPathComponent("my_traffic.sqlite")
        let storeDescription = NSPersistentStoreDescription(url: storeURL)
        container.persistentStoreDescriptions = [storeDescription]
        container.loadPersistentStores { _, error in
            guard error == nil else {
                print("Error loading store: \(error!)")
                return
            }

            let context = container.viewContext
            let fetchRequest: NSFetchRequest<BusStop> = NSFetchRequest<BusStop>(entityName: "BusStop")
            do {
                let busStops = try context.fetch(fetchRequest)
                let group = DispatchGroup()
                var busRealTimeInfos: [BusRealTimeInfo] = []
                let realTimeViewModel = BusRealTimeViewModel()
//
//                for busStop in busStops {
//                    group.enter()
//                    realTimeViewModel.fetchBusRealTimes(stationId: busStop.stationId ?? "") { realTimes in
//                        busRealTimeInfos.append(contentsOf: realTimes)
//                        group.leave()
//                    }
//                }
//
//                group.notify(queue: .main) {
                    let currentDate = Date()
                    let entry = BusStopEntry(date: currentDate, busStops: busStops, busRealTimes: busRealTimeInfos)
                    entries.append(entry)
//
                    let timeline = Timeline(entries: entries, policy: .atEnd)
                    completion(timeline)
//                }
            } catch {
                print("Error fetching bus stops: \(error)")
            }
        }
    }
}

struct BusStopEntry: TimelineEntry {
    let date: Date
    let busStops: [BusStop]?
    let busRealTimes: [BusRealTimeInfo]?
}
