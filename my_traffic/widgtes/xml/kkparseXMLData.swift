//
//  kkparseXMLData.swift
//  my_traffic
//
//  Created by yhl on 4/6/24.
//

import Foundation

struct BusStationInfo: Identifiable{
    var id = UUID()
    
    let mobileNo: String
    let stationName: String
    let stationId: String
}

func parseXMLData(_ data: Data) -> [BusStationInfo] {
    var busStationInfoList: [BusStationInfo] = []
    
    if let xmlDocument = try? XMLDocument(data: data) {
        if let root = xmlDocument.root {
            let busStationLists = root.nodes(forXPath: "/response/msgBody/busStationList")
            for busStationList in busStationLists {
                if let mobileNo = busStationList.nodes(forXPath: "mobileNo")[0].stringValue,
                   let stationName = busStationList.nodes(forXPath: "stationName")[0].stringValue,
                   let stationId = busStationList.nodes(forXPath: "stationId")[0].stringValue {
                    let busStationInfo = BusStationInfo(mobileNo: mobileNo, stationName: stationName, stationId: stationId)
                    busStationInfoList.append(busStationInfo)
                }
            }
        }
    }
    
    return busStationInfoList
}


//func fetchXMLData(from url: URL) async throws -> Data {
//    let (data, response) = try await URLSession.shared.data(from: url)
//    
//    guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
//        throw URLError(.badServerResponse)
//    }
//    
//    return data
//}

