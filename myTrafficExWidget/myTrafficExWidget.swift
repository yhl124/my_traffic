//
//  myTrafficExWidget.swift
//  myTrafficExWidget
//
//  Created by yhl on 4/20/24.
//

import WidgetKit
import SwiftUI
import CoreData
import Combine
import Foundation


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
                            BusStopView(busStop: busStop, itemWidth: itemWidth, busRealTimes: entry.busRealTimes ?? [])
                        }
                        ReloadView()
                    }
                    
                } else {
                    Text("No bus stops found")
                }
            }
        }
    }
}

//기존
//struct BusStopView: View {
//    var busStop: BusStop
//    var itemWidth: CGFloat
//    var busRealTimes: [BusRealTimeInfo]
//
//    var body: some View {
//        VStack(alignment: .leading) {
//            if let stationName = busStop.stationName, let mobileNo = busStop.mobileNo {
//                Text("\(stationName) (\(mobileNo))")
//                    .font(.system(size: 14))
//                    .lineLimit(1)
//                    .truncationMode(.tail)
//            }
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
//    
////    private func getLocationInfo(for busStop: BusStop) -> String {
////        for realTimeInfo in busRealTimes {
////            if realTimeInfo.stationId == busStop.stationId {
////                if let routes = busStop.routes?.allObjects as? [BusRoute] {
////                    for route in routes {
////                        if realTimeInfo.routeId == route.routeId {
////                            print("Matching routeId found: \(route.routeId ?? "") - locationNo1: \(realTimeInfo.locationNo1)")
////                            return " - \(realTimeInfo.locationNo1)"
////                        }
////                    }
////                }
////            }
////        }
////        return ""
////    }
//
//}

//struct BusRouteView: View {
//    var route: BusRoute
//
//    var body: some View {
//        Text(route.routeName ?? "")
//            .font(.caption)
//            .foregroundColor(.secondary)
//    }
//}

struct BusStopView: View {
    var busStop: BusStop
    var itemWidth: CGFloat
    var busRealTimes: [BusRealTimeInfo]

    var body: some View {
        VStack(alignment: .leading) {
            if let stationName = busStop.stationName, let mobileNo = busStop.mobileNo {
                Text("\(stationName) (\(mobileNo))")
                    .font(.system(size: 14))
                    .lineLimit(1)
                    .truncationMode(.tail)
            }
            
            if let routes = busStop.routes?.allObjects as? [BusRoute] {
                ForEach(routes, id: \.objectID) { route in
                    BusRouteView(route: route, busRealTimes: getBusRealTimes(for: route))
                }
            }
        }
        .frame(width: itemWidth)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(8)
    }
    
    private func getBusRealTimes(for route: BusRoute) -> [BusRealTimeInfo] {
        busRealTimes.filter { $0.routeId == route.routeId }
    }
}

struct BusRouteView: View {
    var route: BusRoute
    var busRealTimes: [BusRealTimeInfo]

    var body: some View {
        HStack {
            Text(route.routeName ?? "")
                .font(.caption)
                .foregroundColor(.secondary)
                .lineLimit(1)
                .truncationMode(.tail)
            if let locationInfo = getLocationInfo() {
                Text(locationInfo)
                    .font(.caption)
                    .foregroundColor(.primary)
                    .lineLimit(1)
                    .truncationMode(.tail)
            } else {
                Text("도착 정보 없음")
                    .font(.caption)
                    .foregroundColor(.primary)
                    .lineLimit(1)
                    .truncationMode(.tail)
            }
        }
    }

    private func getLocationInfo() -> String? {
        for realTimeInfo in busRealTimes {
            if realTimeInfo.routeId == route.routeId {
                let predictTime1 = realTimeInfo.predictTime1
                let locationNo1 = realTimeInfo.locationNo1
                let predictTime2 = realTimeInfo.predictTime2
                let locationNo2 = realTimeInfo.locationNo2
                
                if !predictTime2.isEmpty && !locationNo2.isEmpty {
                    return "\(predictTime1)분(\(locationNo1)전) \(predictTime2)분(\(locationNo2)전)"
                } else {
                    return "\(predictTime1)분(\(locationNo1)전)"
                }
            }
        }
        return nil
    }
}

struct ReloadView: View {

    var body: some View {
        Button(intent: ReloadWidgetIntent()) {
            Text("Refresh")
        }
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
            let fetchRequest: NSFetchRequest<BusStop> = BusStop.fetchRequest()
            do {
                let busStops = try context.fetch(fetchRequest)
                var busRealTimeInfos: [BusRealTimeInfo] = []
                //let realTimeViewModel = BusRealTimeViewModel()

                for busStop in busStops {
                    if let stationId = busStop.stationId {
                        // 동기적으로 실시간 데이터를 가져오는 메서드 호출
                        let realTimes = fetchBusRealTimesSynchronously(stationId: stationId)
                        busRealTimeInfos.append(contentsOf: realTimes)
                    } else {
                        print("Error: stationId is nil for busStop \(busStop)")
                    }
                }

                let currentDate = Date()
                let entry = BusStopEntry(date: currentDate, busStops: busStops, busRealTimes: busRealTimeInfos)
                entries.append(entry)

                let timeline = Timeline(entries: entries, policy: .atEnd)
                completion(timeline)
            } catch {
                print("Error fetching bus stops: \(error)")
            }
        }
    }

    func fetchBusRealTimesSynchronously(stationId: String) -> [BusRealTimeInfo] {
        let semaphore = DispatchSemaphore(value: 0)
        var realTimeInfos: [BusRealTimeInfo] = []

        let apiKey = KeyOutput.getAPIKey(for: "BusStopSearch")

        guard let encodedStationId = stationId.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            print("Failed to encode stationId")
            return realTimeInfos
        }

        let urlString = "https://apis.data.go.kr/6410000/busarrivalservice/getBusArrivalList?serviceKey=\(apiKey)&stationId=\(encodedStationId)"
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return realTimeInfos
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Error fetching data: \(error?.localizedDescription ?? "Unknown error")")
                semaphore.signal()
                return
            }
            
//            // Convert data to string and print to console xml출력용
//            if let xmlString = String(data: data, encoding: .utf8) {
//                print("XML Data: \(xmlString)")
//            } else {
//                print("Failed to convert XML data to string")
//            }
            
            realTimeInfos = self.parseXMLRealTimeData(data: data)
            semaphore.signal()
        }.resume()

        semaphore.wait()
        return realTimeInfos
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

struct BusStopEntry: TimelineEntry {
    let date: Date
    let busStops: [BusStop]?
    let busRealTimes: [BusRealTimeInfo]?
}
