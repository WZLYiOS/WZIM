//
//  TestTableViewCell.swift
//  WZIMProtocol_Example
//
//  Created by qiuqixiang on 2020/8/11.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import WZIM

class TestTableViewCell: WZIMTableViewCell {

    /// 文字内容
    private lazy var contentLabel: UILabel = {
        $0.numberOfLines = 0
        return $0
    }(UILabel())
    
    override func configView() {
        super.configView()
        bubbleImageView.addSubview(contentLabel)
        
        let xx = UILongPressGestureRecognizer(target: self, action: #selector(bubbleImageViewTap))
        xx.minimumPressDuration = 1
        xx.numberOfTouchesRequired = 1
        bubbleImageView.addGestureRecognizer(xx)
    }
    
    override func configViewLocation() {
        super.configViewLocation()
        
        let maxWidth = 200
        contentLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(16)
            make.right.equalToSuperview().offset(-16)
            make.top.equalToSuperview().offset(15)
            make.bottom.lessThanOrEqualTo(-15)
            make.width.lessThanOrEqualTo(maxWidth)
        }
    }
    
    override func reload(model: WZIMMessageProtocol, publicDelegate: WZIMTableViewCellPublicDelegate, cDelegate: WZIMTableViewCellDelegate) {
        super.reload(model: model, publicDelegate: publicDelegate, cDelegate: cDelegate)
        contentLabel.text = "萨克哈大可接受的卡的哈肯定会卡收到货阿莎看的哈看的哈快速点击哈可点击哈看"
    }
    
    @objc private func bubbleImageViewTap(recognizer: UILongPressGestureRecognizer) {
            if recognizer.state == .ended{
                return
            }else if recognizer.state == .began{
                setMenuItems()
            }
        }
        
        /// 多功能菜单
        private func setMenuItems(){
            self.becomeFirstResponder()
            // 如果 Menu 已经被创建那就不再重复创建 menu
            if UIMenuController.shared.isMenuVisible, WZIMConfig.menuItems.count == 0{
                return
            }
            
        
            let frame = bubbleImageView.frame
            let menu = UIMenuController.shared
            menu.arrowDirection = .default
            menu.menuItems = [UIMenuItem(title: "复制", action: #selector(copyText))]
            menu.setTargetRect(frame, in: bubbleImageView.superview!)
            menu.setMenuVisible(true, animated: true)
        }
        
        @objc private func copyText(){
            debugPrint("xxxx")
    //        pDelegate.WZIMTableViewCell(cell: self, menuItem: item)
        }
        
        // MARK: - 必须实现的两个方法
        // 重写返回
        open override var canBecomeFirstResponder: Bool {
            return true
        }
        // 可以响应的方法
        open override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
            if action == UIMenuController.shared.menuItems?.first?.action {
                return true
            }
            return false
        }
}
