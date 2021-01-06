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
    func getCellIdentifier() -> WZIMBaseTableViewCell.Type {
        
        switch currentElem {
        case .face:
            return WZIMFaceTableViewCell.self
        default:
            return getNomarCellId()
        }
    }
}

extension WZMessageData {
    
    var cellIdentifier: WZIMBaseTableViewCell.Type {
        switch self {
        case let .msg(elem):
            return elem.getCellIdentifier()
        case .time:
            return WZIMTimeTableViewCell.self
        default:
            return WZIMUnknownTableViewCell.self
        }
    }
    
    var cellIdentifierId: String {
        switch self {
        case let .msg(elem):
            if elem.wzMessageId.count == 0 {
                debugPrint("xxxx")
            }
            return elem.wzMessageId
        case .time:
            return "im.cache.key.time"
        default:
            return ""
        }
    }
    
}
