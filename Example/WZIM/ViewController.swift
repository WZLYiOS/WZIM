//
//  ViewController.swift
//  WZIM
//
//  Created by qiuqixiang on 08/13/2020.
//  Copyright (c) 2020 qiuqixiang. All rights reserved.
//

import UIKit
import WZIM


class ViewController: UIViewController {

    
    var userId: String = ""
    
    private lazy var tableView: UITableView = {
        $0.delegate = self
        $0.dataSource = self
        $0.estimatedRowHeight = 80
        $0.rowHeight = UITableViewAutomaticDimension
        $0.tableFooterView = UIView()
        $0.tableHeaderView = UIView()
        
        $0.register(TestTableViewCell.self, forCellReuseIdentifier: "TestTableViewCell")
        $0.register(WZIMBaseTableViewCell.self, forCellReuseIdentifier: "WZIMTableViewCell")
        return $0
    }(UITableView())
    
    /// 底部tabbar输入框
    private lazy var textTabbarView: WZIMTextInputTabbar = {
        $0.delegate = self
        return $0
    }(WZIMTextInputTabbar())
    
    /// 更多视图
    private lazy var moreView: WZIMMoreView = {
        $0.backgroundColor = WZIMToolAppearance.hexadecimal(rgb: 0xF8F8F8)
        $0.delegate = self
        $0.dataArray = [
        WZIMMoreItem(image: "ToolBbar.bundle/ic_talk_keyboard", title: "相册"),
        WZIMMoreItem(image: "ToolBbar.bundle/ic_talk_keyboard", title: "拍照")]
        return $0
    }(WZIMMoreView())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
       
        
        WZIMConfig.menuItems =  ["复制"]
        
        DongtuStore.sharedInstance().delegate = self
        configView()
        configViewLocation()
    }

    func configView() {
        view.addSubview(tableView)
        view.addSubview(textTabbarView)
        textTabbarView.addMoreView(view: moreView)
    }
    func configViewLocation() {
        tableView.snp.makeConstraints { (make) in
            make.leading.equalTo(0)
            make.right.equalToSuperview()
            make.top.equalToSuperview()
        }
        
        textTabbarView.snp.makeConstraints { (make) in
            make.top.equalTo(tableView.snp.bottom).offset(10)
            make.leading.equalTo(0)
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }

}

// MARK - HBConversationViewController
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: WZIMBaseTableViewCell = tableView.dequeueReusableCell(withIdentifier: "TestTableViewCell", for: indexPath) as! WZIMBaseTableViewCell
//        cell.reload(model: self, publicDelegate: self, cDelegate: self)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}

extension ViewController: WZIMTableViewCellDelegate, WZIMTableViewCellPublicDelegate {
    func WZIMTableViewCell(cell: WZIMBaseTableViewCell, tap avatarImageView: UIImageView) {
        
    }
    
    func WZIMTableViewCell(cell: WZIMBaseTableViewCell, menuTitle: String) {
        debugPrint(menuTitle)
    }
    
    func WZIMTableViewCell(cell: WZIMBaseTableViewCell, set avatar: UIImageView) {
        
    }
}

/// MARK - WZIMTextInputTabbar
extension ViewController: WZIMTextInputTabbarDelegate {
    func textInputTabbar(tabbar: WZIMTextInputTabbar, replacementText text: String) {
        
    }
    
    func textInputTabbarDidChange(tabbar: WZIMTextInputTabbar) {
        
    }
    
    func textInputTabbar(tabbar: WZIMTextInputTabbar, emojiBtn: UIButton) {
        if emojiBtn.isSelected {
            DongtuStore.sharedInstance().attachEmotionKeyboard(toInput: tabbar.textInputView.textInput)
            return
        }
        DongtuStore.sharedInstance().switchToDefaultKeyboard()
    }
    
    func textInputTabbar(tabbar: WZIMTextInputTabbar, canPop: Bool) {
        
    }
    
    func userIdTextInputTabbar(tabbar: WZIMTextInputTabbar) -> String {
        return UserSession.shared.tokenConfig!.userId
    }
    
    func textInputTabbar(tabbar: WZIMTextInputTabbar, wavFilePath: String, mp3FilePath: String) {
        
    }
    
    func textInputTabbar(tabbar: WZIMTextInputTabbar, audioRecorder path: String, duration: Int) {
        
    }
    
    func textInputTabbar(tabbar: WZIMTextInputTabbar, audioRecorder error: Error) {
        
    }
    
    func textInputTabbar(tabbar: WZIMTextInputTabbar, audioPlayer error: Error) {
        
    }
    
    func textInputTabbar(tabbar: WZIMTextInputTabbar, audioPlayer flag: Bool) {
        
    }
}

/// MARK  - WZIMMoreViewDelegate
extension ViewController: WZIMMoreViewDelegate {
    func WZIMMoreViewDidSelect(moreView: WZIMMoreView, item: WZIMMoreItem) {
        
    }
}

/// MARK - DongtuStoreDelegate
extension ViewController: DongtuStoreDelegate {
    
    func didSelect(_ gif: DTGif) {
//        let message = conversation.getGifMenssage(gif: gif)
//        sendMessage(message: message)
    }
    
    func didSelect(_ emoji: DTEmoji) {
//        let message = conversation.getDTEmojiMessage(emoji: emoji)
//        sendMessage(message: message)
    }
    
    func didSend(withInput input: UIResponder & UITextInput) {
//        if textTabbarView.textInputView.textInput.text.count == 0 { return }
//        let message = conversation.getTextMessage(text: textTabbarView.textInputView.textInput.text)
//        textTabbarView.textInputView.textInput.text = ""
//        sendMessage(message: message)
    }
    
    func tapOverlay() {
        textTabbarView.closeEmojKeyboard()
    }
}
