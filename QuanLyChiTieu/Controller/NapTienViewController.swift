//
//  NapTienViewController.swift
//  Spending Management
//
//  Created by CNTT on 5/7/23.
//  Copyright © 2023 fit.tdc. All rights reserved.
//

import UIKit
import Foundation
class NapTienViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate{

    //MARK: Properties
    @IBOutlet weak var edtNapTien: UITextField!
    @IBOutlet weak var tvGhiChu: UITextView!

    let lichSu = "Nạp tiền"
    let tongTien = 0.0
    var fund:Fund?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        edtNapTien.delegate = self
    }
    
    //MARK: Textfield's Delegation Functions
    //B2: Định nghĩa các hàm uỷ quyền của TextField
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //print("Called")
        edtNapTien.resignFirstResponder()
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("\(edtNapTien.text!)")
    }
    //MARK: TextView processing
    
    func textViewShouldReturn(_ textView: UITextView) -> Bool {
        //print("Called")
        tvGhiChu.resignFirstResponder()
        return true
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        print("\(tvGhiChu.text!)")
    }
    //MARK: Navigation
    
    //chuẩn bị dữ liệu và gửi đi trước khi chuyển màn hình
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //print("Chuẩn bị dữ liệu trước khi chạy")
        //Tạo biến fund mới và lưu trong biến thành phần fund của lớp
        guard let tien = Double(edtNapTien.text ?? "") else {
            // Hiển thị thông báo lỗi nếu không thể chuyển đổi giá trị của textField thành số nguyên
            return
        }
        let ghiChu = tvGhiChu.text ?? ""
        // Lưu ngày giờ được chọn vào thuộc tính
        // Tạo đối tượng DateFormatter để định dạng ngày giờ
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm dd/MM/yyyy"
        
        // Sử dụng ngày giờ hiện tại
        let dateString = dateFormatter.string(from: Date())
        fund = Fund(soTien: tien,tongTien: tongTien , dateTime: dateString, ghiChu: ghiChu, lichSu: lichSu)
        
    }
    
    @IBAction func btnCancel(_ sender: UIBarButtonItem) {
        // Chuyển đến màn hình trước đó
        self.navigationController?.popViewController(animated: true)
    }
}
