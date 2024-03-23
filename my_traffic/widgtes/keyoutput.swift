//
//  keyoutput.swift
//  my_traffic
//
//  Created by yhl on 2024/03/24.
//

import Foundation

//class ApiClass {
//    let plistPath = Bundle.main.path(forResource: "keys", ofType: "plist")
//    
////    var apiKey: String? {
////            guard let path = plistPath,
////                  let xml = FileManager.default.contents(atPath: path),
////                  let plistData = try? PropertyListSerialization.propertyList(from: xml, format: nil) as? [String: Any],
////                  let key = plistData["BusStationSearch"] as? String else {
////                return nil
////            }
////            return key
////        }
//    
//    func getKey(keyname: String) -> String? {
//        
//        var apiKey: String? {
//            guard let path = plistPath,
//                  let xml = FileManager.default.contents(atPath: path),
//                  let plistData = try? PropertyListSerialization.propertyList(from: xml, format: nil) as? [String: Any],
//                  let key = plistData[keyname] as? String else {
//                return nil
//            }
//            return key
//        }
//        return apiKey
//    }
//}

struct KeyOutput {
    static func getAPIKey(for key: String) -> String {
        guard let filePath = Bundle.main.path(forResource: "keys", ofType: "plist") else {
            fatalError("Couldn't find file 'Keys.plist'.")
        }
        
        let plist = NSDictionary(contentsOfFile: filePath)
        guard let value = plist?.object(forKey: key) as? String else {
            fatalError("Couldn't find key '\(key)' in 'Keys.plist'.")
        }
        
        return value
    }
}
