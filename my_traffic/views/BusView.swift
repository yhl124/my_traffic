//
//  BusView.swift
//  my_traffic
//
//  Created by yhl on 2024/03/20.
//

import Foundation	
import SwiftUI

//struct BusView: View{
//    @State private var searchText: String = ""
//    @State private var busStops: [BusStop] = []
//    let apikey = ApiClass()
//    
//    
//    var body: some View{
//        NavigationView{
//            VStack{
//                List(busStops, id: \.id) { busStop in Text(busStop.name)
//            }
//            .navigationTitle("버스 정류장 검색")
//            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "정류장 검색")
//            .onSubmit(of: .search) {
//                fetchBusStops()
//            }
//        }
//    }
//    private func fetchBusStops() {
//        apikey.fetchBusStops(for: searchText) { fetchedStops in
//            if let fetchedStops = fetchedStops {
//                self.busStops = fetchedStops
//            }
//        }
//    }
//}

//struct BusView: View {
//    @State private var searchText: String = ""
//    @State private var busStops: [BusStop] = []
//    let api = ApiClass() 
//
//    var body: some View {
//        NavigationView {
//            VStack {
//                List(busStops, id: \.id) { busStop in
//                    Text(busStop.name)
//                    // Add other views for displaying bus stop information
//                }
//            }
//        }
//        .navigationTitle("버스 정류장 검색")
//        .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "정류장 검색") // 검색 가능한 TextField를 추가합니다.
//        .onSubmit(of: .search) {
//            fetchBusStops()
//        }
//    }
//    
//    private func fetchBusStops() {
//        api.fetchBusStops(for: searchText) { fetchedStops in
//            if let fetchedStops = fetchedStops {
//                self.busStops = fetchedStops
//            }
//        }
//    }
//}

//struct BusView: View {
//    @State private var searchQuery = ""
//    @State private var busStops: [BusStopData.ResponseBody.Body.Items.Item] = []
//
//    
//    
//    var body: some View {
//        NavigationView {
//            VStack {
////                TextField("Search for bus stop", text: $searchQuery, onCommit: searchBusStops)
////                    .textFieldStyle(RoundedBorderTextFieldStyle())
////                    .padding()
//                
//                List(busStops) { busStop in
//                    VStack(alignment: .leading) {
//                        Text(busStop.nodenm) // 정류장 이름
//                        Text("정류소 번호: \(busStop.nodeno)") // 정류소 번호
//                    }
//                }
//            }
//            .navigationBarTitle("버스 정류장 검색")
//            // 검색 가능한 TextField를 추가합니다.
//            .searchable(text: $searchQuery, placement: .navigationBarDrawer(displayMode: .always), prompt: "정류장 검색")
//            .onSubmit(of: .search) {
//                searchBusStops()
//            }
//        }
//    }
//    
//    private func searchBusStops() {
//        BusStopSearch().fetchBusStopData(query: searchQuery) { result in
//            DispatchQueue.main.async {
//                switch result {
//                case .success(let data):
//                    busStops = data.response.body.items.item
//                case .failure(let error):
//                    print("Error fetching bus stop data: \(error.localizedDescription)")
//                }
//            }
//        }
//    }
//}

struct BusView: View {
    @StateObject private var viewModel = BusStopViewModel()
    
    var body: some View {
        VStack{
        NavigationView {
                List(viewModel.busStops, id: \.id) { item in
                    VStack(alignment: .leading) {
                        Text(item.nodenm)
                        Text("\(item.nodeno)")
                    }
                }
            }
            .navigationTitle("버스 정류장 검색")
            .navigationBarTitleDisplayMode(.inline)
            .searchable(text: $viewModel.searchQuery, placement: .navigationBarDrawer, prompt: "정류장 검색")

            .onSubmit(of: .search) {
                viewModel.searchBusStops()
            }
        }
    }
}

class BusStopViewModel: ObservableObject {
    @Published var searchQuery = ""
    @Published var busStops: [BusStop] = [] // BusStop으로 데이터 타입 변경
    
    func searchBusStops() {
        BusStopSearch().fetchBusStopData(query: searchQuery) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    // 데이터를 직접 할당
                    self.busStops = data.map { BusStop(nodenm: $0.nodenm, nodeno: $0.nodeno) }
                case .failure(let error):
                    print("Error fetching bus stop data: \(error.localizedDescription)")
                }
            }
        }
    }
}


#Preview {
    BusView()
}
