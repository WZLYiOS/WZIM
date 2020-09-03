//
//  WZIMConversionViewController.swift
//  WZLY
//
//  Created by qiuqixiang on 2020/8/19.
//  Copyright © 2020 我主良缘. All rights reserved.
//

import UIKit
import WZIM
import WZRoute
import WZRefresh
import TZImagePickerController
import WZUIExtension

// MARK - 会话详情
final class WZIMConversionViewController: UIViewController {

    /// 用户id
    var userId: String = ""
    
    /// 数据源
    fileprivate var dataArray: [WZIMMessageProtocol] = []
    
    fileprivate lazy var tableView: UITableView = {
        $0.separatorStyle = .none
        $0.rowHeight = UITableViewAutomaticDimension
        $0.estimatedRowHeight = 80
        $0.tableFooterView = UIView()
        $0.dataSource = self
        $0.delegate = self
        $0.backgroundColor = WZIMToolAppearance.hexadecimal(rgb: 0xF8F8F8)
        $0.wz.register(cellWithClass: WZIMBaseTableViewCell.self)
        $0.wz.register(cellWithClass: WZIMPictureTableViewCell.self)
        $0.wz.register(cellWithClass: WZIMTextTableViewCell.self)
        $0.wz.register(cellWithClass: WZIMVoiceTableViewCell.self)
        $0.wz_pullToRefresh(target: self, refreshingAction: #selector(pullToRefresh))
        $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tableViewTapAction)))
        return $0
    }(UITableView())
    
    /// 创建会话
    private lazy var conversation: WZIMConversationProcotol = {
        return UserSession.shared.getConversation(type: .c2c, userId: userId)
    }()
    
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
        WZIMMoreItem(image: "im_ic_talk_photo", title: "相册"),
        WZIMMoreItem(image: "im_ic_talk_shot", title: "拍照")]
        return $0
    }(WZIMMoreView())
    
    deinit {
        debugPrint("消息控制器释放")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configView()
        configViewLocation()
        config()
        tableView.wz_beginRefreshing()
    }
    
    /// 配置基础
    func config() {
        view.backgroundColor = WZIMToolAppearance.hexadecimal(rgb: 0xF8F8F8)
        WZIMConfig.avatarSize = CGSize(width: 40, height: 40)
        WZIMConfig.bubbleEdge = UIEdgeInsets(top: 15, left: 10, bottom: 5, right: 10)
        DongtuStore.sharedInstance().delegate = self
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
    
    @objc func pullToRefresh() {
        
        conversation.wzGetMessage(cont: 50, last: dataArray.first, sucess: { [weak self](list) in
            guard let self = self else { return }
            
            self.dataArray.insert(contentsOf: list, at: 0)
            self.tableView.wz_endRefreshing()
            self.tableView.reloadData()
        }) { (code, msg) in
            
        }
    }
    
    /// 滚动到底部
    func scrollToBottom(animated: Bool) {
        let finalRow = max(0, tableView.numberOfRows(inSection: 0)-1)
        if (0 == finalRow) {
            return
        }
        let tempIndexPath = IndexPath(row: tableView.numberOfRows(inSection: 0)-1, section: 0)
        tableView.scrollToRow(at: tempIndexPath, at: .bottom, animated: animated)
    }
    
    /// 发送消息
    func sendMessage(message: WZIMMessageProtocol) {
        
        dataArray.append(message)
        let indexPath = IndexPath(row: dataArray.count - 1, section: 0)
        conversation.wzSendMessage(message: message, sucess: {
            self.tableView.beginUpdates()
            self.tableView.reloadRows(at: [indexPath], with: .none)
            self.tableView.endUpdates()
        }) { (code, msg) in
            debugPrint("发送失败")
//            self.tableView.reloadRows(at: [indexPath], with: .none)
        }
        tableView.beginUpdates()
        tableView.insertRows(at: [indexPath], with: .fade)
        tableView.endUpdates()
    }
}

/// MAKR - UITableViewDelegate | UITableViewDataSource
extension WZIMConversionViewController: UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
 
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = dataArray[indexPath.row]
        let cell:WZIMBaseTableViewCell  = tableView.wz.dequeueReusableCell(withClass: model.getCellIdentifier()) as! WZIMBaseTableViewCell
        cell.pDelegate = self
        cell.reload(model: model, cDelegate: self)
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if tableView.panGestureRecognizer.numberOfTouches > 0 {
            textTabbarView.hideKeyboard()
        }
    }
    
    @objc func tableViewTapAction(tap: UITapGestureRecognizer) {
        textTabbarView.hideKeyboard()
    }
}

/// MARK - HBIMTextInputTabbarDelegate
extension WZIMConversionViewController: WZIMTextInputTabbarDelegate {

    func textInputTabbar(tabbar: WZIMTextInputTabbar, replacementText text: String) {
        if text.count == 0 { return }
        let message = conversation.wzGetTextMessage(text: text)
        tabbar.textInputView.textInput.text = ""
        sendMessage(message: message)
    }
    
    func textInputTabbarDidChange(tabbar: WZIMTextInputTabbar, animated: Bool) {
        scrollToBottom(animated: animated)
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

/// MARK - WZIMTableViewCellPublicDelegate
extension WZIMConversionViewController: WZIMTableViewCellDelegate, WZIMTableViewCellPublicDelegate {
    
    func WZIMTableViewCell(cell: WZIMBaseTableViewCell, tap avatarImageView: UIImageView) {
        
    }
    
    func WZIMTableViewCell(cell: WZIMBaseTableViewCell, menuTitle: String) {
        
    }
    
    func WZIMTableViewCell(cell: WZIMBaseTableViewCell, set avatar: UIImageView) {
        
    }
}

/// MARK - DongtuStoreDelegate
extension WZIMConversionViewController: DongtuStoreDelegate {
    
    func didSelect(_ gif: DTGif) {
        
        let model = WZIMFaceCustomModel()
//        model.gifId = gif.
        
        
        let message = conversation.wzGetGifMenssage(git: model, name: gif.text)
        sendMessage(message: message)
    }
    
    func didSelect(_ emoji: DTEmoji) {
        let message = conversation.wzGetDTEmojiMessage(emojiCode: emoji.emojiId!, emojiName: emoji.emojiName!)
        sendMessage(message: message)
    }
    
    func didSend(withInput input: UIResponder & UITextInput) {
        if textTabbarView.textInputView.textInput.text.count == 0 { return }
        let message = conversation.wzGetTextMessage(text: textTabbarView.textInputView.textInput.text)
        sendMessage(message: message)
        textTabbarView.clearTextInput()
    }
    
    func tapOverlay() {
        textTabbarView.closeEmojKeyboard()
    }
}

/// MARK - WZIMMoreViewDelegate
extension WZIMConversionViewController: WZIMMoreViewDelegate {
    func WZIMMoreViewDidSelect(moreView: WZIMMoreView, item: WZIMMoreItem) {
        switch item.title {
        case "相册":
            openAlbum()
        case "拍照":
            openCamera()
        default: break
        }
    }
}

// MARK - 开启相册选取
extension WZIMConversionViewController: TZImagePickerControllerDelegate {
    
    func openAlbum() {
        let vc = TZImagePickerController(maxImagesCount: 1, delegate: self)!
        vc.modalPresentationStyle = .fullScreen
        vc.naviBgColor = UIColor.white
        vc.navigationBar.tintColor = UIColor.black
        vc.naviTitleColor = UIColor.black
        vc.barItemTextColor = WZIMToolAppearance.hexadecimal(rgb: 0x7c7c7c)
        vc.allowPickingVideo = false
        vc.allowPickingImage = true
        vc.allowPickingOriginalPhoto = true
        vc.statusBarStyle = .default
        self.present(vc, animated: true, completion: nil)
    }
    
    func tz_imagePickerControllerDidCancel(_ picker: TZImagePickerController!) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: TZImagePickerController!, didFinishPickingPhotos photos: [UIImage]!, sourceAssets assets: [Any]!, isSelectOriginalPhoto: Bool) {
        
        for item in assets {
            TZImageManager.default()?.getOriginalPhotoData(with: (item as! PHAsset), completion: { [weak self] (data, info, isDegraded) in
                guard let self = self else { return }
                self.sendImageMessage(image: UIImage(data: data!)!)
            })
        }
    }
    
    /// 打开相机
    func openCamera() {
//        WZPhotoHeadPicker.openWZImagePickerCamera(allowsEditing: false, isNeedBeauty: false, isUploadHeaderImg: false) { [weak self] (image, url, key) in
//            guard let self = self else { return }
//            self.sendImageMessage(image: image)
//        }
    }
    
    /// 发送图片消息
    func sendImageMessage(image: UIImage) {
        
//        let item = WZQiNiuUploadItem()
//        item.type = .im
//        item.obj = image
//        item.params.userid = UserSession.shared.userInfo!.user.userid
//        item.compleSucessBlock = { (key, url) in
//
//        }
//        item.compleFailBlock = { (msg) in
//        }
        /// 导入SDwebimage
//        let path = "\(Environment.apiUrl)\(item.params.name)"
//        SDImageCache.shared.store(image, forKey: path, completion: nil)
//        let message = conversation.getImageMessage(url: path, name: item.params.name, image: image)
//        conversation.wzSaveMessage(message: message, sender: "wzly_\(UserSession.shared.userInfo!.user.userid)", isRead: false)
        
//        dataArray.append(message)
        tableView.reloadData()
//        WZQiNiuUploadQueue.shared.put(items: [item])
    }
}
