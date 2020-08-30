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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
       
        WZIMConfig.lelftBubbleImage = UIImage(named: "ic_loveme_dialog_white")
        WZIMConfig.rightBubbleImage = UIImage(named: "ic_loveme_dialog_purple")
        WZIMConfig.menuItems =  ["复制"]
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

// MARK - HBConversationViewController
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: WZIMBaseTableViewCell = tableView.dequeueReusableCell(withIdentifier: "TestTableViewCell", for: indexPath) as! WZIMBaseTableViewCell
        cell.reload(model: self, publicDelegate: self, cDelegate: self)
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

extension ViewController: WZIMMessageProtocol {
    
    var wzCustomInt: Int {
        get {
            return 0
        }
        set(newValue) {
            
        }
    }
    
    var wzCustomData: Data {
        get {
            return Data()
        }
        set(newValue) {
            
        }
    }
    
    
    
    func wzStatus() -> WZIMMessageStatus {
        return .deleted
    }
    
    func wzIsReaded() -> Bool {
        return false
    }
    
    func wzRemove() -> Bool {
        return false
    }
    
    func wzSender() -> String {
        return ""
    }
    
    func wzMessageId() -> String {
        return "xxx"
    }
    
    func wzTimestamp() -> Date {
        return Date()
    }
    
    func wzGetConversation() -> WZIMConversationProcotol {
        return self
    }
    
    func wzConvertToImportedMsg() {
        
    }
    
    func wzSetSender(sender: String) {
        
    }
    
    func wzLoaction() -> WZMessageLocation {
        return .right
    }
    
    func wzListContent() -> NSMutableAttributedString {
        return NSMutableAttributedString(string: "1243")
    }
}
 

extension ViewController: WZIMConversationProcotol {
    func wzLastMessage() -> WZIMMessageProtocol? {
        return nil
    }
    
    func wzConversationType() -> WZIMConversationType {
        return .c2c
    }
    
    func wzReceiverId() -> String {
        return ""
    }
    
    func wzReadMessage(message: WZIMMessageProtocol?) {
        
    }
    
    func wzGetUnReadMessageNum() -> Int {
        return 1
    }
    
    func wzSendMessage(message: WZIMMessageProtocol, sucess: sucess, fail: fail) {
        
    }
    
    func wzGetMessage(cont: Int, last: WZIMMessageProtocol?, sucess: getMsgSucess, fail: fail) {
        
    }
    
    func wzGetUserInfo(forceUpdate: Bool, comple: @escaping (WZIMUserInfoProtocol) -> Void) {
        
    }
    
}


