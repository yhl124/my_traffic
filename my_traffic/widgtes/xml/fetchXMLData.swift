//
//  fetchXMLData.swift
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

class BusStopViewModel: ObservableObject {
    @Published var busStops: [BusStationInfo] = []
//    @Published var searchQuery: String = "" {
//        didSet {
//            searchBusStops() // searchQuery가 업데이트될 때마다 검색을 다시 수행
//        }
//    }
    
    func searchBusStops(keyword: String) {
        let apiKey = KeyOutput.getAPIKey(for: "BusStopSearch")
//        let keyword = searchQuery
        let urlString = "https://apis.data.go.kr/6410000/busstationservice/getBusStationList?serviceKey=\(apiKey)&keyword=\(keyword)"
        
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Error fetching data: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            DispatchQueue.main.async {
                self.busStops = self.parseXMLData(data: data) // XML 파싱 후 업데이트
            }
        }.resume()
    }
    
//    private func generateURL(keyword: String) -> URL {
//        // 여기에 API URL 생성 로직을 추가합니다.
//        // 예시로 URLComponents를 사용합니다.
//        let apiKey = KeyOutput.getAPIKey(for: "BusStopSearch")
//        let keyword = searchQuery
//        let baseURL = "https://apis.data.go.kr/6410000/busstationservice/getBusStationList?serviceKey=\(apiKey)&keyword=\(keyword)"
//        
//        return URL(string: baseURL)!
//    }
    
    private func parseXMLData(data: Data) -> [BusStationInfo] {
        var stations = [BusStationInfo]()
        
        let parser = XMLParser(data: data)
        let xmlDelegate = XMLParserDelegateHelper()
        parser.delegate = xmlDelegate
        
        if parser.parse() {
            stations = xmlDelegate.busStations
        }
        
        return stations
    }
}

//class ViewModel: ObservableObject {
//    @Published var busStations = [BusStationInfo]()
//    @Published var searchQuery: String = ""
//    
//    func fetchXMLData(from url: URL) {
//        let task = URLSession.shared.dataTask(with: url) { data, response, error in
//            guard let data = data, error == nil else {
//                print("Error fetching data: \(error?.localizedDescription ?? "Unknown error")")
//                return
//            }
//            
//            DispatchQueue.main.async {
//                self.busStations = self.parseXMLData(data: data)
//            }
//        }
//        task.resume()
//    }
//    
//    func parseXMLData(data: Data) -> [BusStationInfo] {
//        var stations = [BusStationInfo]()
//        
//        let parser = XMLParser(data: data)
//        let xmlDelegate = XMLParserDelegateHelper()
//        parser.delegate = xmlDelegate
//        
//        if parser.parse() {
//            stations = xmlDelegate.busStations
//        }
//        
//        return stations
//    }
//}


//func fetchXMLData(from url: URL) async throws -> Data {
//    let (data, response) = try await URLSession.shared.data(from: url)
//    
//    guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
//        throw URLError(.badServerResponse)
//    }
//    
//    return data
//}
