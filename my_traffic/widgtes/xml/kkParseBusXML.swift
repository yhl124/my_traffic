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
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        switch currentElement {
        case "mobileNo":
            mobileNo = string.trimmingCharacters(in: .whitespacesAndNewlines)
        case "stationName":
            // 만약 `stationName`이 숫자로 시작하는지 확인하고, 숫자로 시작하지 않는 경우에만 공백 및 개행 문자를 제거합니다.
            if let firstCharacter = string.first, !firstCharacter.isNumber {
                stationName = string.trimmingCharacters(in: .whitespacesAndNewlines)
            } else {
                stationName += string // 숫자로 시작하는 경우 공백 및 개행 문자를 제거하지 않고 그대로 더합니다.
            }
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
