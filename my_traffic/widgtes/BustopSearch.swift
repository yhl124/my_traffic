//
//  BustopSearch.swift
//  my_traffic
//
//  Created by yhl on 2024/03/24.
//

import Foundation

//
//struct BusStop: Codable {
//    let id: Int
//    let name: String
//    // Add other properties as needed
//}
//
//func fetchBusStops(for searchText: String, completion: @escaping ([BusStop]?) -> Void) {
//    guard let url = URL(string: "YOUR_API_URL_HERE") else {
//        completion(nil)
//        return
//    }
//    
//    // Customize URLRequest as needed (e.g., adding headers, HTTP method)
//    var request = URLRequest(url: url)
//    request.httpMethod = "GET"
//    
//    URLSession.shared.dataTask(with: request) { data, response, error in
//        guard let data = data, error == nil else {
//            completion(nil)
//            return
//        }
//        
//        do {
//            let busStops = try JSONDecoder().decode([BusStop].self, from: data)
//            completion(busStops)
//        } catch {
//            print("Error decoding JSON: \(error)")
//            completion(nil)
//        }
//    }.resume()
//}
struct BusStopData: Codable {
    let stops: [BusStop]
    
    struct BusStop: Codable, Identifiable {
        let id = UUID() // 임의의 고유 식별자 생성
        let name: String
        let location: Location
        
        struct Location: Codable {
            let latitude: Double
            let longitude: Double
        }
        
        init(name: String, location: Location) {
            self.name = name
            self.location = location
        }
    }
}

struct BusStopSearch {
    func fetchBusStopData(query: String, completion: @escaping (Result<BusStopData, Error>) -> Void) {
        let apiKey = KeyOutput.getAPIKey(for: "BusStopSearch")
        let baseURL = "https://apis.data.go.kr/1613000/BusSttnInfoInqireService/getSttnNoList?"
        let queryItems = [
            URLQueryItem(name: "serviceKey", value: apiKey),
            URLQueryItem(name: "pageNo", value: "1"),
            URLQueryItem(name: "numOfRows", value: "10"),
            URLQueryItem(name: "_type", value: "json"),
            URLQueryItem(name: "cityCode", value: "31160"),
            URLQueryItem(name: "nodeNm", value: query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
        ]
        
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
        }.resume()
    }
}
