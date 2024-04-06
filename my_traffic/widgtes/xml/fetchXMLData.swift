//
//  fetchXMLData.swift
//  my_traffic
//
//  Created by yhl on 4/6/24.
//

import Foundation

func fetchXMLData(from url: URL) async throws -> Data {
    let (data, response) = try await URLSession.shared.data(from: url)
    
    guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
        throw URLError(.badServerResponse)
    }
    
    return data
}
