//
//  SubwayView.swift
//  my_traffic
//
//  Created by yhl on 2024/03/20.
//

import Foundation
import SwiftUI

struct SubwayView: View{
    @State private var searchText: String = ""
    
    // 검색 결과를 저장할 변수
    private var searchResults: [String] {
        // 여기에 실제로 검색 기능을 구현하거나 외부 데이터를 가져와서 사용할 수 있습니다.
        // 여기서는 간단한 정적 목록을 사용하겠습니다.
        let staticData = ["Apple", "Banana", "Orange", "Grapes", "Pineapple"]
        
        // 검색어가 비어있으면 모든 항목 반환
        guard !searchText.isEmpty else {
            return staticData
        }
        
        // 검색어가 포함된 항목만 필터링하여 반환
        return staticData.filter { $0.lowercased().contains(searchText.lowercased()) }
    }
    
    var body: some View {
        NavigationView{
            VStack {
                // 검색 결과 표시
                List(searchResults, id: \.self) { result in
                    Text(result)
                }
            }
        }
        .searchable(text: $searchText, placement: .automatic, prompt: "정류장 검색")
        .navigationTitle("지하철 검색")
        
        .padding()
    }
}
