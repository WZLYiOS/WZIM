//
//  WZSignalingElem.swift
//  WZIM
//
//  Created by qiuqixiang on 2020/10/12.
//

import Foundation

// MARK - 通话类型
public enum WZIMCallType: Int, WZIMDefaultEnumCodable {
    public static var defaultCase: WZIMCallType = .unknown
    
    case unknown = 0   // 未知
    case audio = 1 // 音频
    case video = 2   // 视频
}


// MARK - 信令消息
public class WZSignalingElem: Codable {
    
    public enum ActionType: Int, WZIMDefaultEnumCodable {
        public static var defaultCase: WZSignalingElem.ActionType = .none
        
        case none = 0   // 未知
        case invit = 1 // 邀请
        case cancel = 2   // 取消邀请
        case accept = 3   // 接受邀请
        case reject = 4   // 拒绝邀请
        case timeOut = 5  // 超时
    }
    
    /// 事件类型 请用下面的方法
    public var actionType: ActionType
        
    /// 自定义内容
    public var data: WZSignalingModel
    
    /// 邀请id
    public var inviteID: String
    
    /// 邀请列表
    public var inviteeList: [String]
    
    /// 邀请者
    public var inviter: String
    
    /// 过期时间
    public var timeout: Int
    
    public init(actionType: ActionType, data: WZSignalingModel, inviteID: String, inviteeList: [String], inviter: String, timeout: Int) {
        self.actionType = actionType
        self.data = data
        self.inviteID = inviteID
        self.inviter = inviter
        self.inviteeList = inviteeList
        self.timeout = timeout
    }
    
    enum CodingKeys: String, CodingKey {
        case actionType = "actionType"
        case data = "data"
        case inviteID = "inviteID"
        case inviteeList = "inviteeList"
        case inviter = "inviter"
        case timeout = "timeout"
    }
    
    public func getText(isSelf: Bool) -> String {
        switch actionType {
        case .accept:
            return "已接通"
        case .cancel:
            return isSelf ? "取消通话" : "对方已取消"
        case .invit:
            if timeout == 0 {
                return "聊天时长：\(WZSignalingElem.getFormatPlayTime(secounds: TimeInterval(data.callEnd)))"
            }
            return  isSelf ? "发起通话" : "向您发起了视频申请"
        case .reject:
            
            if data.lineBusy != nil {
                return isSelf ? "已拒绝" : "对方忙线"
            }
            return isSelf ? "已拒绝" : "对方已拒绝"
        case .timeOut:
            return "无应答"
        default:
            return "未知错误"
        }
    }
    
    /// 时间转成时分秒
    public static func getFormatPlayTime(secounds:TimeInterval)->String{
            if secounds.isNaN{
                return "00:00"
            }
            var Min = Int(secounds / 60)
            let Sec = Int(secounds.truncatingRemainder(dividingBy: 60))
            var Hour = 0
            if Min>=60 {
                Hour = Int(Min / 60)
                Min = Min - Hour*60
                return String(format: "%02d:%02d:%02d", Hour, Min, Sec)
            }
            return String(format: "%02d:%02d", Min, Sec)
        }
}

/// MARK - 邀请信息
public class WZSignalingModel: Codable {
    
    /// 版本号
    public var version: Int
    
    /// 通话类型
    public var calltype: WZIMCallType
    
    /// 房间id
    public var roomId: Int
        
    /// 通话时间
    public var callEnd: Int
    
    /// 忙线
    public var lineBusy: String?
    
    public init(version: Int = 4, calltype: WZIMCallType = .video, roomId: Int, callEnd: Int = 0, lineBusy: String? = nil) {
        self.version = version
        self.calltype = calltype
        self.roomId = roomId
        self.callEnd = callEnd
        self.lineBusy = lineBusy
    }
    
    enum CodingKeys: String, CodingKey {
        case version = "version"
        case calltype = "call_type"
        case roomId = "room_id"
        case callEnd = "call_end"
        case lineBusy = "line_busy"
    }
}

