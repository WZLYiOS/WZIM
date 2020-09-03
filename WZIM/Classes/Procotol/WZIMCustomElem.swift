//
//  WZIMCustomElem.swift
//  WZLY
//
//  Created by qiuqixiang on 2020/8/23.
//  Copyright © 2020 我主良缘. All rights reserved.
//

import Foundation
import CleanJSON
import ImSDK

// MARK - 消息类型
public enum WZMessageElem {
    case unknown                       // 未知
    case text(WZIMTextProtocol)        // 文字消息
    case sound(WZIMVoiceProtocol)      // 音频
    case face(WZIMFaceCustomMarkModel) // 表情
    case img(WZIMImageCustomElem)      // 图片消息
    case makingCourse(WZIMMakingCourseCustomElem) // 红娘课程
    case videoDate(WZIMVideoDateCustomElem) // 线上视频约会服务
    case nameAuthInvite(WZIMnameAuthInviteCustomElem) // 开启约会实名认证邀请
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
public class WZIMCustomElem: NSObject, Codable {
    
    /// 消息类型
    var type: WZMessageCustomType
    
    /// 消息内容
    var msg: String
    
    enum CodingKeys: String, CodingKey {
        case type = "type"
        case msg = "msg"
    }
    
    init(type: WZMessageCustomType, msg: String) {
        self.type = type
        self.msg = msg
    }
    
    /// 解析对象
    func getDataModel() -> WZMessageElem {
        
        let decoder = CleanJSONDecoder()
//        decoder.valueNotFoundDecodingStrategy = .custom(CustomAdapter())
        
        switch type {
        case .img:
            let model = try! decoder.decode(WZIMImageCustomElem.self, from: msg.data(using: String.Encoding.utf8)!)
            return .img(model)
        default:
            return .unknown
        }
    }
    
    /// 获取腾讯自定义elem
    func getTIMCustomElem() -> TIMCustomElem {
        let xx = TIMCustomElem()
        xx.data = try? JSONEncoder().encode(self)
        return xx
    }
}

// MARK - 图片
public class WZIMImageCustomElem: Codable {
    
    /// 图片宽度
    var width: CGFloat
    
    /// 图片高度
    var heigth: CGFloat
    
    /// 图片大小,单位 Kb
    var length: CGFloat
    
    /// 图片地址
    var url: String
    
    /// 文件名
    var fileName: String
    
    enum CodingKeys: String, CodingKey {
        case width = "width"
        case heigth = "heigth"
        case length = "length"
        case url = "url"
        case fileName = "fileName"
    }
    
    init() {
        self.width = 0.0
        self.heigth = 0.0
        self.length = 0.0
        self.url = ""
        self.fileName = ""
    }
}

// MARK - 表情消息
public class WZIMFaceCustomMarkModel: Codable {
    
    enum FaceType: Int, WZIMDefaultEnumCodable {
        static var defaultCase: WZIMFaceCustomMarkModel.FaceType = .nomar
        case nomar = 1 // 正常消息
        case face = 2  // 表情
        case gif = 3   // gif
    }
    
    /// 1: 正常消息 2：emoj 3：gif
    var messageType: FaceType
    
    /// 表情数据
    var expressionData: WZIMFaceCustomModel
    
    /// 表情名字
    var name: String
    
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

// MARK - 开启约会实名认证邀请
public class WZIMnameAuthInviteCustomElem: Codable {
    
}
