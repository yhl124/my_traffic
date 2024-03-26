//
//  BustopSearch.swift
//  my_traffic
//
//  Created by yhl on 2024/03/24.
//

import Foundation

//struct BusStopData: Codable {
//    let response: ResponseBody
//    
//    struct ResponseBody: Codable {
//        let header: Header
//        let body: Body
//        
//        struct Header: Codable {
//            let resultCode: String
//            let resultMsg: String
//        }
//        
//        struct Body: Codable {
//            let items: Items
//            let numOfRows: Int
//            let pageNo: Int
//            let totalCount: Int
//            
//            struct Items: Codable {
//                let item: [Item]
//                
//                struct Item: Codable, Identifiable {
//                    var id = UUID()
//                    //let gpslati: Double
//                    //let gpslong: Double
//                    let nodeid: String
//                    let nodenm: String
//                    let nodeno: Int
//                }
//            }
//        }
//    }
//}

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
//                let item: [Item]
//            }
//        }
//    }
//    
//    struct Item: Codable, Identifiable {
//        //var id = UUID()
//        //let id: String
//        let gpslati: Double
//        let gpslong: Double
//        let nodeid: String
//        let nodenm: String
//        let nodeno: Int
//    }
//}

struct BusStop: Identifiable {
    //var id: ObjectIdentifier
    var id = UUID()
    
    let nodenm: String
    let nodeno: Int
}

extension BusStop: Codable {
    private enum CodingKeys: String, CodingKey {
        case nodenm
        case nodeno
    }
}

struct BusStopData: Codable {
    let response: Response
    
    struct Response: Codable {
        let body: Body
        
        struct Body: Codable {
            let items: Items
            let numOfRows: Int
            let pageNo: Int
            let totalCount: Int
            
            struct Items: Codable {
                let item: [BusStop]
            }
        }
    }
}

//struct BusStopSearch {
//    func fetchBusStopData(query: String, completion: @escaping (Result<BusStopData, Error>) -> Void) {
//        let apiKey = KeyOutput.getAPIKey(for: "BusStopSearch")
//        let pageNo = "1"
//        let numOfRows = "10"
//        let _type = "json"
//        let cityCode = "31160"
//        let nodeNm = "금정"
//        let baseURL = "https://apis.data.go.kr/1613000/BusSttnInfoInqireService/getSttnNoList?serviceKey=\(apiKey)&pageNo=\(pageNo)&numOfRows=\(numOfRows)&_type=\(_type)&cityCode=\(cityCode)&nodeNm=\(nodeNm)"
//        
//        guard let encodedStr = baseURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {return}
//        let encodedAndReplacingStr = encodedStr.replacingOccurrences(of: "%25", with: "%")
//        guard let url = URL(string: encodedAndReplacingStr) else {return}
//             
//        
//        var request = URLRequest(url: url)
//        request.httpMethod = "GET"
//        
//        print(request)
//        
//        URLSession.shared.dataTask(with: request) { data, response, error in
//            if let error = error {
//                completion(.failure(error))
//                return
//            }
//            
//            guard let data = data else {
//                let error = NSError(domain: "BusStopSearch", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data received"])
//                completion(.failure(error))
//                return
//            }
//            
//            // Print JSON data
//            if let jsonString = String(data: data, encoding: .utf8) {
//                print("JSON Response: \(jsonString)")
//            }
//            
////            do {
////                let response = try JSONDecoder().decode(BusStopData.self, from: data)
////                // 여기서 response.response.body.items.item에 접근하여 원하는 값들을 가져올 수 있습니다.
////                completion(.success(response))
////            } catch {
////                completion(.failure(error))
////            }
//            
//            do {
//                let response = try JSONDecoder().decode(BusStopData.self, from: data)
//                
//                // nodenm과 nodeno 추출
//                let busStops = response.response.body.items.item.map { item in
//                    return (nodenm: item.nodenm, nodeno: item.nodeno)
//                }
//                completion(.success(busStops))
//                
//                print(busStops)
//            } catch {
//                print(error)
//                completion(.failure(error))
//            }
//        }.resume()
//    }
//}

struct BusStopSearch {
    func fetchBusStopData(query: String, completion: @escaping (Result<[(nodenm: String, nodeno: Int)], Error>) -> Void) {
        let apiKey = KeyOutput.getAPIKey(for: "BusStopSearch")
        let pageNo = "1"
        let numOfRows = "10"
        let _type = "json"
        let cityCode = "31160"
        let nodeNm = "금정"
        let baseURL = "https://apis.data.go.kr/1613000/BusSttnInfoInqireService/getSttnNoList?serviceKey=\(apiKey)&pageNo=\(pageNo)&numOfRows=\(numOfRows)&_type=\(_type)&cityCode=\(cityCode)&nodeNm=\(nodeNm)"
        
        guard let encodedStr = baseURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            completion(.failure(NSError(domain: "BusStopSearch", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to encode URL"])))
            return
        }
        
        guard let url = URL(string: encodedStr) else {
            completion(.failure(NSError(domain: "BusStopSearch", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to create URL"])))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "BusStopSearch", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }
            
            // Print JSON data
            if let jsonString = String(data: data, encoding: .utf8) {
                print("JSON Response: \(jsonString)")
            }
            
            do {
                let response = try JSONDecoder().decode(BusStopData.self, from: data)
                
                // nodenm과 nodeno 추출
                let busStops = response.response.body.items.item.map { item in
                    return (nodenm: item.nodenm, nodeno: item.nodeno)
                }
                
                completion(.success(busStops))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
