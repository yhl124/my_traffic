//
//  myTrafficExWidget.swift
//  myTrafficExWidget
//
//  Created by yhl on 4/20/24.
//

import WidgetKit
import SwiftUI
import CoreData

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
                            BusStopView(busStop: busStop, itemWidth: itemWidth, realTimeInfos: entry.realTimeInfos.filter { $0.stationId == busStop.stationId })
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
    var realTimeInfos: [BusRealTimeInfo]

    var body: some View {
        VStack(alignment: .leading) {
            Text("\(busStop.stationName ?? "") (\(busStop.mobileNo ?? ""))")
                .font(.system(size: 14))
                .lineLimit(1)
                .truncationMode(.tail)

            if let routes = busStop.routes?.allObjects as? [BusRoute] {
                ForEach(routes, id: \.objectID) { route in
                    BusRouteView(route: route, realTimeInfos: realTimeInfos.filter { $0.routeId == route.routeId })
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
    var realTimeInfos: [BusRealTimeInfo]

    var body: some View {
        HStack {
            Text(route.routeName ?? "")
                .font(.caption)
                .foregroundColor(.secondary)

            if let realTimeInfo = realTimeInfos.first {
                Text(realTimeInfo.locationNo1)
                    .font(.caption)
                    .foregroundColor(.blue)
            }
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

class BusStopProvider: TimelineProvider {
    typealias Entry = BusStopEntry

    func placeholder(in context: Context) -> BusStopEntry {
        BusStopEntry(date: Date(), busStops: nil, realTimeInfos: [])
    }

    func getSnapshot(in context: Context, completion: @escaping (BusStopEntry) -> ()) {
        let entry = BusStopEntry(date: Date(), busStops: nil, realTimeInfos: [])
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
//                for busStop in busStops {
//                     print("BusStop object: \(busStop), Type: \(type(of: busStop))")
//                    print("Station Name: \(busStop.stationName ?? "No name")")
//                    print("MobileNo: \(busStop.mobileNo ?? "No mobileno")")
//                    let routes = (busStop.routes as? Set<String>)?.joined(separator: ", ") ?? "No route"
//                    print("Bus Route: \(routes)")
//                }
                let currentDate = Date()

                self.fetchRealTimeData(for: busStops) { realTimeInfos in
                    let entry = BusStopEntry(date: currentDate, busStops: busStops, realTimeInfos: realTimeInfos)
                    entries.append(entry)

                    let timeline = Timeline(entries: entries, policy: .atEnd)
                    completion(timeline)
                }
            } catch {
                print("Error fetching bus stops: \(error)")
            }
        }
    }

    private func fetchRealTimeData(for busStops: [BusStop], completion: @escaping ([BusRealTimeInfo]) -> Void) {
        let group = DispatchGroup()
        var realTimeInfos = [BusRealTimeInfo]()

        for busStop in busStops {
            if let stationId = busStop.stationId {
                group.enter()
                BusRealTimeViewModel().searchBusRealTimes(stationId: stationId) { infos in
                    realTimeInfos.append(contentsOf: infos)
                    group.leave()
                }
            }
        }

        group.notify(queue: .main) {
            completion(realTimeInfos)
        }
    }
}

struct BusStopEntry: TimelineEntry {
    let date: Date
    let busStops: [BusStop]?
    let realTimeInfos: [BusRealTimeInfo]
}


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
//
//
//
////busstop만 출력하는 코드
//struct BusStopWidgetEntryView : View {
//    var entry: BusStopProvider.Entry
//
//    var body: some View {
//        VStack {
//            if let busStops = entry.busStops {
//                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 1) {
//                    ForEach(busStops, id: \.self) { busStop in
//                        VStack(alignment: .leading) {
//                            Text("\(busStop.stationName ?? "") (\(busStop.mobileNo ?? ""))")
//                                .lineLimit(1)
//                                .truncationMode(.tail)
//                        }
//                        .background(Color.gray.opacity(0.1))
//                        .cornerRadius(8)
//                    }
//                }
//            } else {
//                Text("No bus stops found")
//            }
//        }
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
////        if let containerURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.mytraffic") {
////            print("앱 그룹 컨테이너 경로: \(containerURL.path)")
////        } else {
////            print("앱 그룹 컨테이너 경로를 찾을 수 없습니다.")
////        }
//
//
//        // Access CoreData in the app group container
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
//            // Fetch data from CoreData here
//            let fetchRequest: NSFetchRequest<BusStop> = NSFetchRequest<BusStop>(entityName: "BusStop")
//            do {
//                let busStops = try context.fetch(fetchRequest)
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

////xcode에서 제공하는 기본 코드

//class BusStop: NSManagedObject {
//    @NSManaged var stationName: String?
//    @NSManaged var mobileNo: String?
//}

//struct Provider: AppIntentTimelineProvider {
//    func placeholder(in context: Context) -> SimpleEntry {
//        SimpleEntry(date: Date(), configuration: ConfigurationAppIntent())
//    }
//
//    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
//        SimpleEntry(date: Date(), configuration: configuration)
//    }
//    
//    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
//        var entries: [SimpleEntry] = []
//
//        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
//        let currentDate = Date()
//        for hourOffset in 0 ..< 5 {
//            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
//            let entry = SimpleEntry(date: entryDate, configuration: configuration)
//            entries.append(entry)
//        }
//
//        return Timeline(entries: entries, policy: .atEnd)
//    }
//}
//
//struct SimpleEntry: TimelineEntry {
//    let date: Date
//    let configuration: ConfigurationAppIntent
//}
//
//struct myTrafficExWidgetEntryView : View {
//    var entry: Provider.Entry
//
//    var body: some View {
//        VStack {
//            Text("Time:")
//            Text(entry.date, style: .time)
//
//            Text("Favorite Emoji:")
//            Text(entry.configuration.favoriteEmoji)
//        }
//    }
//}
//
//struct myTrafficExWidget: Widget {
//    let kind: String = "myTrafficExWidget"
//
//    var body: some WidgetConfiguration {
//        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
//            myTrafficExWidgetEntryView(entry: entry)
//                .containerBackground(.fill.tertiary, for: .widget)
//        }
//    }
//}
//
//extension ConfigurationAppIntent {
//    fileprivate static var smiley: ConfigurationAppIntent {
//        let intent = ConfigurationAppIntent()
//        intent.favoriteEmoji = "😀"
//        return intent
//    }
//    
//    fileprivate static var starEyes: ConfigurationAppIntent {
//        let intent = ConfigurationAppIntent()
//        intent.favoriteEmoji = "🤩"
//        return intent
//    }
//}

//#Preview(as: .systemSmall) {
//    myTrafficExWidget()
//} timeline: {
//    SimpleEntry(date: .now, configuration: .smiley)
//    SimpleEntry(date: .now, configuration: .starEyes)
//}
