//
//  VisitDetail.swift
//  Carely
//
//  Created by Mina on 14/08/2026.
//

import Foundation
 
struct VisitDetail: Identifiable, Equatable {
    let id: String
    let serviceName: String
    let status: VisitStatus
    let dateText: String
    let timeText: String
    let nurseName: String
    let nurseImageUrl: String?
    let nurseTitle: String
    let description: String?
}
 
