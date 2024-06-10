//
//  SubwayView.swift
//  my_traffic
//
//  Created by yhl on 2024/03/20.
//

import Foundation
import SwiftUI

struct SubwayView: View {
    @StateObject private var networkManager = NetworkManager()
    @State private var searchQuery: String = ""
    
    var body: some View {
        VStack {
            List(networkManager.stations) { station in
                Text("\(station.lineNumber) \(station.stationName)(\(station.frCode))")
            }
            .listStyle(PlainListStyle())
        }
        .searchable(text: $searchQuery, placement: .navigationBarDrawer, prompt: "지하철 역 검색")
        .navigationTitle("지하철 역 검색")
        .navigationBarTitleDisplayMode(.inline)
        .onSubmit(of: .search) {
            networkManager.fetchData(keyword: searchQuery)
        }
    }
}
