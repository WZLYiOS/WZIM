//
//  WZServiceConversionViewController.swift
//  WZLY
//
//  Created by qiuqixiang on 2020/11/10.
//  Copyright © 2020 我主良缘. All rights reserved.
//

import UIKit
import WZIM
import WZRefresh
import WZRoute
import TZImagePickerController
import UITableView_FDTemplateLayoutCell

/// MARK -  客服
@objcMembers
class WZServiceConversionViewController: UIViewController {

    /// 客户id
    var userId: String = "service"
    
    /// 数据源
    lazy var dataArray: WZMessageArray = {
        return $0
    }(WZMessageArray())
    
    /// 获取消息，用于下拉加载更多
    private var messageForGet: WZMessageProtocol? = nil
    
    /// 列表
    lazy var tableView: UITableView = {
        $0.separatorStyle = .none
        $0.rowHeight = 0
        $0.estimatedRowHeight = 0
        $0.tableFooterView = UIView()
        $0.dataSource = self
        $0.delegate = self
       
        $0.wzIMRegisterCell()
        $0.wz.register(cellWithClass: WZIMFaceTableViewCell.self)
        $0.wz.register(cellWithClass: WZMessageRemindTableViewCell.self)
//        $0.wz.register(cellWithClass: WZIMServiceQuestionTableViewCell.self)
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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationItem.title = "在线客服"
        configView()
        configViewLocation()
        config()
        pullToRefresh()
        requestFormSerVerce()
        addObserver()
    }
    
    /// 配置基础
    func config() {
//        view.backgroundColor = ColorAppearance.hexadecimal(rgb: 0xF8F8F8)
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
        
        UserSession.shared.emManager.loadMessagesStartFromId(receiveId: userId, messageId: messageForGet?.wzMessageId ?? "", count: 20) { [weak self](list) in
            guard let self = self else { return }
            let tmpList = self.dataArray.insert(contentsOf: list.map { WZMessageData.msg($0) }, at: 0)
            self.tableView.reloadData()
            if self.messageForGet == nil{
                self.scrollToBottom(animated: false)
            }else{
                self.tableView.scrollToRow(at: IndexPath(row: tmpList.count, section: 0), at: .top, animated: false)
            }
            if list.count > 0 {
                self.messageForGet = list.first
            }
            self.tableView.wz.endRefreshing()
        } fail: { (error) in
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
    
    /// 发送消息
    func sendMessage(message: WZMessageProtocol, isResend: Bool = false) {
        
        tableView.beginUpdates()
        
        if isResend {
            let rows = dataArray.remove(message: .msg(message))
            tableView.deleteRows(at: rows.map({IndexPath(row: $0, section: 0)}), with: .fade)
        }
        /// 添加消息
        let indexPaths = dataArray.append(.msg(message))
        
        UserSession.shared.emManager.sendMessage(message: message) { (progress) in
            if let cell = self.tableView.cellForRow(at: indexPaths.last!) as? WZIMBaseTableViewCell {
                cell.upload(progress: Float(CGFloat(progress)))
            }
        } aCompletionBlock: { [weak self](result, error) in
            guard let self = self else { return }
            if let cell = self.tableView.cellForRow(at: indexPaths.last!) as? WZIMBaseTableViewCell {
                self.updataCell(cell: cell, model: .msg(message))
            }
        }
        tableView.insertRows(at: indexPaths, with: .fade)
        tableView.endUpdates()
        scrollToBottom(animated: true)
    }
    
    /// 请求数据
    private func requestFormSerVerce() {
        
    }
    
    /// 添加监听
    private func addObserver() {
        
        /// 监听新消息
        NotificationCenter.default.rx.notification(Notification.Name.wzIMTask.getMessage(notif: .msg(userId)))
        .subscribe(onNext: { [weak self] result in
            guard let self = self else { return }
            guard let message = result.object as? WZMessageProtocol else { return }

            let indexPaths = self.dataArray.append(.msg(message))
            self.tableView.beginUpdates()
            self.tableView.insertRows(at: indexPaths, with: .fade)
            self.tableView.endUpdates()
            self.scrollToBottom(animated: true)
            UserSession.shared.imManager.setReadMessage(receiverId: self.userId, type: .c2c)
        }).disposed(by: rx.disposeBag)
    
        NotificationCenter.default.rx.notification(Notification.Name.wzIMTask.getMessage(notif: .readReceipt(userId))).subscribe(onNext: { [weak self] (result) in
            guard let self = self else { return }
            guard (result.object as? WZMessageProtocol) != nil else { return }
            self.tableView.reloadData()
        }).disposed(by: rx.disposeBag)
    }
}

/// MAKR - UITableViewDelegate | UITableViewDataSource
extension WZServiceConversionViewController: UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
 
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model = dataArray.array[indexPath.row]
        return tableView.fd_heightForCell(withIdentifier: String(describing: model.cellIdentifier), cacheBy: indexPath) { [weak self](cell) in
            guard let self = self else { return }
            self.updataCell(cell: cell as! WZIMBaseTableViewCell, model: model)
        }
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.array.count
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = dataArray.array[indexPath.row]
        let cell = tableView.wz.dequeueReusableCell(withClass: model.cellIdentifier, for: indexPath)
        updataCell(cell: cell as! WZIMBaseTableViewCell, model: model)
        return cell
    }
    
    /// 更新数据
    func updataCell(cell: WZIMBaseTableViewCell, model: WZMessageData) {
        cell.fd_isTemplateLayoutCell = true
        cell.pDelegate = self
        cell.upload(model: model, cDelegate: self)
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

/// MARK - WZIMTableViewCellPublicDelegate
extension WZServiceConversionViewController: WZIMTableViewCellDelegate, WZIMTableViewCellPublicDelegate {
    
    public func baseTableViewCell(cell: WZIMBaseTableViewCell, tap avatarImageView: UIImageView){
        if cell.message.loaction == .lelft {
            return
        }
       
    }
    
    public func baseTableViewCell(cell: WZIMBaseTableViewCell, menuTitle: String) {
        
    }
    
    public func baseTableViewCell(cell: WZIMBaseTableViewCell, set avatar: UIImageView) {
        
    }
    
    public func baseTableViewCell(cell: WZIMBaseTableViewCell, resend btn: UIButton) {
        sendMessage(message: cell.message, isResend: true)
    }
}

/// MARK - WZIMMoreViewDelegate
extension WZServiceConversionViewController: WZIMMoreViewDelegate {
    
    public func moreView(moreView: WZIMMoreView, select item: WZIMMoreItem) {
        switch item.title {
        case "相册":
            openAlbum()
        case "拍照":
            openCamera()
        default: break
        }
    }
    
    public func listMoreView(moreView: WZIMMoreView) -> [WZIMMoreItem] {
        return  [WZIMMoreItem(image: "im_ic_talk_photo", title: "相册"),
                 WZIMMoreItem(image: "im_ic_talk_shot", title: "拍照")]
    }
}

/// MARK - 开启相册选取
extension WZServiceConversionViewController: TZImagePickerControllerDelegate {
    
    func openAlbum() {
        let vc = TZImagePickerController(maxImagesCount: 1, delegate: self)!
        vc.modalPresentationStyle = .fullScreen
        vc.naviBgColor = UIColor.white
        vc.navigationBar.tintColor = UIColor.black
        vc.naviTitleColor = UIColor.black
//        vc.barItemTextColor = ColorAppearance.hexadecimal(rgb: 0x7c7c7c)
        vc.allowPickingVideo = false
        vc.allowPickingImage = true
        vc.allowPickingOriginalPhoto = true
        vc.statusBarStyle = .default
        WZRoute.present(vc)
    }
    
    public func tz_imagePickerControllerDidCancel(_ picker: TZImagePickerController!) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    public func imagePickerController(_ picker: TZImagePickerController!, didFinishPickingPhotos photos: [UIImage]!, sourceAssets assets: [Any]!, isSelectOriginalPhoto: Bool) {
        
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
        
        WZIMPictureTableViewCell.storeDisk(imageData: UIImageJPEGRepresentation(image, 1)!) { [weak self](path) in
            guard let self = self else { return }
            let message = UserSession.shared.emManager.createImageMessage(receiveId: self.userId, image: image)
            self.sendMessage(message: message)
        }
    }
}



/// MARK - HBIMTextInputTabbarDelegate
extension WZServiceConversionViewController: WZIMTextInputTabbarDelegate {
    
    /// 回车
    public func textInputTabbar(tabbar: WZIMTextInputTabbar, replacementText text: String) {
        let message = UserSession.shared.emManager.createTextMessage(receiveId: userId, text: text)
        sendMessage(message: message)
    }
    
    /// 内容输入
    public func textInputTabbarDidChange(tabbar: WZIMTextInputTabbar, animated: Bool){
        scrollToBottom(animated: animated)
    }
    
    /// 表情键盘事件
    public func textInputTabbar(tabbar: WZIMTextInputTabbar, emojiBtn: UIButton){
        if emojiBtn.isSelected {
            DongtuStore.sharedInstance().attachEmotionKeyboard(toInput: tabbar.textInputView.textInput)
            return
        }
        DongtuStore.sharedInstance().switchToDefaultKeyboard()
    }
    
    /// 是否可返回
    public func textInputTabbar(tabbar: WZIMTextInputTabbar, canPop: Bool){
    }
    /// 获取用户id
    public func userIdTextInputTabbar(tabbar: WZIMTextInputTabbar) -> String{
        return UserSession.shared.emManager.currentUserId()
    }
    
    /// 录音结束
    public func textInputTabbar(tabbar: WZIMTextInputTabbar, audioRecorder path: String, duration: Int){
        let message = UserSession.shared.emManager.createVoiceMessage(receiveId: userId, localPath: path, duration: duration)
        sendMessage(message: message)
    }
    
    /// 录音错误
    public func textInputTabbar(tabbar: WZIMTextInputTabbar, audioRecorder error: Error){
//        WZToast.showError(withStatus: error.localizedDescription)
    }
    
    /// 音频播放失败
    public func textInputTabbar(tabbar: WZIMTextInputTabbar, audioPlayer error: Error){
        
    }
    
    /// 音频播放成功
    public func textInputTabbar(tabbar: WZIMTextInputTabbar, player flag: Bool){
        
    }
}


/// MARK - DongtuStoreDelegate
extension WZServiceConversionViewController: DongtuStoreDelegate {
    
    public func didSelect(_ gif: DTGif) {
        let model = WZIMFaceCustomModel()
        model.with = Int(gif.size.width)
        model.height = Int(gif.size.height)
        model.gifId = gif.imageId
        model.image = gif.mainImage
//        WZToast.showText(withStatus: "此消息暂不支持发送")
//        let message = UserSession.shared.imManager.wzCreateGifMenssage(gif: model, name: gif.text)
//        sendMessage(message: message)
//        scrollToBottom(animated: true)
    }
    
    public func didSelect(_ emoji: DTEmoji) {
//        WZToast.showText(withStatus: "此消息暂不支持发送")
//        let message = UserSession.shared.imManager.wzCreateDTEmojiMessage(emojiCode: emoji.emojiCode!, emojiName: emoji.emojiName!)
//        sendMessage(message: message)
//        scrollToBottom(animated: true)
    }
    
    public func didSend(withInput input: UIResponder & UITextInput) {
        if textTabbarView.textInputView.textInput.text.count == 0 { return }
        let message = UserSession.shared.emManager.createTextMessage(receiveId: userId, text:  textTabbarView.textInputView.textInput.text)
        sendMessage(message: message)
        textTabbarView.clearTextInput()
    }
    
    public func tapOverlay() {
        textTabbarView.closeEmojKeyboard()
    }
}

/// MARK - WZIMVoiceTableViewCellDelegate
extension WZServiceConversionViewController: WZIMVoiceTableViewCellDelegate{
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
