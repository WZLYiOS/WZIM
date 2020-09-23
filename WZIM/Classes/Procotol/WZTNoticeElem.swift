//
//  WZTNoticeElem.swift
//  WZIM
//
//  Created by qiuqixiang on 2020/9/23.
//

import Foundation

// MARK - 透传类型
public enum WZMessageNoticeType: Int, WZIMDefaultEnumCodable {
    public static var defaultCase: WZMessageNoticeType = .none
    case none  // 未知
    case dynamic = 1 // 为互动消息
    case brush = 2   // 擦肩而过消息数
    case charmFinish = 5 // 魅力值任务完成动效
    case checked = 6 // 后台审核透传
    case addressNum = 8 // 通讯录透传
    case redNum = 9  // 小红点透传
    case allTeskFinish = 10 // 全部任务完成透传
    case memberFlag = 11 // 会员状态变动透传
    case forYouQhys = 20 // 对方向你使用情话万能钥匙
    case secretary = 21 // 小秘书透传
    case openVip = 22 // 成功开通会员透传
    case changedUserName = 23 // 修改用户名透传
    case faceAtuth = 24 // 自动人脸认证透传
    case moodChecked = 25 // 我的问候语审核透传
    case star = 39 // 星标会员
    case svip = 40 // 超级会员
}

// MARK - 透传消息elem
public enum WZMessageNoticeElem: Decodable {
    case unknown                           // 未知
    case dynamic(WZTNoticeDynamicModel)
    case charmFinish(WZTNoticeCharmFinishModel)
    case checked(WZTNoticeCheckedModel)
    case addressNum(WZTNoticeAddressNumModel)
    case redNum(WZTNoticeRedNumModel)
    case allTeskFinish(WZTNoticeAllTeskFinishModel)
    case memberFlag(WZTNoticeMemberFlagModel)
    case forYouQhys(WZTNoticeForYouQhysModel)
    case secretary(WZTNoticeSecretaryModel)
    case openVip(WZTNoticeSecretaryModel)
    case changedUserName(WZTNoticeSecretaryModel)
    case faceAtuth(WZTNoticeSecretaryModel)
    case moodChecked(WZTNoticeMoodCheckedModel)
    case star(WZTNoticeMemberFlagModel)
    case svip(WZTNoticeMemberFlagModel)
    
    public init(from decoder: Decoder) throws {
        throw CordinateError.missingValue
    }
    
    enum CordinateError: Error {
        case missingValue
    }
}


// MARK - 透传消息
public class WZTNoticeElem: NSObject, Decodable {
    
    /// 类型
    public let type: WZMessageNoticeType
    
    /// 内容
    public let elem: WZMessageNoticeElem
    
    enum CodingKeys: String, CodingKey {
        case type = "type"
        case elem = "data"
    }
    
    required public init(from decoder: Decoder) throws {
        let vals = try decoder.container(keyedBy: WZTNoticeElem.CodingKeys.self)
        type = try vals.decode(WZMessageNoticeType.self, forKey: CodingKeys.type)
        switch type {
        case .dynamic:
            elem = .dynamic(try vals.decode(WZTNoticeDynamicModel.self, forKey: CodingKeys.elem))
        case .charmFinish:
            elem = .charmFinish(try vals.decode(WZTNoticeCharmFinishModel.self, forKey: CodingKeys.elem))
        case .checked:
            elem = .checked(try vals.decode(WZTNoticeCheckedModel.self, forKey: CodingKeys.elem))
        case .addressNum:
            elem = .addressNum(try vals.decode(WZTNoticeAddressNumModel.self, forKey: CodingKeys.elem))
        case .redNum:
            elem = .redNum(try vals.decode(WZTNoticeRedNumModel.self, forKey: CodingKeys.elem))
        case .allTeskFinish:
            elem = .allTeskFinish(try vals.decode(WZTNoticeAllTeskFinishModel.self, forKey: CodingKeys.elem))
        case .memberFlag, .star, .svip:
            elem = .memberFlag(try vals.decode(WZTNoticeMemberFlagModel.self, forKey: CodingKeys.elem))
        case .forYouQhys:
            elem = .forYouQhys(try vals.decode(WZTNoticeForYouQhysModel.self, forKey: CodingKeys.elem))
        case .secretary:
            elem = .secretary(try vals.decode(WZTNoticeSecretaryModel.self, forKey: CodingKeys.elem))
        case .openVip:
            elem = .openVip(try vals.decode(WZTNoticeSecretaryModel.self, forKey: CodingKeys.elem))
        case .changedUserName:
            elem = .changedUserName(try vals.decode(WZTNoticeSecretaryModel.self, forKey: CodingKeys.elem))
        case .faceAtuth:
            elem = .faceAtuth(try vals.decode(WZTNoticeSecretaryModel.self, forKey: CodingKeys.elem))
        case .moodChecked:
            elem = .moodChecked(try vals.decode(WZTNoticeMoodCheckedModel.self, forKey: CodingKeys.elem))
        default:
            elem = .unknown
        }
    }
}

/// MARK - 互动消息
public class WZTNoticeDynamicModel: Codable {
    
    /// 互动消息内容
    public let content: String
    
    /// 互动消息
    public let time: String
    
    /// 擦肩而过消息数
    public let messageNum: Int
    
    /// 是否有小红点
    public let dynamicStatus: String
    
    /// 透传跳转类型 1=&动态  2=&社区
    public let jumpType: Int
    
    enum CodingKeys: String, CodingKey {
        case content = "content"
        case time = "time"
        case messageNum = "messageNum"
        case dynamicStatus = "DynamicStatus"
        case jumpType = "jumpType"
    }
}

/// MARK -魅力值任务完成动效
public class WZTNoticeCharmFinishModel: Codable {
    
    /// 互动消息内容
    public let content: String
    
    /// 互动消息
    public let time: String
    
    /// 图片
    public let charmImg: String
    
    /// 标题
    public let title: String
    
    /// 增加数值
    public let num: String
    
    /// 通知的任务类型
    public let charmType: String
    
    enum CodingKeys: String, CodingKey {
        case content = "content"
        case time = "time"
        case charmImg = "charmImg"
        case title = "title"
        case num = "num"
        case charmType = "charmType"
    }
}

/// MARK - 后台审核透传
public class WZTNoticeCheckedModel: Codable {
    
    /// 用户id
    public let userId: String
    
    /// 时间
    public let time: String
    
    /// 审核状态 1通过 0 不通过
    public let flag: String
    
    /// 通知的任务类型 1=&头像审核 3=&昵称审核 4=&实名 5=&学历
    public let stype: String
    
    /// 扩展
    public let ext: WZTNoticeCheckedModel
    
    enum CodingKeys: String, CodingKey {
        case userId = "userid"
        case time = "time"
        case flag = "flag"
        case stype = "stype"
        case ext = "ext"
    }
}

/// MARK - 后台审核透传扩展
public class WZTNoticeCheckedExtModel: Codable {
    
    /// 是否可上传
    public let uploadFlag: Bool
    
    /// 您本周的上传头像次数已使用完毕，请下周再来哦~ 开通会员 畅享无限次上传头像特权！
    public let winMsg: String
    
    enum CodingKeys: String, CodingKey {
        case uploadFlag = "uploadFlag"
        case winMsg = "winMsg"
    }
}

/// MARK - 通讯录透传
public class WZTNoticeAddressNumModel: Codable {
    
    /// 通讯录小红点状态 bool true=&展示小红点 false=&不展示
    public let swaStatus: Bool
    
    enum CodingKeys: String, CodingKey {
        case swaStatus = "swaStatus"
    }
}

/// MARK - 小红点透传
public class WZTNoticeRedNumModel: Codable {
    
    /// 动态-关注
    public let dyFocus: String
    
    /// 我的-谁看过我
    public let myVisitedMe: String
    
    /// 我的-喜欢我
    public let myLikeMe: String
    
    /// 我的-互相喜欢
    public let myLoveEachOther: String
    
    enum CodingKeys: String, CodingKey {
        case dyFocus = "dy_focus"
        case myVisitedMe = "my_visited_me"
        case myLikeMe = "my_like_me"
        case myLoveEachOther = "my_love_each_other"
    }
}

/// MARK - 全部任务完成透传
public class WZTNoticeAllTeskFinishModel: Codable {
    
    /// 是否完成
    public let completed: Bool
    
    enum CodingKeys: String, CodingKey {
        case completed = "completed"
    }
}

/// MARK - 会员状态变动透传
public class WZTNoticeMemberFlagModel: Codable {
    
    /// 用户id
    public let userId: String
    
    /// 状态
    public let flag: Int
    
    /// 过期时间
    public let expireTime: String
    
    enum CodingKeys: String, CodingKey {
        case userId = "userid"
        case flag = "flag"
        case expireTime = "expire_time"
    }
}

/// MARK - 对方向你使用情话万能钥匙
public class WZTNoticeForYouQhysModel: Codable {
    
    /// 用户id
    public let userId: String
    
    enum CodingKeys: String, CodingKey {
        case userId = "userid"
    }
}

/// MARK - 小秘书透传等
public class WZTNoticeSecretaryModel: Codable {
    
    /// 文案
    public let messgae: String
    
    enum CodingKeys: String, CodingKey {
        case messgae = "messgae"
    }
}


/// MARK - 我的问候语审核透传
public class WZTNoticeMoodCheckedModel: Codable {
    
    /// 状态
    public let status: Int
    
    enum CodingKeys: String, CodingKey {
        case status = "status"
    }
}

