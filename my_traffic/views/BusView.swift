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
    @State private var selectedBusStop: BusStop? // Track the selected bus stop
    
    var body: some View {
        VStack{
            NavigationView {
                List(viewModel.busStops, id: \.id) { item in
                    VStack(alignment: .leading) {
                        Text(item.nodenm)
                        Text("\(item.nodeno)")
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
            .sheet(item: $selectedBusStop) { busStop in
                BusStopDetailView(busStop: busStop)
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
