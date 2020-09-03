//
//  WZAudioRecorder.swift
//  WZLY
//
//  Created by qiuqixiang on 2020/8/28.
//  Copyright © 2020 我主良缘. All rights reserved.
//

import Foundation
import AVFoundation

// MARK - 音频录制
public class WZAudioRecorder: NSObject {
    
    /// 代理
    public weak var delegate: WZAudioRecorderDelegate?
    
    /// 开始录制时间
    private var startDate: Int = 0
    
    /// 是否暂停
    private var isStopRecorde: Bool = false
    
    /// 录音设置
    private let settings = [AVSampleRateKey: NSNumber(value: 44100.0),
                            AVFormatIDKey: NSNumber(value: kAudioFormatLinearPCM),
                            AVLinearPCMBitDepthKey: NSNumber(value: 16),
                            AVNumberOfChannelsKey: NSNumber(value: 2),
                            AVEncoderAudioQualityKey: NSNumber(value: AVAudioQuality.high.rawValue)]
    
    /// 录制对象
    private var recorder: AVAudioRecorder?
    
    /// 路径
    private var mp3Path: String = ""
    
    /// 开始录制
    public func starRecorder(aFilePath: String) {
        
        /// 权限判断
        AVAudioSession.sharedInstance().requestRecordPermission { (granted) in
            if granted == false {
                self.delegate?.audioRecorderEncodeErrorDidOccur(self, error: NSError(domain: "请开启麦克风权限", code: -1003, userInfo: nil))
                return
            }
        }
        
        /// 开始录制
        delegate?.startAudioRecorder(self)
        
        /// 重置
        if recorder != nil {
            cancelCurrentRecording()
        }
        mp3Path = aFilePath
        let audioSession = AVAudioSession.sharedInstance()
        try? audioSession.setCategory(AVAudioSession.Category.playAndRecord)
        try? audioSession.setActive(true, options: AVAudioSession.SetActiveOptions.notifyOthersOnDeactivation)
        UIDevice.current.isProximityMonitoringEnabled = false
        
        let wavPath = aFilePath.replacingOccurrences(of: "mp3", with: "wav")
        let url = URL(fileURLWithPath: wavPath)
        
        recorder = try? AVAudioRecorder(url: url, settings: settings)
        recorder?.isMeteringEnabled = true
        recorder?.delegate = self
        recorder?.prepareToRecord()
        recorder?.record()
        recorder?.updateMeters()

        if recorder == nil {
            delegate?.audioRecorderEncodeErrorDidOccur(self, error: NSError(domain: "初始化失败", code: -1003, userInfo: nil))
            return
        }
        startDate = Int(NSDate().timeIntervalSince1970)
        isStopRecorde = false
        /// 开启MP3转码
         delegate?.audioRecorderToMp3(wavFilePath: wavPath, mp3FilePath: aFilePath, isStop: isStopRecorde)
    }

    
    /// 结束录制
    private func finishRecorder(){
        
        let duration = Int(NSDate().timeIntervalSince1970) - startDate
        delegate?.audioRecorderDidFinishRecording(self, path: mp3Path, duration: duration)
        cancelCurrentRecording()
    }
    
    /// 停止录制
    public func stop() {
        recorder?.stop()
    }
    
    /// 取消录制
    public func cancelCurrentRecording() {
        recorder?.delegate = nil
        if ((recorder?.isRecording) != nil) {
            recorder?.stop()
        }
        UIDevice.current.isProximityMonitoringEnabled = true
        isStopRecorde = true
        recorder = nil
        mp3Path = ""
    }
    
    /// 获取音量幅度
    public func emPeekRecorderVoiceMeter() -> double_t {
        if ((recorder?.isRecording) != nil) {
            recorder?.updateMeters()
            let xxx = double_t(pow(10, (0.05*recorder!.peakPower(forChannel: 0))))
            return xxx
        }
        return 0.0
    }
}

// MARK - WZAudioRecorderDelegate
public protocol WZAudioRecorderDelegate: class {
    
    /// 录制成功
    func audioRecorderDidFinishRecording(_ recorder: WZAudioRecorder, path: String, duration: Int)
    
    /// 录制失败
    func audioRecorderEncodeErrorDidOccur(_ recorder: WZAudioRecorder, error: Error?)
    
    /// 开始录制
    func startAudioRecorder(_ recorder: WZAudioRecorder)
    
    /// 实时Mp3转码
    func audioRecorderToMp3(wavFilePath: String, mp3FilePath: String, isStop: Bool)
}

/// MARK - AVAudioRecorderDelegate
extension WZAudioRecorder: AVAudioRecorderDelegate {
    
    public func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            finishRecorder()
        }else{
            delegate?.audioRecorderEncodeErrorDidOccur(self, error: NSError(domain: "路径存储失败", code: -1003, userInfo: nil))
            cancelCurrentRecording()
        }
    }
    
    public func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        delegate?.audioRecorderEncodeErrorDidOccur(self, error: error)
        cancelCurrentRecording()
    }
}
