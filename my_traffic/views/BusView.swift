//
//  BusView.swift
//  my_traffic
//
//  Created by yhl on 2024/03/20.
//

import Foundation	
import SwiftUI

struct BusView: View {
    @StateObject private var viewModel = BusStopViewModel()
//    @State private var selectedBusStop: BusStop? // Track the selected bus stop
    @State private var selectedBusStop: BusStationInfo?
    @State private var isLoading: Bool = false // Track loading state
    
    var body: some View {
        VStack{
        NavigationView {
                List(viewModel.busStops, id: \.id) { item in
                    VStack(alignment: .leading) {
                        Text(item.stationName)
                        Text(item.mobileNo)
                    }
                    .onTapGesture {
                        selectedBusStop = item
                        
                    }
                }
                .listStyle(.plain) // 리스트 스타일 지정 (선택 가능하도록)
            }
        }
        .navigationTitle("버스 정류장 검색")
        .navigationBarTitleDisplayMode(.inline)
        .searchable(text: $viewModel.searchQuery, placement: .navigationBarDrawer, prompt: "정류장 검색")
        .onSubmit(of: .search) {
            viewModel.searchBusStops()
        }
        .sheet(item: $selectedBusStop) { BusStationInfo in
            BusStopDetailView(busStop: BusStationInfo)
        }
    }
}



class BusStopViewModel: ObservableObject {
    @Published var searchQuery = ""
//    @Published var busStops: [BusStop] = [] // BusStop으로 데이터 타입 변경
    @Published var busStops: [BusStationInfo] = []
    
    func searchBusStops() {
        //BusStopSearch().fetchBusStopData(query: searchQuery) { result in
        kkBusStopSearch().kkfetchBusStopData(query: searchQuery) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    // 데이터를 직접 할당
                    self.busStops = data.map { BusStationInfo(mobileNo: $0.mobileNo, stationName: $0.stationName, stationId: $0.stationId) }
                case .failure(let error):
                    print("Error fetching bus stop data: \(error.localizedDescription)")
                }
            }
        }
    }
}

//
//#Preview {
//    BusView()
//}
