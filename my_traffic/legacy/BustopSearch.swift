////
////  BustopSearch.swift
////  my_traffic
////
////  Created by yhl on 2024/03/24.
////
//
//import Foundation
//
//struct BusStop: Identifiable {
//    var id = UUID()
//    
//    let nodeid: String
//    let nodenm: String
//    let nodeno: Int
//}
//
//extension BusStop: Codable {
//    private enum CodingKeys: String, CodingKey {
//        case nodeid
//        case nodenm
//        case nodeno
//    }
//}
//
//struct BusStopData: Codable {
//    let response: Response
//    
//    struct Response: Codable {
//        let body: Body
//        
//        struct Body: Codable {
//            let items: Items
//            let numOfRows: Int
//            let pageNo: Int
//            let totalCount: Int
//            
//            struct Items: Codable {
//                let item: [BusStop]
//            }
//        }
//    }
//}
//
//struct BusStopSearch {
//    func fetchBusStopData(query: String, completion: @escaping (Result<[(nodeid: String, nodenm: String, nodeno: Int)], Error>) -> Void) {
//        let apiKey = KeyOutput.getAPIKey(for: "BusStopSearch")
//        //let apiKey_decoded = apiKey.removingPercentEncoding
//        let pageNo = "1"
//        let numOfRows = "10"
//        let _type = "json"
//        let cityCode = "31160"
//        let nodeNm = query
//        let baseURL = "https://apis.data.go.kr/1613000/BusSttnInfoInqireService/getSttnNoList?serviceKey=\(apiKey)&pageNo=\(pageNo)&numOfRows=\(numOfRows)&_type=\(_type)&cityCode=\(cityCode)&nodeNm=\(nodeNm)"
//        
//        guard let encodedStr = baseURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
//            completion(.failure(NSError(domain: "BusStopSearch", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to encode URL"])))
//            return
//        }
//        
//        let encodedAndReplace = encodedStr.replacingOccurrences(of: "%25", with: "%")
//        guard let url = URL(string: encodedAndReplace) else {return}
//        
////        guard let url = URL(string: encodedStr) else {
////            completion(.failure(NSError(domain: "BusStopSearch", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to create URL"])))
////            return
////        }
//        
//        var request = URLRequest(url: url)
//        request.httpMethod = "GET"
//        print(request)
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
