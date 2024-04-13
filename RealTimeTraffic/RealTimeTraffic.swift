//
//  RealTimeTraffic.swift
//  RealTimeTraffic
//
//  Created by yhl on 4/13/24.
//

import SwiftUI
import WidgetKit
import CoreData


class User: NSManagedObject {
    @NSManaged var stationName: String
    @NSManaged var mobileNo: String
}


// 사용자 데이터를 가져오는 함수
func fetchUsers() -> [User] {
    let container = NSPersistentContainer(name: "my_traffic")
    container.loadPersistentStores { storeDescription, error in
        if let error = error {
            print("Error loading CoreData store: \(error)")
        }
    }
    let context = container.viewContext
    let request: NSFetchRequest<User> = NSFetchRequest<User>(entityName: "BusStop")
    do {
        let users = try context.fetch(request)
        print(users)
        return users
    } catch {
        print("Error fetching users: \(error)")
        return []
    }
}

// 위젯의 SwiftUI 뷰
struct UserWidgetView: View {
    let users: [User]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Users:")
                .font(.headline)
                .padding(.bottom, 5)
            
            ForEach(users, id: \.self) { user in
                Text("\(user.stationName), \(user.mobileNo)")
                    .padding(.bottom, 5)
            }
        }
        .padding()
    }
}


struct RealTimeTraffic: Widget {
    let kind: String = "UserWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            UserWidgetView(users: entry.users)
        }
        .configurationDisplayName("User Widget")
        .description("Display users from CoreData.")
        .supportedFamilies([.systemMedium])
    }
}

struct UserEntry: TimelineEntry {
    let date: Date
    let users: [User]
}

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> UserEntry {
        let users = fetchUsers()
        return UserEntry(date: Date(), users: users)
    }

    func getSnapshot(in context: Context, completion: @escaping (UserEntry) -> ()) {
        let users = fetchUsers()
        let entry = UserEntry(date: Date(), users: users)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<UserEntry>) -> ()) {
        let users = fetchUsers()
        let entry = UserEntry(date: Date(), users: users)
        let timeline = Timeline(entries: [entry], policy: .atEnd)
        completion(timeline)
    }
}



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
//
//struct SimpleEntry: TimelineEntry {
//    let date: Date
//    let configuration: ConfigurationAppIntent
//}
//
//struct RealTimeTrafficEntryView : View {
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
//struct RealTimeTraffic: Widget {
//    let kind: String = "RealTimeTraffic"
//
//    var body: some WidgetConfiguration {
//        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
//            RealTimeTrafficEntryView(entry: entry)
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
//    RealTimeTraffic()
//} timeline: {
//    SimpleEntry(date: .now, configuration: .smiley)
//    SimpleEntry(date: .now, configuration: .starEyes)
//}
