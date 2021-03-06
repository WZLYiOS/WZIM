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
import ImSDK
import Kingfisher

// MARK - 会话详情
@objcMembers
public class WZIMConversionViewController: UIViewController {

    /// 用户id
    var userId: String = ""
    
    /// 数据源
    private lazy var dataArray: WZMessageArray = {
        return $0
    }(WZMessageArray())
    
    private lazy var tableView: UITableView = {
        $0.separatorStyle = .none
        $0.rowHeight = 0
        $0.estimatedRowHeight = 0
        $0.tableFooterView = UIView()
        $0.dataSource = self
        $0.delegate = self
        $0.wz.debugLogEnabled(false)
        $0.backgroundColor = WZIMToolAppearance.hexadecimal(rgb: "0xF8F8F8")
        $0.wz.register(cellWithClass: WZIMFaceTableViewCell.self)
        $0.wzIMRegisterCell()
        $0.wz.pullToRefresh(target: self, refreshingAction: #selector(pullToRefresh))
        $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tableViewTapAction)))
        return $0
    }(UITableView())
    

    /// 底部tabbar输入框
    private lazy var textTabbarView: WZIMTextInputTabbar = {
        $0.delegate = self
        $0.moreView.delegate = self
        $0.moreView.reloadUI()
        return $0
    }(WZIMTextInputTabbar())
    
    /// 获取消息，用于下拉加载更多
    private var messageForGet: WZMessageProtocol? = nil
    
    deinit {
        debugPrint("消息控制器释放")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configView()
        configViewLocation()
        config()
        tableView.wz.beginRefreshing()
        UserSession.shared.imManager.setReadMessage(receiverId: userId, type: .c2c)
    }
    
    /// 配置基础
    func config() {
        view.backgroundColor = WZIMToolAppearance.hexadecimal(rgb: "0xF8F8F8")
        WZIMConfig.avatarSize = CGSize(width: 40, height: 40)
        WZIMConfig.bubbleEdge = UIEdgeInsets(top: 15, left: 10, bottom: 5, right: 10)
        DongtuStore.sharedInstance().delegate = self
    }

    func configView() {
        view.addSubview(tableView)
        view.addSubview(textTabbarView)
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
    
    @objc private func pullToRefresh() {
        
        UserSession.shared.imManager.getC2CMessages(receiverId: userId, cont: 10, last: messageForGet, sucess: { (list) in
            
            let tmpList = self.dataArray.insert(contentsOf: list.map { WZMessageData.msg($0) }, at: 0)
            self.tableView.wz.endRefreshing()
            self.tableView.reloadData()
            if self.messageForGet == nil{
                self.scrollToBottom(animated: false)
            }else{
                self.tableView.scrollToRow(at: IndexPath(row: tmpList.count, section: 0), at: .top, animated: false)
            }
            if list.count > 0 {
                self.messageForGet = list.first
            }
        }) { (code, msg) in
            self.tableView.wz.endRefreshing()
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
}

/// 扩展
extension WZIMConversionViewController {
    
    /// 发送消息
    func sendMessage(message: WZMessageProtocol, isResend: Bool = false) {
        
        tableView.beginUpdates()
        
        if isResend {
           let rows = dataArray.remove(message: .msg(message))
            tableView.deleteRows(at: rows.map({IndexPath(row: $0, section: 0)}), with: .fade)
        }
        /// 添加消息
        let indexPaths = dataArray.append(.msg(message))
        UserSession.shared.imManager.sendC2CMessage(receiverId: userId, message: message, pushInfo: nil, progress: { (progress) in
                        
            if let cell = self.tableView.cellForRow(at: indexPaths.last!) as? WZIMBaseTableViewCell         {
                cell.upload(progress: Float(progress))
            }
        }, sucess: {
            self.tableView.beginUpdates()
            self.tableView.reloadRows(at: indexPaths, with: .none)
            self.tableView.endUpdates()
        }) { (code, msg) in
            debugPrint("发送失败")
            self.tableView.beginUpdates()
            self.tableView.reloadRows(at: indexPaths, with: .none)
            self.tableView.endUpdates()
        }
        
        tableView.insertRows(at: indexPaths, with: .fade)
        tableView.endUpdates()
        scrollToBottom(animated: true)
    }
}

/// MAKR - UITableViewDelegate | UITableViewDataSource
extension WZIMConversionViewController: UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
 
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model = dataArray.array[indexPath.row]
        return tableView.wz.heightForIMCell(withClass: model.cellIdentifier, cacheByKey: model.cellIdentifierId) { (cell) in
            cell.pDelegate = self
            cell.upload(model: model, cDelegate: self)
        }
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.array.count
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = dataArray.array[indexPath.row]
        let cell:WZIMBaseTableViewCell  = tableView.wz.dequeueReusableCell(withClass: model.cellIdentifier)
        cell.pDelegate = self
        cell.upload(model: model, cDelegate: self)
        return cell
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
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
    public func textInputTabbar(isCanAudioRecorder tabbar: WZIMTextInputTabbar) -> Bool {
        return true
    }
    
    
    public func textInputTabbar(tabbar: WZIMTextInputTabbar, replacementText text: String) {
        if text.count == 0 { return }
        let message = UserSession.shared.imManager.wzCreateTextMessage(text: text)
        tabbar.textInputView.textInput.text = ""
        sendMessage(message: message)
    }
    
    public func textInputTabbarDidChange(tabbar: WZIMTextInputTabbar, animated: Bool) {
        scrollToBottom(animated: animated)
    }
    
    public func textInputTabbar(tabbar: WZIMTextInputTabbar, emojiBtn: UIButton) {
        
        if emojiBtn.isSelected {
            DongtuStore.sharedInstance().attachEmotionKeyboard(toInput: tabbar.textInputView.textInput)
            return
        }
        DongtuStore.sharedInstance().switchToDefaultKeyboard()
    }
    public func textInputTabbar(tabbar: WZIMTextInputTabbar, canPop: Bool) {
        
    }
    
    public func userIdTextInputTabbar(tabbar: WZIMTextInputTabbar) -> String {
        return UserSession.shared.tokenConfig!.userId
    }
    
    public func textInputTabbar(tabbar: WZIMTextInputTabbar, wavFilePath: String, mp3FilePath: String, isStop: Bool) {
        
    }
    
    public func textInputTabbar(tabbar: WZIMTextInputTabbar, audioRecorder path: String, duration: Int) {
        let message = UserSession.shared.imManager.wzCreateVoiceMessage(path: path, duration: duration)
        sendMessage(message: message)
    }
    
    public func textInputTabbar(tabbar: WZIMTextInputTabbar, audioRecorder error: Error) {
        
    }
    
    public func textInputTabbar(tabbar: WZIMTextInputTabbar, audioPlayer error: Error) {
        
    }
    
    public func textInputTabbar(tabbar: WZIMTextInputTabbar, player flag: Bool, path: String) {
        
    }
}

/// MARK - WZIMTableViewCellPublicDelegate
extension WZIMConversionViewController: WZIMTableViewCellDelegate, WZIMTableViewCellPublicDelegate {
    public func baseTableViewCell(cell: WZIMBaseTableViewCell, imageView: UIImageView, url: String, placeholder: UIImage?) {
        guard let urls = URL(string: url) else {
            return
        }
        let resource = ImageResource(downloadURL: urls)
        imageView.kf.setImage(with: resource, placeholder: placeholder)
    }
    
    public func baseTableViewCell(cell: WZIMBaseTableViewCell, tap avatarImageView: UIImageView) {
        
    }
    
    public func baseTableViewCell(cell: WZIMBaseTableViewCell, menuTitle: String) {
        
    }
    
    public func baseTableViewCell(cell: WZIMBaseTableViewCell, set avatar: UIImageView) {
        
    }
    
    public func baseTableViewCell(cell: WZIMBaseTableViewCell, resend btn: UIButton) {
        sendMessage(message: cell.message, isResend: true)
    }
}

/// MARK - DongtuStoreDelegate
extension WZIMConversionViewController: DongtuStoreDelegate {
    
    public func didSelect(_ gif: DTGif) {
        
        let model = WZIMFaceCustomModel()
        model.with = Int(gif.size.width)
        model.height = Int(gif.size.height)
        model.gifId = gif.imageId
        model.image = gif.mainImage
        
        let message = UserSession.shared.imManager.wzCreateGifMenssage(gif: model, name: gif.text)
        sendMessage(message: message)
    }
    
    public func didSelect(_ emoji: DTEmoji) {
        let message = UserSession.shared.imManager.wzCreateDTEmojiMessage(emojiCode: emoji.emojiCode!, emojiName: emoji.emojiName!)
        sendMessage(message: message)
    }
    
    public func didSend(withInput input: UIResponder & UITextInput) {
        if textTabbarView.textInputView.textInput.text.count == 0 { return }
        let message = UserSession.shared.imManager.wzCreateTextMessage(text: textTabbarView.textInputView.textInput.text)
        sendMessage(message: message)
        textTabbarView.clearTextInput()
    }
    
    public func tapOverlay() {
        textTabbarView.closeEmojKeyboard()
    }
}

/// MARK - WZIMMoreViewDelegate
extension WZIMConversionViewController: WZIMMoreViewDelegate {
    
    public func moreView(moreView: WZIMMoreView, select item: WZIMMoreItem) {
        switch item.title {
        case "相册":
            openAlbum()
        case "拍照":
            openCamera()
        case "文件":
            let vc = WZDocumentPickerViewController { [weak self](size, name, path) in
                guard let self = self else { return }
                self.sendMessage(message: UserSession.shared.imManager.wzCreateFileMessage(name: name, path: path))
            }
            WZRoute.present(vc)
        default: break
        }
    }
    
    public func listMoreView(moreView: WZIMMoreView) -> [WZIMMoreItem] {
        return [WZIMMoreItem(image: "im_ic_talk_photo", title: "拍照"),
                WZIMMoreItem(image: "im_ic_talk_shot", title: "相册"),
                WZIMMoreItem(image: "im_ic_talk_shot", title: "文件"),
                WZIMMoreItem(image: "im_ic_talk_shot", title: "3"),
                WZIMMoreItem(image: "im_ic_talk_shot", title: "4"),
                WZIMMoreItem(image: "im_ic_talk_shot", title: "5"),
                WZIMMoreItem(image: "im_ic_talk_shot", title: "6"),
                WZIMMoreItem(image: "im_ic_talk_shot", title: "7"),
                WZIMMoreItem(image: "im_ic_talk_shot", title: "8"),
                WZIMMoreItem(image: "im_ic_talk_shot", title: "9")]
    }
}

/////MARK - UIDocumentPickerDelegate
//extension WZIMConversionViewController: UIDocumentPickerDelegate {
//
//    public func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
//        controller.dismiss(animated: true, completion: nil)
//    }
//    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
//
//        WZIMToolAppearance.getDocumentCoordinate(url: url) { (size, name, path) in
//            debugPrint("选的文件路径")
//        }
//        controller.dismiss(animated: true, completion: nil)
//    }
//}


// MARK - 开启相册选取
extension WZIMConversionViewController: TZImagePickerControllerDelegate {
    
    func openAlbum() {
        let vc = TZImagePickerController(maxImagesCount: 1, delegate: self)!
        vc.modalPresentationStyle = .fullScreen
        vc.naviBgColor = UIColor.white
        vc.navigationBar.tintColor = UIColor.black
        vc.naviTitleColor = UIColor.black
        vc.barItemTextColor = WZIMToolAppearance.hexadecimal(rgb: "0x7c7c7c")
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
        
        for item in photos {
            self.sendImageMessage(image: item)
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
        
        let message = UserSession.shared.imManager.wzCreateImageMessage(image: image)
        self.sendMessage(message: message)
    }
}

/// MARK  - WZMMessageArrayDelegate
extension WZIMConversionViewController: WZMMessageArrayDelegate{

    public func messageArray(arry: WZMMessageArray, date: Date) -> WZMessageProtocol {
        return UserSession.shared.imManager.wzCreateTimeMessage(date: date)
    }
    
    public func messageArray(arry: WZMMessageArray, remove row: [Int]) {
        tableView.deleteRows(at: row.map({IndexPath(row: $0, section: 0)}), with: .fade)
    }
}

/// MARK - WZIMVoiceTableViewCellDelegate
extension WZIMConversionViewController: WZIMVoiceTableViewCellDelegate{
    
    public func isPlayIngVoiceTableViewCell(cell: WZIMVoiceTableViewCell, elem: WZIMVoiceProtocol) -> Bool {
        
        if textTabbarView.audioPlayer.isSame(path: elem.wzPath()) {
            return textTabbarView.audioPlayer.isPlaying()
        }
        return false
    }
    
    public func startPlayerVoiceTableViewCell(cell: WZIMVoiceTableViewCell, path: String) {
        textTabbarView.audioPlayer.play(aFilePath: path)
        tableView.reloadData()
    }
}

// MARK - WZIMConversionViewController
extension WZIMConversionViewController: WZIMFileTableViewCellDelagte {
    public func fileTableViewCell(diselect cell: WZIMFileTableViewCell, path: String) {
        
        let xx = WZDocumentInteractionController(path: path, controller: self)
        xx.presentPreview(animated: true)
    }
}
