//
//  SubwaySearch.swift
//  my_traffic
//
//  Created by yhl on 2024/03/20.
//

import Foundation
import SwiftUI

struct SubwaySearch: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            TextField("Search", text: $text)
                .padding(8)
                .background(Color(.systemGray5))
                .cornerRadius(8)
                .padding(.horizontal, 8)
            
            Button(action: {
                // Clear the text field
                self.text = ""
            }) {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.gray)
                    .padding(8)
            }
        }
    }
}
