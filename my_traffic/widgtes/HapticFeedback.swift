//
//  HapticFeedback.swift
//  my_traffic
//
//  Created by yhl on 5/30/24.
//

import Foundation
import UIKit

class HapticFeedback {
    static let shared = HapticFeedback()
    
    private let generator = UINotificationFeedbackGenerator()
    
    private init() {}
    
    func triggerSuccess() {
        generator.notificationOccurred(.success)
    }
}
