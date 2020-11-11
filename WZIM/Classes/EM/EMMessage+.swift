//
//  EMMessage+.swift
//  Pods-WZIM_Example
//
//  Created by qiuqixiang on 2020/8/14.
//

import Foundation
import HyphenateLite

// MARK - 环信消息遵循协议
extension EMMessage: WZMessageProtocol {
    
    public var wzMessageId: String {
        return self.messageId
    }
    
    public var timeTamp: Date {
        return Date(timeIntervalSince1970: TimeInterval(timestamp/1000))
    }
    
    public var senderId: String {
        return from
    }
    
    public var receiverId: String {
        return to
    }
    
    public var loaction: WZMessageLocation {
        switch direction {
        case EMMessageDirectionSend:
            return .right
        default:
            return .lelft
        }
    }
    
    public var customInt: Int {
        get {
            return 0
        }
        set {
            
        }
    }
    
    public var customData: Data? {
        get {
            return nil
        }
        set {
            
        }
    }
    
    public var sendStatus: WZIMMessageStatus {
        return WZIMMessageStatus.init(rawValue: Int(status.rawValue)) ?? .sending
    }

    public var isReaded: Bool {
        return isRead
    }
    
    public var currentElem: WZMessageElem {
        return body.getElem()
    }
}

/// MARK - 数据类型
extension EMMessageBody{
    
    func getElem() -> WZMessageElem {
        switch type {
        case EMMessageBodyTypeText:
            return .text((self as! EMTextMessageBody))
        case EMMessageBodyTypeImage:
            return .img((self as! EMImageMessageBody))
        case EMMessageBodyTypeVideo:
            return .sound((self as! EMVoiceMessageBody))
        default:
            return .unknown
        }
    }
}

/// MARK - 文字消息
extension EMTextMessageBody: WZIMTextProtocol {
    public func getText() -> String {
        return self.text
    }
}

/// MARK - 图片消息
extension EMImageMessageBody:  WZIMImageElemProtocol {
    public var filePath: String {
        return thumbnailLocalPath
    }
    
    public var uuid: String {
        return thumbnailSecretKey
    }

    public var width: Int {
        return Int(size.width)
    }
    
    public var height: Int {
        return Int(size.height)
    }
    
    public var url: String {
        return thumbnailRemotePath
    }
}

/// MARK - 音频
extension EMVoiceMessageBody: WZIMVoiceProtocol {
    
    public func wzPath() -> String {
        return localPath
    }
    
    public func wzSecond() -> Int {
        return Int(duration)
    }
    
    public func wzGetSound(sucess: ((String) -> Void)?, fail: ((Error) -> Void)?) {
        switch self.downloadStatus {
        case EMDownloadStatusSucceed:
            sucess?(localPath)
        case EMDownloadStatusDownloading, EMDownloadStatusPending:
            fail?(NSError(domain: "正在下语音，请稍后点击", code: -2001, userInfo: nil))
        default:
            fail?(NSError(domain: "语音下载失败", code: -2002, userInfo: nil))
        }
    }
}
