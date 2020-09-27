//
//  WZIMChatRecordView.swift
//  WZLY
//
//  Created by qiuqixiang on 2020/8/28.
//  Copyright © 2020 我主良缘. All rights reserved.
//

import UIKit
import SnapKit

// MARK - 录音监听弹窗
public class WZIMChatRecordView: UIView {

    /// 代理
    public weak var delegate: WZIMChatRecordViewDelegate?
    
    /// 最大时限
    public var maxDuration: CGFloat = 59.0
    
    /// 
    public var recoderVioceTime: CGFloat = 10 * 60
    
    /// 音量多张图片
    public var voiceImageArray: [String] = ["ToolBbar.bundle/icon_volume1_pop",
                                            "ToolBbar.bundle/icon_volume2_pop",
                                            "ToolBbar.bundle/icon_volume3_pop",
                                            "ToolBbar.bundle/icon_volume4_pop",
                                            "ToolBbar.bundle/icon_volume5_pop",
                                            "ToolBbar.bundle/icon_volume6_pop"]
    
    /// 录音提示图标view
    private lazy var recordView: UIView = {
        $0.backgroundColor = UIColor.gray
        $0.layer.cornerRadius = 5
        $0.layer.masksToBounds = true
        $0.alpha = 0.6
        return $0
    }(UIView())
    
    /// 音量变化图标
    public lazy var voiceChangeImage: UIImageView = {
        $0.contentMode = .scaleAspectFill
        return $0
    }(UIImageView())
    
    /// 取消文字提示
    private lazy var voiceCancle: UILabel = {
        $0.textAlignment = .center
        $0.backgroundColor = UIColor.clear
        $0.text = "手指上滑,取消发送"
        $0.font = UIFont.systemFont(ofSize: 14)
        $0.textColor = WZIMToolAppearance.hexadecimal(rgb: "0xdfdfdf")
        $0.layer.cornerRadius = 5
        $0.layer.borderColor = UIColor.red.withAlphaComponent(0.5).cgColor
        return $0
    }(UILabel())
    
    /// 语音录制时间
    private var timer: Timer?
    
    /// 是否点击到按键外部
    private var buttonDragOutside: Bool = false
    
    /// 10秒倒计时
    private lazy var timerOutSoon: UILabel = {
        $0.textAlignment = .center
        $0.backgroundColor = UIColor.clear
        $0.font = UIFont.systemFont(ofSize: 80)
        $0.textColor = WZIMToolAppearance.hexadecimal(rgb: "0xdfdfdf")
        return $0
    }(UILabel())
    
    
    /// 执行的时间长度
    private var timeSum: CGFloat = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        self.isHidden = true
        configView()
        configViewLocation()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func configView() {
        self.addSubview(recordView)
        recordView.addSubview(voiceChangeImage)
        recordView.addSubview(timerOutSoon)
        recordView.addSubview(voiceCancle)
    }
    public func configViewLocation() {
        recordView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.equalTo(150)
            make.height.equalTo(150)
        }
        voiceChangeImage.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(10)
            make.leading.equalTo(20)
            make.right.equalTo(-20)
            make.bottom.equalToSuperview().offset(-60)
        }
        timerOutSoon.snp.makeConstraints { (make) in
            make.edges.equalTo(voiceChangeImage)
        }
        voiceCancle.snp.makeConstraints { (make) in
            make.leading.equalTo(15)
            make.right.equalToSuperview().offset(-15)
            make.bottom.equalToSuperview().offset(-15)
            make.height.equalTo(25)
        }
    }
    
    public func show() {
        UIApplication.shared.keyWindow?.addSubview(self)
        self.frame = UIApplication.shared.keyWindow?.bounds ?? CGRect.zero
    }
}

/// MARK - 扩展
extension WZIMChatRecordView {
    /// 录音按钮按下
    public func recordButtonTouchDown() {
        self.isHidden = false
        timeSum = 0.0
        buttonDragOutside = false
        timerOutSoon.text = ""
        voiceChangeImage.isHidden = false
        timerOutSoon.isHidden = true
        
        // 需要根据声音大小切换recordView动画
        voiceCancle.text = "手指上滑,取消发送";
        voiceCancle.backgroundColor = UIColor.clear
        timer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
    }
    
    @objc private func timerAction() {
        setVoiceImage()
    }
    
    // 手指在录音按钮内部时离开
    public func recordButtonTouchUpInside() {
        self.isHidden = true
        timeSum = 0
        buttonDragOutside = false
        timer?.invalidate()
        timer = nil
    }

    // 手指在录音按钮外部时离开
    public func recordButtonTouchUpOutside() {
        self.isHidden = true
        timeSum = 0
        buttonDragOutside = false
        timer?.invalidate()
        timer = nil
    }
    
    // 手指移动到录音按钮内部
    public func recordButtonDragInside() {
        buttonDragOutside = false
        voiceCancle.text = "手指上滑,取消发送"
        voiceCancle.backgroundColor = UIColor.clear
        voiceChangeImage.image =  voiceImageArray.count == 0 ? nil : UIImage(named: voiceImageArray.first!)
    }
  

    // 手指移动到录音按钮外部
    public func recordButtonDragOutside() {
        voiceChangeImage.isHidden = false
        timerOutSoon.isHidden = true
        buttonDragOutside = true
        voiceCancle.text = "松开手指,取消发送"
        voiceCancle.backgroundColor = WZIMToolAppearance.hexadecimal(rgb: "0x9d3836")
    }
   
    /// 图片效果
    private func setVoiceImage(){
        timeSum += 0.05
        if buttonDragOutside || timeSum > maxDuration {
            if timeSum > maxDuration {
                /// 时间超时
                timeOut()
                timeSum = 0.0
                buttonDragOutside = false
                timer?.invalidate()
                timer = nil
            }
            return
        }
        
        if timeSum >= recoderVioceTime - 10 {
            voiceChangeImage.isHidden = true
            timerOutSoon.isHidden = false
            if timeSum > recoderVioceTime {
                /// 时间超时
                timeOut()
                timeSum = 0.0
                buttonDragOutside = false
                timer?.invalidate()
                timer = nil
            }else if (timeSum > recoderVioceTime - 1) {
                timerOutSoon.text = "1";
            }
            else if (timeSum > recoderVioceTime - 2)
            {
                timerOutSoon.text = "2";
            }
            else if (timeSum > recoderVioceTime - 3)
            {
                timerOutSoon.text = "3";
            }
            else if (timeSum > recoderVioceTime - 4)
            {
                timerOutSoon.text = "4";
            }
            else if (timeSum > recoderVioceTime - 5)
            {
                timerOutSoon.text = "5";
            }
            else if (timeSum > recoderVioceTime - 6)
            {
                timerOutSoon.text = "6";
            }
            else if (timeSum > recoderVioceTime - 7)
            {
                timerOutSoon.text = "7";
            }
            else if (timeSum > recoderVioceTime - 8)
            {
                timerOutSoon.text = "8";
            }
            else if (timeSum > recoderVioceTime - 9)
            {
                timerOutSoon.text = "9";
            }
            else if (timeSum >= recoderVioceTime - 10)
            {
                timerOutSoon.text = "10";
            }
            return
        }
        
        voiceChangeImage.image =  voiceImageArray.count == 0 ? nil : UIImage(named: voiceImageArray.first!)
       
        let voiceSound: CGFloat = delegate?.getEmPeekRecorderVoiceMeter(view: self) ?? 0.0
        
        let index: Int = Int(floor(voiceSound*CGFloat(voiceImageArray.count)))
        if index >= voiceImageArray.count {
            voiceChangeImage.image = UIImage(named: voiceImageArray.last!)
        }else{
            voiceChangeImage.image = UIImage(named: voiceImageArray[index])
        }
    }
    
    private func timeOut() {
        timerOutSoon.isHidden = true
        voiceChangeImage.isHidden = false
        voiceChangeImage.image = UIImage(named: "ToolBbar.bundle/icon_warning_pop")
        voiceCancle.backgroundColor = UIColor.clear
        voiceCancle.text = "说话时间太长"
        delegate?.chatRecordView(view: self, recordTimeOut: timeSum)
    
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.3) {
            self.isHidden = true
        }
    }
}

// MARK - WZIMChatRecordViewDelegate
public protocol WZIMChatRecordViewDelegate: class {
    
    /// 超时退出
    func chatRecordView(view: WZIMChatRecordView, recordTimeOut: CGFloat)
    
    /// 获取音量大小
    func getEmPeekRecorderVoiceMeter(view: WZIMChatRecordView) -> CGFloat
}
