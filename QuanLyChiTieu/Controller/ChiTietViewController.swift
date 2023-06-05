//
//  ChiTietViewController.swift
//  Spending Management
//
//  Created by CNTT on 5/7/23.
//  Copyright © 2023 fit.tdc. All rights reserved.
//

import UIKit

class ChiTietViewController: UIViewController {

    //MARK:
    
    @IBOutlet weak var lblLichSu: UILabel!
    @IBOutlet weak var lblTien: UILabel!
    
    @IBOutlet weak var lblThoiGian: UILabel!
    
    @IBOutlet weak var lblGhiChu: UILabel!
    
    	
    //Định nghĩa biến emun cho đường đi của màn hình
    enum NavigationType {
        case showChiTiet
    }
    
    var fund:Fund?
    
    var navigationType:NavigationType = .showChiTiet
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //lấy dữ liệu list meal truyền sang từ table view
        if let fund = fund {
            lblLichSu.text = fund.getLichSu()
            // Định dạng giá trị tiền thành đơn vị tiền VN
            let soTien = formatCurrency(amount: fund.getSoTien())
            lblTien.text = String(soTien)
            lblThoiGian.text = fund.getDataTime()
            lblGhiChu.text = fund.getGhiChu()
        }
        
    }
    // Định dạng giá trị tiền thành đơn vị tiền VN
    func formatCurrency(amount: Double) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 0
        numberFormatter.groupingSeparator = "."
        
        let formattedAmount = numberFormatter.string(from: NSNumber(value: amount)) ?? ""
        return formattedAmount
    }
    
    
    // MARK: - Navigation
     
     
     @IBAction func btnCancel(_ sender: Any) {
        // Chuyển đến màn hình trước đó
        self.navigationController?.popViewController(animated: true)
     }
     
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    

}
