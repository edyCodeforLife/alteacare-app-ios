//
//  ScheduleProvider.swift
//  Altea Care
//
//  Created by Hedy on 21/09/20.
//

import Foundation
import RxSwift

class ScheduleProvider {
    
    static let shared: ScheduleProvider = ScheduleProvider()
    
    public let main = MainScheduler.instance
    public let background = ConcurrentDispatchQueueScheduler(qos: DispatchQoS.background)
}
