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
        let decoder = CleanJSONDecoder()
        
        switch self {
        case is TIMTextElem:
            return .text(self as! TIMTextElem)
        case is TIMSoundElem:
            return .sound(self as! TIMSoundElem)
        case is TIMCustomElem:
            let custom = self as! TIMCustomElem
            let model = try! decoder.decode(WZIMCustomElem.self, from: custom.data)
            return model.getDataModel()
        case is TIMFaceElem:
            let face = self as! TIMFaceElem
            let model = try! decoder.decode(WZIMFaceCustomMarkModel.self, from: face.data)
            return .face(model)
        default:
            return .unknown
        }
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
