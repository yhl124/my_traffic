//
//  kkBusSearch.swift
//  my_traffic
//
//  Created by yhl on 4/6/24.
//

//import Foundation
//
//struct kkBusStopSearch {
//    func kkfetchBusStopData(query: String, completion: @escaping (Result<[(mobileNo: String, stationName: String, stationId: String)], Error>) -> Void) {
//        let apiKey = KeyOutput.getAPIKey(for: "BusStopSearch")
//        //let apiKey_decoded = apiKey.removingPercentEncoding
////        let pageNo = "1"
////        let numOfRows = "10"
////        let _type = "json"
////        let cityCode = "31160"
////        let nodeNm = query
////        let baseURL = "https://apis.data.go.kr/1613000/BusSttnInfoInqireService/getSttnNoList?serviceKey=\(apiKey)&pageNo=\(pageNo)&numOfRows=\(numOfRows)&_type=\(_type)&cityCode=\(cityCode)&nodeNm=\(nodeNm)"
//        
//        let keyword = query
//        let baseURL = "https://apis.data.go.kr/6410000/busstationservice/getBusStationList?serviceKey=\(apiKey)&keyword=\(keyword)"
//        
//        
//        guard let encodedStr = baseURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
//            completion(.failure(NSError(domain: "BusStopSearch", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to encode URL"])))
//            return
//        }
//        
//        let encodedAndReplace = encodedStr.replacingOccurrences(of: "%25", with: "%")
//        guard let url = URL(string: encodedAndReplace) else {return}
//                
//        Task {
//            do {
//                let xmlData = try await fetchXMLData(from: url)
//                let busStationInfoList = parseXMLData(xmlData)
//                
//                // 버스 정류장 정보 처리
//                for busStationInfo in busStationInfoList {
//                    print("mobileNo: \(busStationInfo.mobileNo), stationName: \(busStationInfo.stationName), stationId: \(busStationInfo.stationId)")
//                }
//                
//                let resArray = busStationInfoList.map { busStationInfo in
//                    (busStationInfo.mobileNo, busStationInfo.stationName, busStationInfo.stationId)
//                }
//                
//                completion(.success(resArray))
//            } catch {
//                print("Error fetching XML data: \(error)")
//            }
//        }
//        
        
//        URLSession.shared.dataTask(with: request) { data, response, error in
//            if let error = error {
//                completion(.failure(error))
//                return
//            }
//            
//            guard let data = data else {
//                completion(.failure(NSError(domain: "BusStopSearch", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
//                return
//            }
//            
//            // Print JSON data
//            if let jsonString = String(data: data, encoding: .utf8) {
//                print("JSON Response: \(jsonString)")
//            }
//            
//            do {
//                let response = try JSONDecoder().decode(BusStopData.self, from: data)
//                
//                // nodenm과 nodeno 추출
//                let busStops = response.response.body.items.item.map { item in
//                    return (nodeid: item.nodeid, nodenm: item.nodenm, nodeno: item.nodeno)
//                }
//                
//                completion(.success(busStops))
//            } catch {
//                completion(.failure(error))
//            }
//        }.resume()
//    }
//}
