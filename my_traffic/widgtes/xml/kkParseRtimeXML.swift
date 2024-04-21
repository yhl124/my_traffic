//
//  kkParseRtimeXML.swift
//  my_traffic
//
//  Created by yhl on 4/21/24.
//

import Foundation
//여기 12라인부터 싹다 수정해야됨
class XMLParserDelegateKKRtime: NSObject, XMLParserDelegate {
    var busRealTimes: [BusRealTimeInfo] = []
    var currentElement: String = ""
    var routeId: String = ""
    var stationId: String = ""
    var locationNo1: String = ""
    var locationNo2: String = ""
    var predictTime1: String = ""
    var predictTime2: String = ""
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentElement = elementName
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        switch currentElement {
        case "routeId":
            routeId = string.trimmingCharacters(in: .whitespacesAndNewlines)
        case "stationId":
            stationId = string.trimmingCharacters(in: .whitespacesAndNewlines)
        case "locationNo1":
            locationNo1 = string.trimmingCharacters(in: .whitespacesAndNewlines)
        case "locationNo2":
            locationNo2 = string.trimmingCharacters(in: .whitespacesAndNewlines)
        case "predictTime1":
            predictTime1 = string.trimmingCharacters(in: .whitespacesAndNewlines)
        case "predictTime2":
            predictTime2 = string.trimmingCharacters(in: .whitespacesAndNewlines)
        default:
            break
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "busRealTimeList" {
            let busRealTime = BusRealTimeInfo(stationId: stationId, routeId: routeId, locationNo1: locationNo1, locationNo2: locationNo2, predictTime1: predictTime1, predictTime2: predictTime2)
            busRealTimes.append(busRealTime)
            stationId = ""
            routeId = ""
            locationNo1 = ""
            locationNo2 = ""
            predictTime1 = ""
            predictTime2 = ""
        }
    }
}
