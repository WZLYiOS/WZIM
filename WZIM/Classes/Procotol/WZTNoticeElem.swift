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
    case task = 43 // B端每日任务
    case dateRemind = 44 // 约会提醒
    case hnService = 45 // 红娘服务
    case uploadInfo = 46 // 用户资料更新
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
    case task(WZMessageTaskModel)
    case dateRemind(WZMessageNoticeDateRemindModel)
    case hnService(WZMessageNoticeHnServiceModel)
    case uploadInfo(WZMessageNoticeUploadUserInfoModel)
    
    public init(from decoder: Decoder) throws {
        throw CordinateError.missingValue
    }
    
    enum CordinateError: Error {
        case missingValue
    }
    
    /// 返回数据
    var data: Any? {
        switch self {
        case let .dynamic(model):
            return model
        case let .charmFinish(model):
            return model
        case let .checked(model):
            return model
        case let .addressNum(model):
            return model
        case let .redNum(model):
            return model
        case let .allTeskFinish(model):
            return model
        case let .memberFlag(model):
            return model
        case let .forYouQhys(model):
            return model
        case let .secretary(model):
            return model
        case let .openVip(model):
            return model
        case let .changedUserName(model):
            return model
        case let .faceAtuth(model):
            return model
        case let .moodChecked(model):
            return model
        case let .star(model):
            return model
        case let .svip(model):
            return model
        case let .task(model):
            return model
        case let .dateRemind(model):
            return model
        case let .hnService(model):
            return model
        case let .uploadInfo(model):
            return model
        default:
            return nil
        }
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
        case .memberFlag:
            elem = .memberFlag(try vals.decode(WZTNoticeMemberFlagModel.self, forKey: CodingKeys.elem))
        case .star:
            elem = .star(try vals.decode(WZTNoticeMemberFlagModel.self, forKey: CodingKeys.elem))
        case .svip:
            elem = .svip(try vals.decode(WZTNoticeMemberFlagModel.self, forKey: CodingKeys.elem))
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
        case .task:
            elem = .task(try vals.decode(WZMessageTaskModel.self, forKey: CodingKeys.elem))
        case .dateRemind:
            elem = .dateRemind(try vals.decode(WZMessageNoticeDateRemindModel.self, forKey: CodingKeys.elem))
        case .hnService:
            elem = .hnService(try vals.decode(WZMessageNoticeHnServiceModel.self, forKey: CodingKeys.elem))
        case .uploadInfo:
            elem = .uploadInfo(try vals.decode(WZMessageNoticeUploadUserInfoModel.self, forKey: CodingKeys.elem))
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
    
   public enum TeskType: Int, WZIMDefaultEnumCodable {
    public static var defaultCase: WZTNoticeCheckedModel.TeskType = .none
        case none
        case avatar = 1 // 头像审核
        case nikName = 3   // 昵称审核
        case nameAth = 4   // 实名
        case education = 5 // 学历
        case avatarAthu = 6 // 头像认证
    }
    
    /// 用户id
    public let userId: String
    
    /// 时间
    public let time: String
    
    /// 审核状态 1通过 0 不通过
    public let flag: String
    
    /// 通知的任务类型 1=&头像审核 3=&昵称审核 4=&实名 5=&学历 6: 头像认证
    public let stype: TeskType
    
    /// 扩展
    public let ext: WZMessageTaskExt
    
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
    
    /// 时间
    public var time: String
    
    /// 内容
    public var content: String
    
    /// 未读数量
    public var unreadNum: String
    
    enum CodingKeys: String, CodingKey {
        case time = "time"
        case content = "content"
        case unreadNum = "unReadNum"
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

/// MARK - B端每日任务
public class WZMessageTaskModel: Codable {
    
    public enum OperationType: Int, WZIMDefaultEnumCodable{
        public static var defaultCase: WZMessageTaskModel.OperationType = .none
        case none
        case refresh = 1 // 刷新
        case changed = 2 // 修改
        case remove = 3  // 移除
    }
    
    /// 任务数量
    public let taskNum: Int
    
    /// 任务卡片ID
    public let taskId: String
    
    ///
    public let type: Int
    
    /// 操作类型
    public let status: OperationType
    
    /// 对应操作数据
    public let ext: WZMessageTaskExt
    
    enum CodingKeys: String, CodingKey {
        case taskNum = "task_num"
        case taskId = "task_id"
        case type = "type"
        case status = "status"
        case ext = "ext"
    }
}

/// MARK - B端每日任务
public class WZMessageTaskExt: Codable {
    
    /// 2
    public let itemId: String
    
    enum CodingKeys: String, CodingKey {
        case itemId = "item_id"
    }
}

/// MARK - 约会提醒
public class WZMessageNoticeDateRemindModel: Codable {
    
    /// 是否有红点
    public var status: Bool
    
    /// 时间
    public var time: String
    
    /// 内容
    public var content: String
    
    /// 未读数量
    public var unreadNum: String
    
    enum CodingKeys: String, CodingKey {
        case time = "time"
        case content = "content"
        case unreadNum = "unreadNum"
        case status = "status"
    }
}

/// MARK - 红娘服务
public class WZMessageNoticeHnServiceModel: Codable {
    
    /// 用户id
    public let userId: String
    
    /// 服务id
    public let serviceId: Int
    
    enum CodingKeys: String, CodingKey {
        case userId = "userid"
        case serviceId = "id"
    }
}

/// MARK - 更新用户资料
public class WZMessageNoticeUploadUserInfoModel: Codable {
    
    /// 用户id
    public var userId: String
    
    enum CodingKeys: String, CodingKey {
        case userId = "userid"
    }
}
