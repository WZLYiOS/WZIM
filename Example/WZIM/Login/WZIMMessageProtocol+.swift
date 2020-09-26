//
//  WZIMMessageProtocol+.swift
//  WZIM_Example
//
//  Created by qiuqixiang on 2020/9/3.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
import WZIM

extension WZMessageProtocol {
    /// cell 标识
    func getCellIdentifier() -> UITableViewCell.Type {
        
        switch currentElem {
        case .img:
            return WZIMPictureTableViewCell.self
        case .text:
            return WZIMTextTableViewCell.self
        case .sound:
            return WZIMVoiceTableViewCell.self
        case .face:
            return WZIMFaceTableViewCell.self
        case .nameAuthInvite:
            return WZIMNameAuthInvateTableViewCell.self
        case .time:
            return WZIMTimeTableViewCell.self
        case .dateAuthInvite, .dateService:
            return WZIMMakingCourseTableViewCell.self
        default:
            return WZIMUnknownTableViewCell.self
        }
    }
}
