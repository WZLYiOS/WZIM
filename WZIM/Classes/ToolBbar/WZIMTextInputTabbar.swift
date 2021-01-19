//
//  WZIMTextInputTabbar.swift
//  WZLY
//
//  Created by qiuqixiang on 2020/8/24.
//  Copyright © 2020 我主良缘. All rights reserved.
//

import UIKit
import SnapKit
import WZLame

// MARK - 消息详情页面底部tabbar
public class WZIMTextInputTabbar: UIView {

    /// 键盘事件
    public enum KeyboardEvent: Int {
        case hidden = 0 // 关闭键盘
        case voice = 1  // 打开语音
        case input = 2  // 输入键盘
        case more = 3   // 更多
        case emoj = 4   // 表情
        case cancelEmoj = 5 // 取消表情键盘
    }
    
    /// 视图tag标签
    public enum KeyboardViewTag: Int {
        case keyboard = 0  // 键盘
        case more = 1      // 更多
    }
    
    /// 录音事件
    public enum RecordEvent: Int {
        case down = 0
        case upOutside = 1
        case upInside = 2
        case dragOutside = 3
        case dragInside = 4
        case timeOut = 5   // 超时
        case cancel = 6    // 取消
    }
    
    public weak var delegate: WZIMTextInputTabbarDelegate!
    
    /// 输入框
    public lazy var textInputView: WZIMTextInputView = {
        $0.delegate = self
        return $0
    }(WZIMTextInputView())
    
    /// 表情键盘
    private lazy var emojButton: UIButton = {
        $0.setImage(UIImage(named: "ToolBbar.bundle/ic_talk_keyboard"), for: .selected)
        $0.setImage(UIImage(named: "ToolBbar.bundle/ic_talk_expression"), for: .normal)
        $0.addTarget(self, action: #selector(emojButtonAction), for: .touchUpInside)
        return $0
    }(UIButton())
    
    /// 更多键盘
    private lazy var moreButton: UIButton = {
        $0.setImage(UIImage(named: "ToolBbar.bundle/ic_talk_morefunctions"), for: .normal)
        $0.addTarget(self, action: #selector(moreButtonAction), for: .touchUpInside)
        return $0
    }(UIButton())
    
    /// 音频
    private lazy var vioceButton: UIButton = {
        $0.setImage(UIImage(named: "ToolBbar.bundle/ic_talk_voice"), for: .normal)
        $0.setImage(UIImage(named: "ToolBbar.bundle/ic_talk_expression"), for: .selected)
        $0.addTarget(self, action: #selector(vioceButtonAction), for: .touchUpInside)
        return $0
    }(UIButton())
    
    /// 音频录制按钮
    private lazy var recordButton: UIButton = {
        $0.contentHorizontalAlignment = .center
        $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        $0.isExclusiveTouch = true
        $0.setTitle("按住说话", for: .normal)
        $0.setTitle("松开结束", for: .highlighted)
        $0.setBackgroundImage(WZIMToolAppearance.image(color: UIColor.white), for: .normal)
        $0.setBackgroundImage(WZIMToolAppearance.image(color: WZIMToolAppearance.hexadecimal(rgb: "0xc6c7ca")), for: .highlighted)
        $0.setTitleColor(WZIMToolAppearance.hexadecimal(rgb: "0x1C1C1C"), for: .normal)
        $0.setTitleColor(WZIMToolAppearance.hexadecimal(rgb: "0x7C7C7C"), for: .normal)
        $0.layer.cornerRadius = 18
        $0.layer.masksToBounds = true
        $0.layer.borderWidth = 0.5
        $0.layer.borderColor = WZIMToolAppearance.hexadecimal(rgb: "0xE6E6E6").cgColor
        $0.addTarget(self, action: #selector(recordButtonTouchDown), for: .touchDown)
        $0.addTarget(self, action: #selector(recordButtonTouchUpOutside), for: .touchUpOutside)
        $0.addTarget(self, action: #selector(recordButtonTouchUpInside), for: .touchUpInside)
        $0.addTarget(self, action: #selector(recordDragOutside), for: .touchDragExit)
        $0.addTarget(self, action: #selector(recordDragInside), for: .touchDragEnter)
        $0.isHidden = true
        return $0
    }(UIButton(type: .custom))
        
    /// 键盘
    private lazy var keyboardView: WZIMKeyboardView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.tag = KeyboardViewTag.keyboard.rawValue
        $0.backgroundColor = UIColor.white
        $0.isHidden = true
        return $0
    }(WZIMKeyboardView())
    
    /// 更多视图
    public lazy var moreView: WZIMMoreView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.isHidden = true
        $0.tag = KeyboardViewTag.more.rawValue
        return $0
    }(WZIMMoreView())
    
    /// 底部背景视图
    private lazy var bottomStackView: UIStackView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.axis = .vertical
        $0.distribution = .fill
        $0.alignment = .fill
        $0.layer.masksToBounds = true
        return $0
    }(UIStackView(arrangedSubviews: [moreView, keyboardView, bottomView]))
    
    /// 音频录制
    private lazy var audioRecorder: WZAudioRecorder = {
        $0.delegate = self
        return $0
    }(WZAudioRecorder())
    
    /// 音频播放
    public lazy var audioPlayer: WZAVAudioPlayer = {
        $0.delegate = self
        return $0
    }(WZAVAudioPlayer())
    
    /// 录制音量View
    private lazy var recordView: WZIMChatRecordView = {
        $0.delegate = self
        return $0
    }(WZIMChatRecordView())
    
    /// 底部间距颜色
    public lazy var bottomView: UIView = {
        $0.backgroundColor = UIColor.white
        $0.heightAnchor.constraint(equalToConstant: CGFloat(WZIMToolAppearance.safeAreaInsetsBottom)).isActive = true
        return $0
    }(UIView())
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white

        configView()
        configViewLocation()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name:UIResponder.keyboardWillShowNotification,object: nil)
        NotificationCenter.default.addObserver(self,selector: #selector(keyboardWillHide(notification:)),name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self,selector: #selector(didEnterBackgroundNotification),name: UIApplication.didEnterBackgroundNotification, object: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configView() {
        
        self.addSubview(textInputView)
        self.addSubview(moreButton)
        self.addSubview(emojButton)
        self.addSubview(vioceButton)
        self.addSubview(bottomStackView)
        self.addSubview(recordButton)
        recordView.show()
    }
    func configViewLocation() {
        
        textInputView.snp.makeConstraints { (make) in
            make.leading.equalTo(65)
            make.top.equalToSuperview().offset(10)
            make.height.equalTo(35)
        }
        
        bottomStackView.snp.makeConstraints { (make) in
            make.leading.equalTo(0)
            make.right.equalToSuperview()
            make.top.equalTo(textInputView.snp.bottom).offset(10)
            make.bottom.equalToSuperview()
        }
    
        vioceButton.snp.makeConstraints { (make) in
            make.leading.equalTo(15)
            make.width.equalTo(35)
            make.height.equalTo(35)
            make.bottom.equalTo(textInputView.snp.bottom)
        }
        
        emojButton.snp.makeConstraints { (make) in
            make.left.equalTo(textInputView.snp.right).offset(10)
            make.width.equalTo(35)
            make.height.equalTo(35)
            make.centerY.equalTo(moreButton.snp.centerY)
        }
        
        moreButton.snp.makeConstraints { (make) in
            make.left.equalTo(emojButton.snp.right).offset(15)
            make.right.equalToSuperview().offset(-15)
            make.width.equalTo(35)
            make.height.equalTo(35)
            make.centerY.equalTo(vioceButton.snp.centerY)
        }
        recordButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(textInputView.snp.centerY)
            make.left.equalTo(vioceButton.snp.right).offset(15)
            make.right.equalTo(emojButton.snp.left).offset(-15)
            make.height.equalTo(35)
        }
    }
    
    // 键盘显示
    @objc func keyboardWillShow(notification: Notification) {
        
         //通知里的内容
        guard let userInfo = notification.userInfo as NSDictionary? else {
            return
        }
        
        let durationNumber = userInfo.object(forKey: UIResponder.keyboardAnimationDurationUserInfoKey) as? NSNumber
        let duration = Double(truncating: durationNumber ?? NSNumber.init(value: 0.25))
        
        let aValue = userInfo.object(forKey: UIResponder.keyboardFrameEndUserInfoKey)
        let keyboardRect = (aValue as AnyObject).cgRectValue
        let y = keyboardRect?.size.height ?? 0
        getBottomView(tag: .more)?.isHidden = true
        keyboardView.isHidden = false
        keyboardView.change(height: y-CGFloat(WZIMToolAppearance.safeAreaInsetsBottom))
        UIView.animate(withDuration: duration == 0 ? 0.25 : duration) {
            self.superview?.layoutIfNeeded()
            self.delegate?.textInputTabbarDidChange(tabbar: self, animated: false)
        }
    }
    // 键盘隐藏
    @objc func keyboardWillHide(notification: Notification) {
        keyboardView.isHidden = true
    }
    @objc func didEnterBackgroundNotification(notification: Notification) {
        recordButton(event: .cancel)
    }
}

// MARK - 扩展
extension WZIMTextInputTabbar {
    
    /// 表情事件
    @objc private func emojButtonAction(btn: UIButton) {
        btn.isSelected = !btn.isSelected
        delegate?.textInputTabbar(tabbar: self, emojiBtn: btn)
        eventAction(type: btn.isSelected ? .emoj : .cancelEmoj)
    }
    
    /// 更多按钮事件
    @objc private func moreButtonAction(btn: UIButton) {
        btn.isSelected = !btn.isSelected
        if btn.isSelected {
            eventAction(type: .more)
            return
        }
        eventAction(type: .input)
    }
    
    /// 音频
    @objc private func vioceButtonAction(btn: UIButton) {
        btn.isSelected = !btn.isSelected
        eventAction(type: btn.isSelected ? .voice : .input)
    }
    
    /// 各种键盘事件
    private func eventAction(type: KeyboardEvent) {
        
        switch type {
        case .hidden:
            emojButton.isSelected = false
            moreButton.isSelected = false
            textInputView.textInput.resignFirstResponder()
            if getBottomView(tag: .more)?.isHidden == false {
                UIView.animate(withDuration: 0.25) {
                    self.getBottomView(tag: .more)?.isHidden = true
                    self.superview?.layoutIfNeeded()
                }
            }
        case .emoj:
            moreButton.isSelected = false
            vioceButton.isSelected = false
            recordButton.isHidden = true
            getBottomView(tag: .more)?.isHidden = true
            textInputView.chandge(isHidden: false)
        case .cancelEmoj:
            moreButton.isSelected = false
            getBottomView(tag: .more)?.isHidden = true
            textInputView.textInput.becomeFirstResponder()
        case .input:
            moreButton.isSelected = false
            getBottomView(tag: .more)?.isHidden = true
            recordButton.isHidden = true
            textInputView.chandge(isHidden: false)
        case .more:
            getBottomView(tag: .keyboard)?.isHidden = true
            textInputView.chandge(isHidden: false, isOpenKeyBor: false)
            getBottomView(tag: .more)?.isHidden = false
            vioceButton.isSelected = false
            emojButton.isSelected = false
            recordButton.isHidden = true
            UIView.animate(withDuration: 0.25) {
                self.superview?.layoutIfNeeded()
                self.delegate?.textInputTabbarDidChange(tabbar: self, animated: false)
            }
        case .voice:
            moreButton.isSelected = false
            getBottomView(tag: .more)?.isHidden = true
            emojButton.isSelected = false
            recordButton.isHidden = false
            textInputView.chandge(isHidden: true)
            UIView.animate(withDuration: 0.25) {
                self.superview?.layoutIfNeeded()
            }
        }
    }
    
    @objc private func recordButtonTouchDown(btn: UIButton) {
        recordButton(event: .down)
    }
    @objc private func recordButtonTouchUpOutside(btn: UIButton) {
        recordButton(event: .upOutside)
    }
    @objc private func recordButtonTouchUpInside(btn: UIButton) {
        recordButton(event: .upInside)
    }
    @objc private func recordDragOutside(btn: UIButton) {
        recordButton(event: .dragOutside)
    }
    @objc private func recordDragInside(btn: UIButton) {
        recordButton(event: .dragInside)
    }
    
    /// 录音事件
    private func recordButton(event: WZIMTextInputTabbar.RecordEvent) {
        switch event {
        case .down:
            recordView.recordButtonTouchDown()
            let path = WZIMToolAppearance.DBType.voice.getPath(userId: delegate.userIdTextInputTabbar(tabbar: self))
            audioRecorder.starRecorder(aFilePath: path)
            delegate?.textInputTabbar(tabbar: self, canPop: false)
        case .upOutside:
            recordView.recordButtonTouchUpOutside()
        case .upInside:
            delegate?.textInputTabbar(tabbar: self, canPop: true)
            recordView.recordButtonTouchUpInside()
            audioRecorder.stop()
        case .dragOutside:
            recordView.recordButtonDragOutside()
        case .dragInside:
            recordView.recordButtonDragInside()
        case .timeOut:
            delegate?.textInputTabbar(tabbar: self, canPop: true)
            audioRecorder.stop()
        case .cancel:
            delegate?.textInputTabbar(tabbar: self, canPop: true)
            recordView.recordButtonTouchUpInside()
            audioRecorder.cancelCurrentRecording()
        }
    }
    
    /// 根据tag 获取View
    private func getBottomView(tag: KeyboardViewTag) -> UIView? {
        for view in bottomStackView.subviews {
            if view.tag == tag.rawValue {
                return view
            }
        }
        return  nil
    }
    
    /// 关闭弹窗
    public func hideKeyboard() {
        eventAction(type: .hidden)
    }
    
    /// 关闭表情键盘
    public func closeEmojKeyboard() {
        emojButton.isSelected = false
        eventAction(type: .cancelEmoj)
    }
    
    /// 清空文本内容
    public func clearTextInput(){
        textInputView.clearTextInput()
    }
}

/// MARK - HBIMTextInputTabbarDelegate
public protocol WZIMTextInputTabbarDelegate: class {
    
    /// 回车
    func textInputTabbar(tabbar: WZIMTextInputTabbar, replacementText text: String)
    
    /// 内容输入
    func textInputTabbarDidChange(tabbar: WZIMTextInputTabbar, animated: Bool)
    
    /// 表情键盘事件
    func textInputTabbar(tabbar: WZIMTextInputTabbar, emojiBtn: UIButton)
    
    /// 是否可返回
    func textInputTabbar(tabbar: WZIMTextInputTabbar, canPop: Bool)

    /// 获取用户id
    func userIdTextInputTabbar(tabbar: WZIMTextInputTabbar) -> String
    
    /// 录音结束
    func textInputTabbar(tabbar: WZIMTextInputTabbar, audioRecorder path: String, duration: Int)
    
    /// 录音错误
    func textInputTabbar(tabbar: WZIMTextInputTabbar, audioRecorder error: Error)
    
    /// 音频播放失败
    func textInputTabbar(tabbar: WZIMTextInputTabbar, audioPlayer error: Error)
    
    /// 音频播放成功
    func textInputTabbar(tabbar: WZIMTextInputTabbar, player flag: Bool, path: String)
}

/// MARK - YYTextViewDelegate
extension WZIMTextInputTabbar: WZIMTextInputViewDelegate {
    
    public func textViewDidChange(view: WZIMTextInputView, animated: Bool) {
        UIView.animate(withDuration: 0.25) {
            self.superview?.layoutIfNeeded()
            self.delegate?.textInputTabbarDidChange(tabbar: self, animated: animated)
        }
    }
    
    public func textViewDidReturn(view: WZIMTextInputView) {
        delegate?.textInputTabbar(tabbar: self, replacementText: view.textInput.text)
    }
}

/// MARK - WZAudioRecorderDelegate
extension WZIMTextInputTabbar: WZAudioRecorderDelegate {
    
    public func audioRecorderToMp3(wavFilePath: String, mp3FilePath: String, isStop: Bool) {
        WZLame.convent(toMp3: wavFilePath, withFilePath: mp3FilePath, withStop: isStop)
    }

    public func audioRecorderDidFinishRecording(_ recorder: WZAudioRecorder, path: String, duration: Int) {
        if duration == 0 || !FileManager.default.fileExists(atPath: path) { return }
        delegate.textInputTabbar(tabbar: self, audioRecorder: path, duration: duration)
    }
    
    public func audioRecorderEncodeErrorDidOccur(_ recorder: WZAudioRecorder, error: Error?) {
        delegate.textInputTabbar(tabbar: self, audioRecorder: error!)
    }
    
    public func startAudioRecorder(_ recorder: WZAudioRecorder) {
        audioPlayer.stopCurrentPlaying()
    }
}

/// MARK - WZAVAudioPlayerDelegate
extension WZIMTextInputTabbar: WZAVAudioPlayerDelegate {
  
    public func audioPlayerDidFinishPlaying(_ player: WZAVAudioPlayer, successfully flag: Bool) {
        delegate.textInputTabbar(tabbar: self, player: flag, path: player.wzPlayer?.url?.path ?? "")
    }

    public func audioPlayerDecodeErrorDidOccur(_ player: WZAVAudioPlayer, error: Error?) {
        delegate.textInputTabbar(tabbar: self, audioPlayer: error!)
    }
}

/// MARK - WZIMChatRecordViewDelegate
extension WZIMTextInputTabbar: WZIMChatRecordViewDelegate {
    
    public func chatRecordView(view: WZIMChatRecordView, recordTimeOut: CGFloat) {
        recordButton(event: .timeOut)
    }
    
    public func getEmPeekRecorderVoiceMeter(view: WZIMChatRecordView) -> CGFloat {
        return CGFloat(audioRecorder.emPeekRecorderVoiceMeter())
    }
}


class WZIMKeyboardView: UIView {
    
    private lazy var bgView: UIView = {
        return $0
    }(UIView())
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configView()
        configViewLocation()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func configView() {
        self.addSubview(bgView)
    }
    func configViewLocation() {
        bgView.snp.makeConstraints { (make) in
            make.leading.equalTo(0)
            make.right.equalToSuperview().offset(0)
            make.top.equalToSuperview()
            make.bottom.equalToSuperview().priority(.low)
            make.height.equalTo(0)
        }
    }
    
    func change(height: CGFloat) {
        bgView.snp.updateConstraints { (make) in
            make.height.equalTo(height)
        }
    }
}
