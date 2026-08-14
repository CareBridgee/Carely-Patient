//
//  VisitHistoryItem.swift
//  Carely
//
//  Created by Mina on 14/08/2026.
//

import Foundation
 
struct VisitHistoryItem: Identifiable, Equatable {
    let id: String
    let nurseName: String
    let nurseImageUrl: String?
    let serviceName: String
    let status: VisitStatus
    let dateText: String
    let timeText: String
 
    var dateTimeText: String {
        [dateText, timeText].filter { !$0.isEmpty }.joined(separator: ", ")
    }
}
 
