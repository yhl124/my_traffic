//
//  kkparseXMLData.swift
//  my_traffic
//
//  Created by yhl on 4/6/24.
//
//
import SwiftUI
import Foundation

class XMLParserDelegateHelper: NSObject, XMLParserDelegate {
    var currentElement = ""
    var mobileNo = ""
    var stationName = ""
    var stationId = ""
    var busStations = [BusStationInfo]()
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentElement = elementName
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        switch currentElement {
        case "mobileNo":
            mobileNo = string.trimmingCharacters(in: .whitespacesAndNewlines)
        case "stationName":
            stationName = string.trimmingCharacters(in: .whitespacesAndNewlines)
        case "stationId":
            stationId = string.trimmingCharacters(in: .whitespacesAndNewlines)
        default:
            break
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "busStationList" {
            let busStation = BusStationInfo(mobileNo: mobileNo, stationName: stationName, stationId: stationId)
            busStations.append(busStation)
        }
    }
}
