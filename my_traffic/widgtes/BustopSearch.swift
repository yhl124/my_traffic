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
//struct BusStopData: Codable {
//    let stops: [BusStop]
//    
//    struct BusStop: Codable, Identifiable {
//        let id = UUID() // 임의의 고유 식별자 생성
//        let name: String
//        let location: Location
//        
//        struct Location: Codable {
//            let latitude: Double
//            let longitude: Double
//        }
//        
//        init(name: String, location: Location) {
//            self.name = name
//            self.location = location
//        }
//    }
//}

struct BusStopData: Codable {
    let response: Response

    struct Response: Codable {
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
                let item: [BusStop]
            }
        }
    }

    struct BusStop: Codable, Identifiable {
        var id = UUID()
        let gpslati: Double
        let gpslong: Double
        let nodeid: String
        let nodenm: String
        let nodeno: Int


        var name: String {
            return nodenm
        }
    }

    var stops: [BusStop] {
        return response.body.items.item
    }
}

struct BusStopSearch {
    func fetchBusStopData(query: String, completion: @escaping (Result<BusStopData, Error>) -> Void) {
        let apiKey = KeyOutput.getAPIKey(for: "BusStopSearch")
        let decodedApiKey = apiKey.removingPercentEncoding ?? apiKey
        let baseURL = "https://apis.data.go.kr/1613000/BusSttnInfoInqireService/getSttnNoList?"
        let queryItems = [
            URLQueryItem(name: "serviceKey", value: decodedApiKey),
            URLQueryItem(name: "pageNo", value: "1"),
            URLQueryItem(name: "numOfRows", value: "10"),
            URLQueryItem(name: "_type", value: "json"),
            URLQueryItem(name: "cityCode", value: "31160"),
            URLQueryItem(name: "nodeNm", value: "금정"),
            //URLQueryItem(name: "nodeNm", value: query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
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
        
//        print(request)
//        URLSession.shared.dataTask(with: request) { data, response, error in
//            DispatchQueue.main.async {
//                if let data = data {
//                    do {
//                        let busStopData = try JSONDecoder().decode(BusStopData.self, from: data)
//                        completion(.success(busStopData))
//                        print(busStopData)
//                    } catch {
//                        completion(.failure(error))
//                    }
//                } else if let error = error {
//                    completion(.failure(error))
//                }
//            }
//        URLSession.shared.dataTask(with: request) { data, response, error in
//            if let error = error {
//                completion(.failure(error))
//                return
//            }
//
//            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
//                let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 0
//                completion(.failure(NSError(domain: "BusStopSearch", code: statusCode, userInfo: [NSLocalizedDescriptionKey: "Server responded with an error"])))
//                return
//            }
//
//            guard let data = data else {
//                completion(.failure(NSError(domain: "BusStopSearch", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data received from the server"])))
//                return
//            }
//
//            do {
//                let busStopData = try JSONDecoder().decode(BusStopData.self, from: data)
//                completion(.success(busStopData))
//            } catch {
//                completion(.failure(error))
//            }
        }.resume()
    }
}
