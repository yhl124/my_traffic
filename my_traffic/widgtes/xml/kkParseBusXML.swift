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
    var busStations = [BusStationInfo]()
    var currentElement = ""
    var mobileNo = ""
    var stationName = ""
    var stationId = ""

    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentElement = elementName
        
        if elementName == "busStationList" {
            // 새로운 busStationList 요소가 시작될 때 임시 문자열을 초기화합니다.
            mobileNo = ""
            stationName = ""
            stationId = ""
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        let trimmedString = string.trimmingCharacters(in: .whitespacesAndNewlines)
        switch currentElement {
        case "mobileNo":
            mobileNo += trimmedString // 문자열 추가
        case "stationName":
            stationName += trimmedString // 문자열 추가
        case "stationId":
            stationId += trimmedString // 문자열 추가
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
