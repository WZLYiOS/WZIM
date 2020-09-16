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
    case img(WZIMImageCustomElem)          // 图片消息
    case makingCourse(WZIMMakingCourseCustomElem) // 红娘课程
    case videoDate(WZIMVideoDateCustomElem) // 线上视频约会服务
    case nameAuthInvite(WZIMnameAuthInviteCustomElem) // 邀请认证
    case time(WZIMTimeCustomElem)       // 时间
    case share(WZIMShareCustomElem)     // 分享消息
    case sms(WZIMRemindContentElem)     // 短信消息
    case notice(String)         // 透传消息
    case hibox(WZIMHiboxElem)           // 打招呼消息
    
    public init(from decoder: Decoder) throws {
        throw CordinateError.missingValue
    }
    
    enum CordinateError: Error {
        case missingValue
    }
    
    /// 获取string
    public func getMsg() -> String {
        switch self {
        case let .face(elem):
            let data = try! JSONEncoder().encode(elem)
            return String(data: data, encoding: .utf8) ?? ""
        case let .img(elem):
            let data = try! JSONEncoder().encode(elem)
            return String(data: data, encoding: .utf8) ?? ""
        case let .makingCourse(elem):
            let data = try! JSONEncoder().encode(elem)
            return String(data: data, encoding: .utf8) ?? ""
        case let .videoDate(elem):
            let data = try! JSONEncoder().encode(elem)
            return String(data: data, encoding: .utf8) ?? ""
        case let .nameAuthInvite(elem):
            let data = try! JSONEncoder().encode(elem)
            return String(data: data, encoding: .utf8) ?? ""
        case let .time(elem):
            let data = try! JSONEncoder().encode(elem)
            return String(data: data, encoding: .utf8) ?? ""
        case let .share(elem):
            let data = try! JSONEncoder().encode(elem)
            return String(data: data, encoding: .utf8) ?? ""
        case let .sms(elem):
            let data = try! JSONEncoder().encode(elem)
            return String(data: data, encoding: .utf8) ?? ""
        case let .notice(elem):
            let data = try! JSONEncoder().encode(elem)
            return String(data: data, encoding: .utf8) ?? ""
        case let .hibox(elem):
            let data = try! JSONEncoder().encode(elem)
            return String(data: data, encoding: .utf8) ?? ""
        default:
            return ""
        }
    }
    
}

// MARK - 自定义消息
public enum WZMessageCustomType: String, WZIMDefaultEnumCodable {
    
    public static var defaultCase: WZMessageCustomType = .none
    case none  // 未知消息
    case sms = "sms"   // 发送短信
    case safe = "safe" // 安全提醒
    case time = "time" // 时间
    case img = "img"   // 时间
    case notice = "notice" // 透传
    case userInfo = "userInfo" // 用户信息
    case share = "share" // 分享消息
    case hibox = "hibox" // 打招呼消息
    case inviteAuth = "inviteAuth" // 邀请认证
    case chatCard = "chatCard" // 卡片
}

// MARK - 我主自定义消息
public class WZIMCustomElem: Codable {
    
    /// 消息类型
    public var type: WZMessageCustomType
    
    /// 消息elem
    public var msg: String
    
    enum CodingKeys: String, CodingKey {
        case type = "type"
        case msg = "msg"
    }
    
    public init(type: WZMessageCustomType, msg: WZMessageElem) {
        self.type = type
        self.msg = msg.getMsg()
    }
    
    func getMsgElem() -> WZMessageElem {
        
        guard let data = msg.data(using: .utf8) else {
            return .unknown
        }
        switch type {
        case .img:
            return .img(try! CleanJSONDecoder().decode(WZIMImageCustomElem.self, from: data))
        case .inviteAuth:
            return .nameAuthInvite(try! CleanJSONDecoder().decode(WZIMnameAuthInviteCustomElem.self, from: data))
        case .time:
            return .time(try! CleanJSONDecoder().decode(WZIMTimeCustomElem.self, from: data))
        case .notice:
            return .notice(try! CleanJSONDecoder().decode(String.self, from: data))
        case .sms:
            return .sms(try! CleanJSONDecoder().decode(WZIMRemindContentElem.self, from: data))
        case .hibox:
            return .hibox(try! CleanJSONDecoder().decode(WZIMHiboxElem.self, from: data))
        default:
            return .unknown
        }
    }
    
    /// 获取该模型Data
    public func getEncodeData() -> Data? {
        return try? JSONEncoder().encode(self)
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

// MARK - 图片
public class WZIMImageCustomElem: Codable {
    
    /// 图片宽度
    public var width: CGFloat
    
    /// 图片高度
    public var heigth: CGFloat
    
    /// 图片大小,单位 Kb
    public var length: CGFloat
    
    /// 图片地址
    public var url: String
    
    /// 文件名
    public var fileName: String
    
    /// 文件路径
//    public var filePath: String
    
    enum CodingKeys: String, CodingKey {
        case width = "width"
        case heigth = "heigth"
        case length = "length"
        case url = "url"
        case fileName = "fileName"
//        case filePath = "filePath"
    }
    
   public init(image: UIImage, fileName: String, url: String) {
//        self.filePath = ""
        self.width = image.size.width
        self.heigth = image.size.height
        self.length = CGFloat(image.pngData()!.count/1024)
        self.url = url
        self.fileName = fileName
    }
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

// MARK - 红娘课程
public class WZIMMakingCourseCustomElem: Codable {
    
}

// MARK - 线上视频约会服务
public class WZIMVideoDateCustomElem: Codable {
    
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


