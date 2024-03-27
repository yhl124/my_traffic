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
    @State private var selectedBusStop: BusStop? = nil
    @State private var isShowingBusStopDetail = false
    
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
                        isShowingBusStopDetail = true
                    }
                }
                .listStyle(.plain) // 리스트 스타일 지정 (선택 가능하도록)
//                .sheet(isPresented: $isShowingBusStopDetail) {
//                    if let selectedBusStop = selectedBusStop {
//                        BusStopDetailView(busStop: selectedBusStop)
//                    }
//                }
                .sheet(isPresented: $isShowingBusStopDetail) {
                    VStack {
                        HStack {
                            Text("Bus Stop Detail")
                                .font(.headline)
                                .padding()
                            
                            Spacer()
                            
                            Button(action: {
                                isShowingBusStopDetail = false
                            }) {
                                Text("닫기")
                                    .font(.headline)
                                    .padding()
                            }
                        }
                        
                        // BusStopDetailView 내용 추가
                        if let selectedBusStop = selectedBusStop {
                            BusStopDetailView(busStop: selectedBusStop)
                        }
                        
                        Spacer()
                    }
                }
            }
            .navigationTitle("버스 정류장 검색")
            .navigationBarTitleDisplayMode(.inline)
            .searchable(text: $viewModel.searchQuery, placement: .navigationBarDrawer, prompt: "정류장 검색")
//            .sheet(isPresented: $isShowingBusStopDetail) {
//                if let selectedBusStop = selectedBusStop {
//                    BusStopDetailView(busStop: selectedBusStop)
//                }
//            }
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
