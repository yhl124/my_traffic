//
//  kkFetchRtimeXML.swift
//  my_traffic
//
//  Created by yhl on 4/21/24.
//

import Foundation

//class BusRealTimeViewModel: ObservableObject {
//    @Published var busRealTimeInfos: [BusRealTimeInfo] = []
//    @Published var isLoading = false // 로딩 상태 추가
//    
//    func searchBusRealTimes(stationId: String) {
//        isLoading = true // 로딩 시작
//        
//        let apiKey = KeyOutput.getAPIKey(for: "BusStopSearch")
//        
//        guard let encodedStationId = stationId.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
//            print("Failed to encode keyword")
//            return
//        }
//        let urlString = "https://apis.data.go.kr/6410000/busarrivalservice/getBusArrivalList?serviceKey=\(apiKey)&stationId=\(encodedStationId)"
//        // keyword를 사용하여 URL 생성
//        guard let url = URL(string: urlString) else {
//            print("Invalid URL")
//            return
//        }
//        //print(url)
//        
//        URLSession.shared.dataTask(with: url) { data, response, error in
//            guard let data = data, error == nil else {
//                print("Error fetching data: \(error?.localizedDescription ?? "Unknown error")")
//                DispatchQueue.main.async {
//                    self.isLoading = false // 로딩 완료
//                }
//                return
//            }
//            
//            DispatchQueue.main.async {
//                print(String(data: data, encoding: .utf8) ?? "Data could not be converted to text")
//                self.busRealTimeInfos = self.parseXMLRealTimeData(data: data) // XML 파싱 후 업데이트
//                self.isLoading = false // 로딩 완료
////                print("수신한 XML 데이터:", self.busRealTimeInfos)
//            }
//        }.resume()
//    }
//    
//    private func parseXMLRealTimeData(data: Data) -> [BusRealTimeInfo] {
//        var realtimes = [BusRealTimeInfo]()
//        
//        let parser = XMLParser(data: data)
//        let xmlDelegate = XMLParserDelegateKKRtime()
//        parser.delegate = xmlDelegate
//        
//        if parser.parse() {
//            realtimes = xmlDelegate.busRealTimes
//        }
//        //print(realtimes)
//        return realtimes
//    }
//}

import Combine

class BusRealTimeViewModel: ObservableObject {
    @Published var busRealTimeInfos: [BusRealTimeInfo] = []
    @Published var isLoading = false

    func searchBusRealTimes(stationId: String, completion: @escaping ([BusRealTimeInfo]) -> Void) {
        isLoading = true

        let apiKey = KeyOutput.getAPIKey(for: "BusStopSearch")
        
//        if let documentsDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last {
//            print("Documents Directory: \(documentsDirectoryURL)")
//        }

        guard let encodedStationId = stationId.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            print("Failed to encode stationId")
            isLoading = false
            return
        }

        let urlString = "https://apis.data.go.kr/6410000/busarrivalservice/getBusArrivalList?serviceKey=\(apiKey)&stationId=\(encodedStationId)"
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            isLoading = false
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Error fetching data: \(error?.localizedDescription ?? "Unknown error")")
                DispatchQueue.main.async {
                    self.isLoading = false
                }
                return
            }

            DispatchQueue.main.async {
                print(String(data: data, encoding: .utf8) ?? "Data could not be converted to text")
                let realTimeInfos = self.parseXMLRealTimeData(data: data)
                self.isLoading = false
                completion(realTimeInfos)
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
        //print(realtimes)
        return realtimes
    }
}
