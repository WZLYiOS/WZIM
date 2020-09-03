//
//  WZResult.swift
//  WZLY
//
//  Created by xiaobin liu on 2019/10/27.
//  Copyright © 2019 我主良缘. All rights reserved.
//

import Foundation


/// MARK - 服务端统一返回实体
public struct WZResult<T: Decodable>: Decodable {
    let code: Int
    let msg: String
    let data: T?
    
    enum CodingKeys: String, CodingKey {
        case code = "error_code"
        case msg = "msg"
        case data = "data"
    }
}
