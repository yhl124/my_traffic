//
//  BustopSearch.swift
//  my_traffic
//
//  Created by yhl on 2024/03/24.
//

import Foundation

struct BusStopData: Codable {
    let response: ResponseBody
    
    struct ResponseBody: Codable {
        let header: Header
        let body: Body
        
        struct Header: Codable {
            let resultCode: String
            let resultMsg: String
        }
        
        struct Body: Codable {
            let items: Items
            let numOfRows: Int
            let pageNo: Int
            let totalCount: Int
            
            struct Items: Codable {
                let item: [Item]
                
                struct Item: Codable, Identifiable {
                    var id = UUID()
                    let gpslati: Double
                    let gpslong: Double
                    let nodeid: String
                    let nodenm: String
                    let nodeno: Int
                }
            }
        }
    }
}

struct BusStopSearch {
    func fetchBusStopData(query: String, completion: @escaping (Result<BusStopData, Error>) -> Void) {
        let apiKey = KeyOutput.getAPIKey(for: "BusStopSearch")
        print(apiKey)
        //let decodedApiKey = apiKey.removingPercentEncoding ?? apiKey
        let baseURL = "https://apis.data.go.kr/1613000/BusSttnInfoInqireService/getSttnNoList?"
        
        let queryItems = [
            //URLQueryItem(name: "serviceKey", value: decodedApiKey),
            URLQueryItem(name: "serviceKey", value: apiKey),
            URLQueryItem(name: "pageNo", value: "1"),
            URLQueryItem(name: "numOfRows", value: "10"),
            URLQueryItem(name: "_type", value: "json"),
            URLQueryItem(name: "cityCode", value: "31160"),
            URLQueryItem(name: "nodeNm", value: "금정"),
            //URLQueryItem(name: "nodeNm", value: query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
        ]
        
        print(queryItems)
        
        var components = URLComponents(string: baseURL)
        components?.queryItems = queryItems
        
        guard let url = components?.url else {
            completion(.failure(NSError(domain: "BusStopSearch", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        print(request)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let data = data, let responseString = String(data: data, encoding: .utf8) {
                    print("Response Data: \(responseString)")
                } else if let error = error {
                    print("Error: \(error.localizedDescription)")
                }
            }
        
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
//            do {
//                let response = try JSONDecoder().decode(BusStopData.self, from: data)
//                // 여기서 response.response.body.items.item에 접근하여 원하는 값들을 가져올 수 있습니다.
//                print("Response Data: \(response)")
//                completion(.success(response))
//            } catch {
//                completion(.failure(error))
//            }
        }.resume()
    }
}
