//
//  fetchXMLData.swift
//  my_traffic
//
//  Created by yhl on 4/6/24.
//
import Foundation

class BusStopViewModel: ObservableObject {
    @Published var busStops: [BusStationInfo] = []
    
    func searchBusStops(keyword: String) {
        let apiKey = KeyOutput.getAPIKey(for: "BusStopSearch")
//        let keyword = searchQuery
//        let urlString = "https://apis.data.go.kr/6410000/busstationservice/getBusStationList?serviceKey=\(apiKey)&keyword=\(keyword)"
        
        guard let encodedKeyword = keyword.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            print("Failed to encode keyword")
            return
        }
        let urlString = "https://apis.data.go.kr/6410000/busstationservice/getBusStationList?serviceKey=\(apiKey)&keyword=\(encodedKeyword)"
        // keyword를 사용하여 URL 생성
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
