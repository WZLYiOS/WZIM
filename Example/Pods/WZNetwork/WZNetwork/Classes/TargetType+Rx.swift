//
//  TargetType+Rx.swift
//  WZNetwork
//
//  Created by xiaobin liu on 2019/7/3.
//  Copyright © 2019 xiaobin liu. All rights reserved.
//

import WZMoya
import RxSwift


// MARK: - TargetType + Rx
public extension TargetType {
    
    /// 请求
    ///
    /// - Returns: <#return value description#>
    func request() -> Single<WZMoya.Response> {
        return Network.default.provider
            .rx
            .request(.target(self))
            .observeOn(MainScheduler.instance)
    }
}
