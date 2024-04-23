//
//  kkParseRtimeXML.swift
//  my_traffic
//
//  Created by yhl on 4/21/24.
//

import Foundation

class XMLParserDelegateKKRtime: NSObject, XMLParserDelegate {
    var busRealTimes = [BusRealTimeInfo]()
    
    private var currentElement: String?
    private var currentRealTimeInfo: BusRealTimeInfo?
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentElement = elementName
        
        if elementName == "busArrivalList" {
            currentRealTimeInfo = BusRealTimeInfo(stationId: "", routeId: "", locationNo1: "", locationNo2: "", predictTime1: "", predictTime2: "")
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        switch currentElement {
        case "routeId":
            currentRealTimeInfo?.routeId += string
        case "stationId":
            currentRealTimeInfo?.stationId += string
        case "locationNo1":
            currentRealTimeInfo?.locationNo1 += string
        case "locationNo2":
            currentRealTimeInfo?.locationNo2 += string
        case "predictTime1":
            currentRealTimeInfo?.predictTime1 += string
        case "predictTime2":
            currentRealTimeInfo?.predictTime2 += string
        default:
            break
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "busArrivalList" {
            if let realTimeInfo = currentRealTimeInfo {
                busRealTimes.append(realTimeInfo)
                currentRealTimeInfo = nil
            }
        }
        currentElement = nil
    }
}

//class XMLParserDelegateKKRtime: NSObject, XMLParserDelegate {
//    var busRealTimes: [BusRealTimeInfo] = []
//    var currentElement: String = ""
//    var routeId: String = ""
//    var stationId: String = ""
//    var locationNo1: String = ""
//    var locationNo2: String = ""
//    var predictTime1: String = ""
//    var predictTime2: String = ""
//    
//    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
//        currentElement = elementName
//    }
//    
//    func parser(_ parser: XMLParser, foundCharacters string: String) {
//        switch currentElement {
//        case "routeId":
//            routeId = string.trimmingCharacters(in: .whitespacesAndNewlines)
//        case "stationId":
//            stationId = string.trimmingCharacters(in: .whitespacesAndNewlines)
//        case "locationNo1":
//            locationNo1 = string.trimmingCharacters(in: .whitespacesAndNewlines)
//        case "locationNo2":
//            locationNo2 = string.trimmingCharacters(in: .whitespacesAndNewlines)
//        case "predictTime1":
//            predictTime1 = string.trimmingCharacters(in: .whitespacesAndNewlines)
//        case "predictTime2":
//            predictTime2 = string.trimmingCharacters(in: .whitespacesAndNewlines)
//        default:
//            break
//        }
//    }
//    
//    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
//        if elementName == "busRealTimeList" {
//            let busRealTime = BusRealTimeInfo(stationId: stationId, routeId: routeId, locationNo1: locationNo1, locationNo2: locationNo2, predictTime1: predictTime1, predictTime2: predictTime2)
//            busRealTimes.append(busRealTime)
//            stationId = ""
//            routeId = ""
//            locationNo1 = ""
//            locationNo2 = ""
//            predictTime1 = ""
//            predictTime2 = ""
//        }
//    }
//}
