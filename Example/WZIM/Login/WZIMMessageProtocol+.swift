//
//  WZIMMessageProtocol+.swift
//  WZIM_Example
//
//  Created by qiuqixiang on 2020/9/3.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
import WZIM

extension WZIMMessageProtocol {
    /// cell 标识
    func getCellIdentifier() -> UITableViewCell.Type {
        
        switch wzCurrentElem() {
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
        default:
            return WZIMUnknownTableViewCell.self
        }
    }
}
