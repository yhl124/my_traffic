//
//  kkParseRouteXml.swift
//  my_traffic
//
//  Created by yhl on 4/8/24.
//

import Foundation

class XMLParserDelegateKKRoute: NSObject, XMLParserDelegate {
    var busRoutes: [BusRouteInfo] = []
    var currentElement: String = ""
    var routeId: String = ""
    var routeName: String = ""
    var routeTypeCd: String = ""
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentElement = elementName
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        switch currentElement {
        case "routeId":
            routeId = string.trimmingCharacters(in: .whitespacesAndNewlines)
        case "routeName":
            routeName = string.trimmingCharacters(in: .whitespacesAndNewlines)
        case "routeTypeCd":
            routeTypeCd = string.trimmingCharacters(in: .whitespacesAndNewlines)
        default:
            break
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "busRouteList" {
            let busRoute = BusRouteInfo(routeId: routeId, routeName: routeName, routeTypeCd: routeTypeCd)
            busRoutes.append(busRoute)
            routeId = ""
            routeName = ""
            routeTypeCd = ""
        }
    }
}
