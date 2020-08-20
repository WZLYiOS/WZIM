//
//  WZIMUserInfo.swift
//  SweepTreasure
//
//  Created by qiuqixiang on 2020/7/18.
//  Copyright © 2020 划宝. All rights reserved.
//

import Foundation

// MARK - 用户资料
public protocol WZIMUserInfoProtocol {
    
    /// 用户名
    func wzGetUserName() -> String
    
    /// 用户头像
    func wzGetAvatar() -> String
}
