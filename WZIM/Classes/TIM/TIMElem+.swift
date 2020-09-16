//
//  TIMElem+.swift
//  WZLY
//
//  Created by qiuqixiang on 2020/8/23.
//  Copyright © 2020 我主良缘. All rights reserved.
//

import Foundation
import CleanJSON
import ImSDK

// MARK - 自定义
extension TIMElem {
    
    /// 获取当前的
    func getElem() -> WZMessageElem {
        switch self {
        case is TIMTextElem:
            return .text(self as! TIMTextElem)
        case is TIMSoundElem:
            return .sound(self as! TIMSoundElem)
        case is TIMCustomElem:
            let custom = self as! TIMCustomElem

            guard let model = try? CleanJSONDecoder().decode(WZIMCustomElem.self, from: custom.customData) else {
                return .unknown
            }
            
            return model.getMsgElem()
        case is TIMFaceElem:
            let face = self as! TIMFaceElem
            let model = try! CleanJSONDecoder().decode(WZIMFaceCustomMarkModel.self, from: face.data)
            return .face(model)
        default:
            return .unknown
        }
    }
}

// MARK -
extension TIMCustomElem {
    
    /// 服务端返回的消息msg可能是字典
    var customData: Data {
        
        /// 获取json
        guard var dic = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String : Any] else {
            return data
        }
        
        switch dic["msg"] {
        case is [String: Any]:
            guard let jsonData = try? JSONSerialization.data(withJSONObject: dic["msg"] as Any,options: []) else {
                return data
            }
            let str = String(data: jsonData,encoding:String.Encoding.utf8)
            dic["msg"] = str
            guard let model = try? JSONSerialization.data(withJSONObject: dic as Any, options: []) else {
                return data
            }
            return model
        default: break
        }
        return data
    }
}

// MARK - 遵循文字
extension TIMTextElem: WZIMTextProtocol {
    
    public func getText() -> String {
        return text
    }
}

// MARK - 音频
extension TIMSoundElem: WZIMVoiceProtocol {
    
    public func wzSecond() -> Int {
        return Int(second)
    }
    
    public func wzGetSound(sucess: ((String) -> Void)?, fail: ((Error) -> Void)?) {
        
        /// 路径
        let oPath = wzPath()
        
        /// 判断是否已下载
        if FileManager.default.fileExists(atPath: wzPath()) {
            sucess?(oPath)
            return
        }
        
        getSound(oPath, succ: {
            sucess?(oPath)
        }) { (code, msg) in
            fail?(NSError(domain: msg ?? "", code: Int(code), userInfo: nil))
            debugPrint("音频下载失败：\(String(describing: oPath))")
        }
    }

    /// 播放路径
    public func wzPath() -> String {
        
        /// 自己上传
        if path.count > 0 {
            let mPath = "\(WZIMToolAppearance.getDBPath(name: "voice"))\((path as NSString).lastPathComponent)"
            if FileManager.default.fileExists(atPath: mPath) {
                return mPath
            }
        }
        /// 下载
        let oPath = WZIMToolAppearance.getVoicePathMp3(userId: TIMManager.sharedInstance()!.getLoginUser(), uuid: uuid)
        return  oPath
    }
}
