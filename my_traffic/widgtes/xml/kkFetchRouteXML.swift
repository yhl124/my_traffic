//
//  kkFetchRouteXMLData.swift
//  my_traffic
//
//  Created by yhl on 4/8/24.
//

import Foundation

class BusRouteViewModel: ObservableObject {
    @Published var busRoutes: [BusRouteInfo] = []
    
    func searchBusRoutes(stationId: String) {
        let apiKey = KeyOutput.getAPIKey(for: "BusStopSearch")

        guard let encodedStationId = stationId.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            print("Failed to encode keyword")
            return
        }
        let urlString = "https://apis.data.go.kr/6410000/busstationservice/getBusStationViaRouteList?serviceKey=\(apiKey)&stationId=\(encodedStationId)"
        // keyword를 사용하여 URL 생성
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        //print(url)
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Error fetching data: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            DispatchQueue.main.async {
                self.busRoutes = self.parseXMLKKRoute(data: data) // XML 파싱 후 업데이트
            }
        }.resume()
    }
    
    private func parseXMLKKRoute(data: Data) -> [BusRouteInfo] {
        var routes = [BusRouteInfo]()
        
        let parser = XMLParser(data: data)
        let xmlDelegate = XMLParserDelegateKKRoute()
        parser.delegate = xmlDelegate
        
        if parser.parse() {
            routes = xmlDelegate.busRoutes
        }
        
        return routes
    }
}
