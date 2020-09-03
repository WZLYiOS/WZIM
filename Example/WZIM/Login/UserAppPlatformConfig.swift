//
//  UserAppPlatformConfig.swift
//  WZIM_Example
//
//  Created by qiuqixiang on 2020/9/2.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation

/// MARK - 用户app基础配置(新)
@objcMembers
public class UserAppPlatformConfig: NSObject, Codable {
    
    /// 操作类型 1：注册 2-登录
    var operationType: Int
 
    /// 是否显示新人推荐,1:显示,0不显示
    var showNew: Int
    
    /// 是否上传形象照，1上传，0未上传
    var isAvatar: Int
    
    ///  是否上传学历、身高、月薪 0-未上传 1-已上传
    var isEhs: Int
    
    /// 是否上传一级兴趣爱好，1已上传，0未上传
    var isInterest: Int
    
    /// 是否需要变更名字 0=& 不需要 1=& 需要
    var nameStatus: Int
    
    /// 腾讯云通信签名
    var userSig: String
    
    /// 用户token
    var token: String
    
    /// 是否有邀请礼包，1有，0没有
    var hasSpreadPrize: Int
    
    /// userid
    var userId: String
    
    /// 是否是官方账号
    var isOfficial: String
    
    /// 手机号
    var mobile: String
    
    /// 是否设置为密码
    var isSetpwd: Bool
    
    /// 跳转到哪个控制器 1:动态广场
    var pushTypeVC: Int
    
    /// 省份Id
    var provinceId: String
    
    /// 城市Id
    var cityId: String
    
    /// 省份名称
    var provinceidName: String

    /// 城市名称
    var cityidName: String
    
    enum CodingKeys: String, CodingKey {
        case operationType = "operation_type"
        case showNew = "showNew"
        case isAvatar = "is_avatar"
        case isEhs = "is_ehs"
        case isInterest = "is_interest"
        case nameStatus = "nameStatus"
        case userSig = "userSig"
        case token = "token"
        case hasSpreadPrize = "has_spread_prize"
        case userId = "userid"
        case isOfficial = "is_official"
        case mobile = "mobile"
        case isSetpwd = "is_setpwd"
        case pushTypeVC = "pushTypeVC"
        case provinceId = "provinceid"
        case cityId = "cityid"
        case provinceidName = "provinceidname"
        case cityidName = "cityidname"
    }
}
