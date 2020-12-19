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
    
    public var wzMessageId: String {
        return msgID ?? ""
    }
    
    public var timeTamp: Date {
        return timestamp 
    }
    
    public var senderId: String {
        return sender.imDelPrefix
    }
    
    public var receiverId: String {
        if userID.count > 0 {
            return userID.imDelPrefix
        }
        return groupID.imDelPrefix
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
    
    /// 消息打印
    public func printMsg(){
        
        if let tex = textElem {
            debugPrint("普通消息："+tex.text)
        }
        
        if let elem = customElem {
            debugPrint("自定义消息：\(String(describing: try? JSONSerialization.jsonObject(with: elem.data, options: .mutableContainers)))")
        }
    }
}

/// MARK - WZMessageReceiptProtocol
extension V2TIMMessageReceipt: WZMessageReceiptProtocol {
    
    public var userId: String {
        return userID.imDelPrefix
    }
    
    public var time: Int {
        return Int(timestamp)
    }
}


