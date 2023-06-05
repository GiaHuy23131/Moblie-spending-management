//
//  BackTableVC.swift
//  SideMenu
//
//  Created by CNTT on 5/29/23.
//  Copyright © 2023 fit.tdc. All rights reserved.
//

import Foundation
class BackTableVC: UITableViewController {
    
    var tableArray = [String]()
    
    
    
    override func viewDidLoad() {
        tableArray = ["BieuDo","Quy","DanhMuc"]
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: tableArray[indexPath.row], for: indexPath)
        cell.textLabel?.text = tableArray[indexPath.row]
        return cell
    }
    
}
