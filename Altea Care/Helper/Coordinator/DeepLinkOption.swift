//
//  DeepLinkOption.swift
//  Altea Care
//
//  Created by Hedy on 21/09/20.
//

import Foundation

struct DeepLinkURLConstants {
    static let appointmentPaymentSuccess = "PUSH_NOTIFICATION_APPOINTMENT_PAYMENT_SUCCESS"
    static let appointmentPaymentRefunded = "PUSH_NOTIFICATION_APPOINTMENT_REFUNDED"
    static let appointmentWaitingForPayment = "PUSH_NOTIFICATION_APPOINTMENT_WAITING_FOR_PAYMENT"
    static let appointmentCancelledByGP = "PUSH_NOTIFICATION_APPOINTMENT_CANCELED_BY_GP"
    static let appointmentCancelledBySystem = "PUSH_NOTIFICATION_APPOINTMENT_CANCELED_BY_SYSTEM"
    static let appointmentCompleted = "PUSH_NOTIFICATION_APPOINTMENT_COMPLETED"
    static let appointmentMeetSpecialist = "PUSH_NOTIFICATION_APPOINTMENT_MEET_SPECIALIST"
    static let appointment15BeforeMeet = "PUSH_NOTIFICATION_APPOINTMENT_15MINUTES_BEFORE_MEET_SPECIALIST"
    static let appointment15AfterOngoing = "PUSH_NOTIFICATION_APPOINTMENT_10MINUTES_AFTER_ON_GOING"
    static let appointment15ToEndMeet = "PUSH_NOTIFICATION_APPOINTMENT_WILL_ENDED_IN_10MINUTES"
    static let appointmentScheduleChanged = "PUSH_NOTIFICATION_APPOINTMENT_SCHEDULE_CHANGED"
    static let appointmentSpecialistChanged = "PUSH_NOTIFICATION_APPOINTMENT_SPECIALIST_CHANGED"
}

enum DeepLinkOption {
    case appointmentPaymentSuccess(id: Int)
    case appointmentPaymentRefunded(id: Int)
    case appointmentWaitingForPayment(id: Int)
    case appointmentCancelledByGP(id: Int)
    case appointmentCancelledBySystem(id: Int)
    case appointmentCompleted(id: Int)
    case appointmentMeetSpecialist(id:Int)
    case appointment15BeforeMeet(id:Int)
    case appointment15AfterOngoing(id:Int)
    case appointment15ToEndMeet(id:Int)
    case appointmentScheduleChanged(id:Int)
    case appointmentSpecialistChanged(id:Int)
    static func build(with dict: [String : AnyObject]?) -> DeepLinkOption? {
        guard let id = dict?["messageType"] as? String else { return nil }
        
        switch id {
        default: return nil
        }
    }
    
    static func build(with dict: [String : Any]?) -> DeepLinkOption? {
        guard let url = dict?["moe_deeplink"] as? String else { return nil }
        guard let urlComponent = URL(string:url)?.pathComponents else { return nil }
        let id = urlComponent.last
        let nav = urlComponent[1]
        
        switch nav {
        case DeepLinkURLConstants.appointmentPaymentSuccess:
            return .appointmentPaymentSuccess(id: Int(id ?? "0") ?? 0)
        case DeepLinkURLConstants.appointmentPaymentRefunded:
            return .appointmentPaymentRefunded(id: Int(id ?? "0") ?? 0)
        case DeepLinkURLConstants.appointmentWaitingForPayment:
            return .appointmentWaitingForPayment(id: Int(id ?? "0") ?? 0)
        case DeepLinkURLConstants.appointmentCancelledByGP:
            return .appointmentCancelledByGP(id: Int(id ?? "0") ?? 0)
        case DeepLinkURLConstants.appointmentCancelledBySystem:
            return .appointmentCancelledBySystem(id: Int(id ?? "0") ?? 0)
        case DeepLinkURLConstants.appointmentCompleted:
            return .appointmentCompleted(id: Int(id ?? "0") ?? 0)
        case DeepLinkURLConstants.appointmentMeetSpecialist:
            return .appointmentMeetSpecialist(id: Int(id ?? "0") ?? 0)
        case DeepLinkURLConstants.appointment15BeforeMeet:
            return .appointment15BeforeMeet(id: Int(id ?? "0") ?? 0)
        case DeepLinkURLConstants.appointment15AfterOngoing:
            return .appointment15AfterOngoing(id: Int(id ?? "0") ?? 0)
        case DeepLinkURLConstants.appointment15ToEndMeet:
            return .appointment15ToEndMeet(id: Int(id ?? "0") ?? 0)
        case DeepLinkURLConstants.appointmentScheduleChanged:
            return .appointmentScheduleChanged(id: Int(id ?? "0") ?? 0)
        case DeepLinkURLConstants.appointmentSpecialistChanged:
            return .appointmentSpecialistChanged(id: Int(id ?? "0") ?? 0)
        default: return nil
        }
    }
}
