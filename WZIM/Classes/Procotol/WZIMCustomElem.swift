//
//  WZIMCustomElem.swift
//  WZLY
//
//  Created by qiuqixiang on 2020/8/23.
//  Copyright © 2020 我主良缘. All rights reserved.
//

import Foundation
import CleanJSON

// MARK - 消息类型
public enum WZMessageElem: Decodable {
    case unknown                           // 未知
    case text(WZIMTextProtocol)            // 文字消息
    case sound(WZIMVoiceProtocol)          // 音频
    case face(WZIMFaceCustomMarkModel)     // 表情
    case img(WZIMImageElemProtocol)        // 图片消息
    case nameAuthInvite(WZIMnameAuthInviteCustomElem) // 邀请认证
    case time(WZIMTimeCustomElem)       // 时间
    case share(WZIMShareCustomElem)     // 分享消息
    case sms(WZIMRemindContentElem)     // 短信消息
    case notice(WZTNoticeElem)                 // 透传消息
    case hibox(WZIMHiboxElem)           // 打招呼消息
    case videoTalkInvite(WZVideoTalkInviteElem) // 视频谈单邀请
    case dateAuthInvite(WZMessageDateAuthInviteElem)   // 约会实名认证邀请
    case dateService(WZMessageDateAuthInviteElem)         // 线上视频约会服务
    case nameAuthPop(WZMessageNmeAuthPopElem) // 牵线首次登陆实名认证弹窗
    case dateServiceHnSetRecCon(WZMessageServiceHnSetRecConElem) // 红娘设置推荐条件)
    
    
    public init(from decoder: Decoder) throws {
        throw CordinateError.missingValue
    }
    
    enum CordinateError: Error {
        case missingValue
    }
}

// MARK - 自定义消息
public enum WZMessageCustomType: String, WZIMDefaultEnumCodable {
    
    public static var defaultCase: WZMessageCustomType = .none
    case none  // 未知消息
    /// 本地自定义消息
    case sms = "sms"   // 发送短信
    case safe = "safe" // 安全提醒
    case time = "time" // 时间

    /// 消息
    case notice = "notice" // 透传
    case userInfo = "userInfo" // 用户信息
    case share = "share" // 分享消息
    case hibox = "hibox" // 打招呼消息
    case inviteAuth = "inviteAuth" // 邀请认证
    case chatCard = "chatCard" // 卡片
    case dateService = "dateService" // 线上视频约会服务
    case dateAuthInvite = "dateAuthInvite" // 约会实名认证邀请
    case videoTalkInvite = "videoTalkInvite"  // 视频谈单邀请
    case nameAuthPop = "dateApplyAuthPopup" // 牵线首次登陆实名认证弹窗
    case dateServiceHnSetRecCon = "dateServiceHnSetRecCon" // 红娘设置推荐条件)
}

// MARK - 我主自定义消息
public class WZIMCustomElem: Decodable {
    
    /// 消息类型
    public var type: WZMessageCustomType
    
    /// 消息elem
    public var msgElem: WZMessageElem
    
    enum CodingKeys: String, CodingKey {
        case type = "type"
        case msg = "msg"
    }
    
    required public init(from decoder: Decoder) throws {
        let vals = try decoder.container(keyedBy: WZIMCustomElem.CodingKeys.self)
        type = try vals.decode(WZMessageCustomType.self, forKey: CodingKeys.type)

        switch type {
        case .inviteAuth:
            msgElem = .nameAuthInvite(try vals.decode(WZIMnameAuthInviteCustomElem.self, forKey: CodingKeys.msg))
        case .time:
            msgElem = .time(try vals.decode(WZIMTimeCustomElem.self, forKey: CodingKeys.msg))
        case .notice:
            msgElem = .notice(try vals.decode(WZTNoticeElem.self, forKey: CodingKeys.msg))
        case .sms:
            msgElem = .sms(try vals.decode(WZIMRemindContentElem.self, forKey: CodingKeys.msg))
        case .hibox:
            msgElem = .hibox(try vals.decode(WZIMHiboxElem.self, forKey: CodingKeys.msg))
        case .videoTalkInvite:
            msgElem = .videoTalkInvite(try vals.decode(WZVideoTalkInviteElem.self, forKey: CodingKeys.msg))
        case .dateAuthInvite:
            msgElem = .dateAuthInvite(try vals.decode(WZMessageDateAuthInviteElem.self, forKey: CodingKeys.msg))
        case .dateService:
            msgElem = .dateService(try vals.decode(WZMessageDateAuthInviteElem.self, forKey: CodingKeys.msg))
        case .nameAuthPop:
            msgElem = .nameAuthPop(try vals.decode(WZMessageNmeAuthPopElem.self, forKey: CodingKeys.msg))
        case .dateServiceHnSetRecCon:
            msgElem = .dateServiceHnSetRecCon(try vals.decode(WZMessageServiceHnSetRecConElem.self, forKey: CodingKeys.msg))
        default:
            msgElem = .unknown
        }
    }
    
    /// 获取该模型Data
    public static func getData(type: WZMessageCustomType, msgData: Data) -> Data? {
        
        let dic = ["type": type.rawValue, "msg": String(data: msgData, encoding: .utf8) ?? ""]
        let data = try? JSONSerialization.data(withJSONObject: dic, options: [])
        return data
    }
}

// MARK - 文字内容协议
public protocol  WZIMTextProtocol {
    
    /// 文字消息
    func getText() -> String
}

// MARK - 音频
public protocol WZIMVoiceProtocol{
    
    /// 播放路径
    func wzPath() -> String
    
    /// 音频长度
    func wzSecond() -> Int
    
    /// 下载音频
    func wzGetSound(sucess: ((_ path: String) -> Void)?, fail: ((_ error: Error) -> Void)?)
}

// MARK - 表情消息
public class WZIMFaceCustomMarkModel: Codable {
    
    public enum FaceType: Int, WZIMDefaultEnumCodable {
        public static var defaultCase: WZIMFaceCustomMarkModel.FaceType = .nomar
        case nomar = 1 // 正常消息
        case face = 2  // 表情
        case gif = 3   // gif
    }
    
    /// 1: 正常消息 2：emoj 3：gif
    public var messageType: FaceType
    
    /// 表情数据
    public var expressionData: WZIMFaceCustomModel
    
    /// 表情名字
    public var name: String
    
    enum CodingKeys: String, CodingKey {
        case messageType = "messageType"
        case expressionData = "expression_data"
        case name = "msg_name"
    }
    
    init() {
        self.messageType = .nomar
        self.expressionData = WZIMFaceCustomModel()
        self.name = ""
    }
}

// MARK - 表情数据
public class WZIMFaceCustomModel: Codable {
    
    /// id
   public var gifId: String
    
    /// 图片宽
    public var with: Int
    
    /// 图片高
    public var height: Int
    
    /// 是否动图
    public var isAnimated: String
    
    /// igif图片地址
    public var image: String
    
    /// emoji 类型
    public var code: String
    
    enum CodingKeys: String, CodingKey {
        case gifId = "gifId"
        case with = "with"
        case height = "height"
        case isAnimated = "is_animated"
        case image = "image"
        case code = "code"
    }
    
    public init() {
        self.gifId = ""
        self.with = 0
        self.height = 0
        self.isAnimated = ""
        self.image = ""
        self.code = ""
    }
}

// MARK - 视频谈单邀请
public class WZVideoTalkInviteElem: Codable {
    
    /// 用户名
    public let userName: String
    
    /// 头像
    public let avatar: String
    
    /// 房间id
    public let roomid: String
    
    /// 我主良缘情感顾问
    public let label: String
    
    /// 我可以为你在线推荐对象吗
    public let text: String
    
    enum CodingKeys: String, CodingKey {
        case userName = "username"
        case avatar = "avatar"
        case roomid = "roomid"
        case label = "label"
        case text = "text"
    }
}

// MARK - 邀请认证
public class WZIMnameAuthInviteCustomElem: Codable {
    
    /// 内容
    public let content: String
    
    /// 跳转id
    public let jumpid: String
    
    enum CodingKeys: String, CodingKey {
        case content = "content"
        case jumpid = "jumpid"
    }
}

// MARK - 时间
public class WZIMTimeCustomElem: Codable {
    
    /// 时间戳
    public var time: String
    
    enum CodingKeys: String, CodingKey {
        case time = "time"
    }
    
    public init(time: String) {
        self.time = time
    }
}

// MARK - 分享自定义消息类型
public class WZIMShareCustomElem: Codable {
    
    public enum ShareType: Int, WZIMDefaultEnumCodable {
        public static var defaultCase: WZIMShareCustomElem.ShareType = .nomar
        case nomar  // 未知
        case h5 = 1  // h5活动
        case activity = 2 // 线下活动
        case article = 3 // 社区文章
    }
    
    /// 类型
    public var type: ShareType
    
    /// 内容
    public var content: WZIMShareContentModel
    
    enum CodingKeys: String, CodingKey {
        case type = "type"
        case content = "content"
    }
    
    public init(type: ShareType, content: WZIMShareContentModel) {
        self.type = type
        self.content = content
    }
}

// MARK - 分享消息内容
public class WZIMShareContentModel: Codable {
    
    /// 活动标题
    public var title: String
    
    /// 分享缩略图
    public var img: String
    
    /// 分享语
    public var desc: String
    
    /// 自定义分享H5消息
    public var url: String
    
    /// 交友活动id
    public var partyId: String
    
    /// 城市
    public var city: String
    
    /// 活动开始时间
    public var beginTime: String
    
    /// 社区文章
    public var articleId: String
    
    enum CodingKeys: String, CodingKey {
        case title = "title"
        case img = "img"
        case desc = "desc"
        case url = "url"
        case partyId = "partyid"
        case city = "city"
        case beginTime = "begin_time"
        case articleId = "article_id"
    }
    
    public init(){
        self.title = ""
        self.img = ""
        self.desc = ""
        self.url = ""
        self.partyId = ""
        self.city = ""
        self.beginTime = ""
        self.articleId = ""
    }
}

/// MARK - 提示类型消息
public class WZIMRemindContentElem: Codable {
    
    /// 提示语
    public var remindMsg: String
    
    /// 跳转类型 0 不跳转 1红娘牵线 2 开通会员
    public var jumpType: Int
    
    /// 标红点击跳转的文字
    public var label: String
    
    /// 色值
    public var color: String
    
    /// 1：短信提醒 120002:不符合对方设置的聊天对象  4:安全提醒
    public var msgType: Int
    
    enum CodingKeys: String, CodingKey {
        case remindMsg = "RemindMsg"
        case jumpType = "jumpType"
        case label = "label"
        case color = "color"
        case msgType = "msgType"
    }
    public init(remindMsg: String, jumpType: Int, label: String, color: String, msgType: Int) {
        self.remindMsg = remindMsg
        self.jumpType = jumpType
        self.label = label
        self.color = color
        self.msgType = msgType
    }
}

/// MARK - 打招呼类型
public class WZIMHiboxElem: Codable {
    
    /// 打招呼内容
    public let text: String
    
    /// 打招呼类型
    public let hiboxType: Int
    
    enum CodingKeys: String, CodingKey {
        case text = "Text"
        case hiboxType = "HiboxType"
    }
}

/// MARK - 图片协议
public protocol WZIMImageElemProtocol {
    
    /// 要发送的图片路径
    var filePath: String {get}
    
    /// 图片 ID，内部标识，可用于外部缓存key
    var uuid: String {get}
    
    /// 图片大小
    var size: Int {get}
    
    /// 图片宽度
    var width: Int {get}
    
    /// 图片高度
    var height: Int {get}
    
    /// 下载URL
    var url: String {get}
}

// MARK - 推送用户卡片
public class WZMessageCardElem: Codable {
    
    public enum CardType: Int, WZIMDefaultEnumCodable {
        public static var defaultCase: WZMessageCardElem.CardType = .crm
        case crm = 1
        case app = 2
    }
    
    /// 卡片id
    public var cardId: String
    
    /// 用户名
    public var userName: String
    
    /// 城市
    public var area: String
    
    /// 年龄
    public var age: Int
    
    /// 本名片10分钟内有效
    public var expreTip: String
    
    /// 头像
    public var avatar: String
    
    /// 地址
    public var url: String
    
    /// 用户id
    public var userId: String
    
    enum CodingKeys: String, CodingKey {
        case cardId = "card_id"
        case userName = "username"
        case area = "area"
        case age = "age"
        case expreTip = "expre_tip"
        case avatar = "avatar"
        case url = "url"
        case userId = "userid"
    }
}

// MARK - 约会实名认证邀请 | 线上视频约会服务
public class WZMessageDateAuthInviteElem: Codable {
    
    /// 约会实名认证邀请
    public let text: String
    
    /// 我主良缘实名认证
    public let title: String
    
    /// 图片
    public let img: String
    
    enum CodingKeys: String, CodingKey {
        case title = "title"
        case text = "text"
        case img = "img"
    }
}

// MARK - 牵线首次登陆实名认证弹窗
public class WZMessageNmeAuthPopElem: Codable {
    
    /// 用户id
    public let userId: String
    
    /// xxx想与您进行视频约会，完成实名认证后即可安排约会
    public let text: String
    
    enum CodingKeys: String, CodingKey {
        case userId = "userid"
        case text = "text"
    }
}

// MARK - 红娘设置推荐条件
public class WZMessageServiceHnSetRecConElem: Codable {
    
    /// 用户id
    public let userId: String
    
    /// 该用户已开通红娘服务, 您是ta的专属红娘,请了解基础信息后，为其设置推荐条件"
    public let text: String
    
    /// 推荐条件
    public let label: String
    
    enum CodingKeys: String, CodingKey {
        case userId = "userid"
        case text = "text"
        case label = "keyword"
    }
}
