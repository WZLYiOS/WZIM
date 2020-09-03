//
//  WZIMChatTableViewCell.swift
//  WZLY
//
//  Created by qiuqixiang on 2020/8/26.
//  Copyright © 2020 我主良缘. All rights reserved.
//

import UIKit

// MARK - 聊天详情基础cell
public class WZIMChatTableViewCell: WZIMBaseTableViewCell {

    public override func configView() {
       super.configView()
   }
   
    public override func configViewLocation() {
       super.configViewLocation()
   }
   
    public override func reload(model: WZIMMessageProtocol, cDelegate: WZIMTableViewCellDelegate) {
       super.reload(model: model, cDelegate: cDelegate)
       let img = bubbleImageView.image
       bubbleImageView.image = img?.wzStretchableImage()
    
   }
}

/// 角度设置
extension UIImage {
    
    func wzStretchableImage() -> UIImage {
        let lelft = Int(floor(self.size.width/2))
        let top = Int(floor(self.size.height/2+5))
       return self.stretchableImage(withLeftCapWidth: lelft, topCapHeight: top)
    }
}


