//
//  NotificationModel.swift
//  SunsetApp
//
//  Created by Angelique Babin on 01/10/2020.
//

import Foundation
import RealmSwift

struct NotificationModel: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let message: String
    let plannedFor: Date
}
