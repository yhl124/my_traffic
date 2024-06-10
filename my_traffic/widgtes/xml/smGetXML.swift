import SwiftUI
import Combine

// 역 정보 구조체
struct Station: Identifiable {
    let id = UUID()
    var stationCode: String = ""
    var stationName: String = ""
    var lineNumber: String = ""
    var frCode: String = ""
}

// 네트워크 매니저
class NetworkManager: NSObject, ObservableObject, XMLParserDelegate {
    @Published var stations: [Station] = []
    
    private var currentElement: String = ""
    private var currentStation: Station?
    
    func fetchData(keyword: String) {
        let apiKey = KeyOutput.getAPIKey(for: "smStationSearch")
        print("API Key: \(apiKey)")  // API 키 출력
        
        let urlString = "http://openAPI.seoul.go.kr:8088/\(apiKey)/xml/SearchInfoBySubwayNameService/1/5/\(keyword)/"
        
        print("\nURL String: \(urlString)")  // URL 문자열 출력
        
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                let parser = XMLParser(data: data)
                parser.delegate = self
                parser.parse()
            } else if let error = error {
                print("Error fetching data: \(error)")
            }
        }.resume()
    }
    
    // XMLParserDelegate 메서드
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentElement = elementName
        if elementName == "row" {
            currentStation = Station()
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        guard var currentStation = currentStation else { return }
        switch currentElement {
        case "STATION_CD":
            currentStation.stationCode += string.trimmingCharacters(in: .whitespacesAndNewlines)
        case "STATION_NM":
            currentStation.stationName += string.trimmingCharacters(in: .whitespacesAndNewlines)
        case "LINE_NUM":
            currentStation.lineNumber += string.trimmingCharacters(in: .whitespacesAndNewlines)
        case "FR_CODE":
            currentStation.frCode += string.trimmingCharacters(in: .whitespacesAndNewlines)
        default:
            break
        }
        self.currentStation = currentStation
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "row" {
            if let currentStation = currentStation {
                DispatchQueue.main.async {
                    self.stations.append(currentStation)
                }
                self.currentStation = nil
            }
        }
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        DispatchQueue.main.async {
            for station in self.stations {
                print("Station Code: \(station.stationCode), Station Name: \(station.stationName), Line Number: \(station.lineNumber), FR Code: \(station.frCode)")
            }
        }
    }
}
