//
//  kkFetchRtimeXML.swift
//  my_traffic
//
//  Created by yhl on 4/21/24.
//

import Foundation

class BusRealTimeViewModel: ObservableObject {
    @Published var busRealTimeInfos: [BusRealTimeInfo] = []
    
    func searchBusRealTimes(keyword: String) {
        let apiKey = KeyOutput.getAPIKey(for: "BusStopSearch")
        
        guard let encodedStationId = keyword.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            print("Failed to encode keyword")
            return
        }
        let urlString = "https://apis.data.go.kr/6410000/busarrivalservice/getBusArrivalList?serviceKey=\(apiKey)&stationId=\(encodedStationId)"
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
                self.busRealTimeInfos = self.parseXMLRealTimeData(data: data) // XML 파싱 후 업데이트
            }
        }.resume()
    }
    
    private func parseXMLRealTimeData(data: Data) -> [BusRealTimeInfo] {
        var realtimes = [BusRealTimeInfo]()
        
        let parser = XMLParser(data: data)
        let xmlDelegate = XMLParserDelegateKKRtime()
        parser.delegate = xmlDelegate
        
        if parser.parse() {
            realtimes = xmlDelegate.busRealTimes
        }
        
        return realtimes
    }
}
