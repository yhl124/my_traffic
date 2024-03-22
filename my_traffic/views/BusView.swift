//
//  BusView.swift
//  my_traffic
//
//  Created by yhl on 2024/03/20.
//

import Foundation
import SwiftUI

struct BusView: View{
    @State private var searchText: String = ""
    
    var body: some View{
        NavigationView{
            VStack{
                Text("Bus view")
                    .padding()
            }
        }
        .navigationTitle("버스 정류장 검색")
        .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "정류장 검색")
    }
}


#Preview {
    BusView()
}
