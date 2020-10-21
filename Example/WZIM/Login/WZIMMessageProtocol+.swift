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
        case .card:
            return WZIMRecommendCardTableViewCell.self
        case let .signaling(elem):
            if elem.actionType == .invit && loaction == .lelft {
                return WZIMVideoInviteTableViewCell.self
            }
            return WZIMVideoInviteSelfTableViewCell.self
        case .share:
            return WZIMActivityTableViewCell.self
        default:
            return WZIMUnknownTableViewCell.self
        }
    }
}
