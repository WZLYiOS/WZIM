//
//  ViewController.swift
//  WZIM
//
//  Created by qiuqixiang on 08/13/2020.
//  Copyright (c) 2020 qiuqixiang. All rights reserved.
//

import UIKit
import WZIM
import ImSDK

class ViewController: UIViewController, WZIMTableViewCellDelegate {

    
    var userId: String = ""
    
    private lazy var tableView: UITableView = {
        $0.delegate = self
        $0.dataSource = self
        $0.estimatedRowHeight = 80
        $0.rowHeight = UITableViewAutomaticDimension
        $0.tableFooterView = UIView()
        $0.tableHeaderView = UIView()
        $0.backgroundColor = WZIMToolAppearance.hexadecimal(rgb: 0xF5F5F5)
        $0.register(WZIMVideoInviteTableViewCell.self, forCellReuseIdentifier: "TestTableViewCell")
        return $0
    }(UITableView())
    

    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
        configViewLocation()
    }

    func configView() {
        view.addSubview(tableView)
    }
    func configViewLocation() {
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }

}

// MARK - HBConversationViewController
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TestTableViewCell", for: indexPath) as! WZIMVideoInviteTableViewCell
        cell.pDelegate = self
        cell.reload(model: self, cDelegate: self)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}

extension ViewController: WZIMTableViewCellPublicDelegate {
    func baseTableViewCell(cell: WZIMBaseTableViewCell, tap avatarImageView: UIImageView) {
        
    }
    
    func baseTableViewCell(cell: WZIMBaseTableViewCell, menuTitle: String) {
        
    }
    
    func baseTableViewCell(cell: WZIMBaseTableViewCell, set avatar: UIImageView) {
        
    }
    
    func baseTableViewCell(cell: WZIMBaseTableViewCell, resend btn: UIButton) {
        
    }
}

extension ViewController: WZIMMessageProtocol {
    func uploadElem(elem: WZMessageElem) {
        
    }
    
    
    func wzStatus() -> WZIMMessageStatus {
        return .fail
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
        return ""
    }
    
    func wzTimestamp() -> Date {
        return Date()
    }
    
    func wzGetConversation() -> WZIMConversationProcotol {
        return TIMManager.sharedInstance()!.getConversationList()!.first!
    }
    
    func wzConvertToImportedMsg() {
        
    }
    
    func wzSetSender(sender: String) {
        
    }
    
    func wzLoaction() -> WZMessageLocation {
        return .lelft
    }
    
    var wzCustomInt: Int {
        get {
            return 0
        }
        set(newValue) {
            
        }
    }
    
    var wzCustomData: Data? {
        get {
            return Data()
        }
        set(newValue) {
            
        }
    }
    
    func wzCurrentElem() -> WZMessageElem? {
        return nil
    }
    
    
}
