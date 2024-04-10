//
//  RealTimeTraffic.swift
//  RealTimeTraffic
//
//  Created by yhl on 4/10/24.
//


import WidgetKit
import SwiftUI
import CoreData

struct RealTimeTrafficWidget: Widget {
    private let kind: String = "RealTimeTrafficWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            RealTimeTrafficWidgetView(entry: entry)
        }
        .configurationDisplayName("Real Time Traffic")
        .description("Display real-time bus stop and route information.")
        .supportedFamilies([.systemMedium, .systemLarge])
    }
}

struct RealTimeTrafficWidgetView: View {
    var entry: Provider.Entry
    
    var body: some View {
        VStack {
            Text("Real Time Traffic Widget")//.font(.headline)
            
            // Display bus stop and route information
            ForEach(entry.busStops, id: \.self) { busStop in
                VStack(alignment: .leading) {
                    Text("\(busStop.stationName ?? "Unknown") (\(busStop.mobileNo ?? "No Mobile No"))")
                        .font(.headline)
                    ForEach(Array(busStop.routes as? Set<BusRoute> ?? []), id: \.self) { route in
                        Text("\(route.routeName ?? "") - \(route.routeTypeCd ?? "")")
                    }
                }
            }
        }
        .padding()
    }
}

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), busStops: [])
    }
    
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), busStops: [])
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> ()) {
        // Fetch bus stop and route information from CoreData
        let busStops: [BusStop] = [] // Fetch bus stops from CoreData
        
        // Create timeline entries with fetched data
        let entries = [SimpleEntry(date: Date(), busStops: busStops)]
        
        // Define update policy
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let busStops: [BusStop]
}

//@main
struct RealTimeTrafficWidgetBundle: WidgetBundle {
    var body: some Widget {
        RealTimeTrafficWidget()
    }
}



//import WidgetKit
//import SwiftUI
//
//struct Provider: TimelineProvider {
//    func placeholder(in context: Context) -> WidgetEntry {
//        let placeholderBusStop = BusStop()
//        placeholderBusStop.stationName = "Placeholder Station"
//        placeholderBusStop.mobileNo = "12345"
//        
//        let placeholderRoute = BusRoute()
//        placeholderRoute.routeName = "Placeholder Route"
//        placeholderRoute.routeTypeCd = "Type A"
//        
//        placeholderBusStop.addToRoutes(placeholderRoute)
//        
//        return WidgetEntry(date: Date(), busStops: [placeholderBusStop])
//    }
//
//    func getSnapshot(in context: Context, completion: @escaping (WidgetEntry) -> ()) {
//        let entry = WidgetData.previewEntry
//        completion(entry)
//    }
//
//    func getTimeline(in context: Context, completion: @escaping (Timeline<WidgetEntry>) -> ()) {
//        let currentDate = Date()
//        let entry = WidgetData.previewEntry
//        let timeline = Timeline(entries: [entry], policy: .atEnd)
//        completion(timeline)
//    }
////    func placeholder(in context: Context) -> SimpleEntry {
////        SimpleEntry(date: Date(), emoji: "😀")
////    }
////
////    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
////        let entry = SimpleEntry(date: Date(), emoji: "😀")
////        completion(entry)
////    }
////
////    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
////        var entries: [SimpleEntry] = []
////
////        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
////        let currentDate = Date()
////        for hourOffset in 0 ..< 5 {
////            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
////            let entry = SimpleEntry(date: entryDate, emoji: "😀")
////            entries.append(entry)
////        }
////
////        let timeline = Timeline(entries: entries, policy: .atEnd)
////        completion(timeline)
////    }
//}
//
//struct WidgetData {
//    static var previewEntry: WidgetEntry = {
//        let context = PersistenceController.shared.container.viewContext
//        let busStops = try! context.fetch(BusStop.fetchRequest()) as! [BusStop]
//        return WidgetEntry(date: Date(), busStops: busStops)
//    }()
//}
//
//struct WidgetEntry: TimelineEntry {
//    let date: Date
//    let busStops: [BusStop]
//}
//
//struct RealTimeTrafficEntryView : View {
//    var entry: Provider.Entry
//
//     var body: some View {
//         VStack {
//             Text("Bus Stops")
//                 .font(.title)
//                 .fontWeight(.bold)
//                 .padding()
//             ForEach(entry.busStops) { busStop in
//                 VStack(alignment: .leading) {
//                     Text("\(busStop.stationName ?? "Unknown") (\(busStop.mobileNo ?? "No Mobile No"))")
//                         .font(.headline)
//                     ForEach(Array(busStop.routes as? Set<BusRoute> ?? []), id: \.self) { route in
//                         Text("\(route.routeName ?? "") - \(route.routeTypeCd ?? "")")
//                     }
//                 }
//             }
//         }
//     }
//
////
////    var body: some View {
////        VStack {
////            Text("Time:")
////            Text(entry.date, style: .time)
////
////            Text("Emoji:")
////            Text(entry.emoji)
////        }
////    }
//}
//
//struct RealTimeTraffic: Widget {
//    let kind: String = "RealTimeTraffic"
//    
//    var body: some WidgetConfiguration {
//        StaticConfiguration(kind: kind, provider: Provider()) { entry in
//            RealTimeTrafficEntryView(entry: entry)
//        }
//        .configurationDisplayName("Bus Stops Widget")
//        .description("Shows the list of bus stops with their routes.")
//    }
//
////    var body: some WidgetConfiguration {
////        StaticConfiguration(kind: kind, provider: Provider()) { entry in
////            if #available(iOS 17.0, *) {
////                RealTimeTrafficEntryView(entry: entry)
////                    .containerBackground(.fill.tertiary, for: .widget)
////            } else {
////                RealTimeTrafficEntryView(entry: entry)
////                    .padding()
////                    .background()
////            }
////        }
////        .configurationDisplayName("My Widget")
////        .description("This is an example widget.")
////    }
//}
//
//struct RealTimeTraffic_Previews: PreviewProvider {
//    static var previews: some View {
//        RealTimeTrafficEntryView(entry: WidgetData.previewEntry)
//            .previewContext(WidgetPreviewContext(family: .systemMedium))
//    }
//}
//
////#Preview(as: .systemSmall) {
////    RealTimeTraffic()
////} timeline: {
////    SimpleEntry(date: .now, emoji: "😀")
////    SimpleEntry(date: .now, emoji: "🤩")
////}
