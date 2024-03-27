//
//  keyoutput.swift
//  my_traffic
//
//  Created by yhl on 2024/03/24.
//

import Foundation

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
