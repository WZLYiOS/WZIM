//
//  LoginApi.swift
//  WZIM_Example
//
//  Created by qiuqixiang on 2020/9/2.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import WZMoya
import Foundation
// MARK - 账户模块API
public enum UserLoginApi {
    
    /// 登录
    case logIn(username: String, password: String)
}

extension UserLoginApi: TargetType{
    
    public var baseURL: URL { return URL(string: "http://v4malu2x.api.7799520.com")! }
    
    public var path: String {
        
        switch self {
        case .logIn:
            return "/passport/app/Login/login"
        }
    }
    
    public var method: WZMoya.Method {
        switch self {
        case .logIn:
            return .post
        }
    }
    
    public var task: Task {
        switch self {
        case let .logIn(username, password):
            let parameters: [String: Any] = [
            "version": Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "4.0.0",
            "source": "ios",
            "system" :String(UIDevice.current.systemVersion),
            "login_type": 1,
            "username": username,
            "password": password]
            
            return Task.requestEncryption(parameters: parameters, encoding: URLEncoding.methodDependent)
        }
    }
    
    public var headers: [String : String]? {
        return nil
    }
    
    public var sampleData: Data {
        return "".data(using: String.Encoding.utf8)!
    }
}
