//
//  V2TIMMessage+.swift
//  WZIM
//
//  Created by qiuqixiang on 2020/9/19.
//

import ImSDK
import Foundation

// MARK - 消息
extension V2TIMMessage: WZMessageProtocol {
    
    public var messageId: String {
        return msgID ?? ""
    }
    
    public var timeTamp: Date {
        return timestamp as Date
    }
    
    public var senderId: String {
        return sender
    }
    
    public var receiverId: String {
        if userID.count > 0 {
            return userID
        }
        return groupID
    }
    
    public var loaction: WZMessageLocation {
        if isSelf {
            return .right
        }
        return .lelft
    }
    
    public var customInt: Int {
        get {
            return Int(localCustomInt)
        }
        set {
            localCustomInt = Int32(newValue)
        }
    }
    
    public var customData: Data? {
        get {
            return localCustomData
        }
        set {
            localCustomData = newValue
        }
    }
    
    public var sendStatus: WZIMMessageStatus {
        return WZIMMessageStatus.init(rawValue: status.rawValue) ?? .fail
    }
    
    public var isReaded: Bool {
        return isPeerRead
    }
    
    public var currentElem: WZMessageElem {
        
        switch elemType {
        case .ELEM_TYPE_TEXT:
            return textElem.getElem()
        case .ELEM_TYPE_CUSTOM:
            return customElem.getElem()
        case .ELEM_TYPE_IMAGE:
            return imageElem.getElem()
        case .ELEM_TYPE_SOUND:
            return soundElem.getElem()
        case .ELEM_TYPE_VIDEO:
            return videoElem.getElem()
        case .ELEM_TYPE_FILE:
            return fileElem.getElem()
        case .ELEM_TYPE_LOCATION:
            return locationElem.getElem()
        case .ELEM_TYPE_FACE:
            return faceElem.getElem()
        case .ELEM_TYPE_GROUP_TIPS:
            return groupTipsElem.getElem()
        default:
            return .unknown
        }
    }
}
