  //
//  FundViewController.swift
//  Spending Management
//
//  Created by CNTT on 5/12/23.
//  Copyright © 2023 fit.tdc. All rights reserved.
//

import UIKit

class FundViewController:   UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    //
    @IBOutlet weak var btnNapTien: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblTongTien: UILabel!
 
    //Database
    private var dao:DatabaseLayer?
    //
    private var fundList = [Fund]()
    
    private var fund:Fund?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //button
        btnNapTien.layer.cornerRadius = 20
        //tableView
        tableView.rowHeight = 80
        tableView.dataSource = self
        tableView.delegate = self
        // khởi tạo cho dao
        dao = DatabaseLayer()
        //đọc dữ liệu từ database vào fund list
        dao?.getAllFunds(funds: &fundList)
        //Xoá toàn bộ dữ liệu
        //dao?.deleteTables()
        // Lấy tổng số tiền từ cơ sở dữ liệu
        let totalAmount = dao?.fetchTotalAmount() ?? 0.0
        
        // Hiển thị tổng số tiền đã lấy được
        lblTongTien.text = formatCurrency(amount: totalAmount)


    }
    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fundList.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let reuseCell = "FundTableViewCell"
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: reuseCell, for: indexPath)as? FundTableViewCell{
            
            //lấy dữ liệu để đổ vào table View
            let fund = fundList[indexPath.row]
            
            //đổ dữ liệu từ fund vào cell
            cell.lblLichSu.text = fund.getLichSu()
            cell.lblTien.text = String(formatCurrency(amount: fund.getSoTien()))
            cell.lblDate.text = fund.getDataTime()
            return cell
        }
        
        fatalError("Khong tao duoc cell")
        // Configure the cell...
    }
    
    // MARK: - Navigation
    @IBAction func unwindFromMealDetailController(segue:UIStoryboardSegue){
        // ép kiểu ngược
        //Khi ấn nút Xác nhận của NapTienViewController
        if let source1 = segue.source as? NapTienViewController{
            if let fund = source1.fund{
                //Ghi vào database
                let _ = dao?.insert(fund: fund)
                // Cộng tiền vào tổng tiền
                addAmountToTotal(amount: fund.getSoTien())
                 //Update the tongTien label
                //nạp tiền
                updateTotalAmountDisplay()
                //
                //updateTongTienLabel(newTongTien: fund.getSoTien())
                //
                // Thêm Chi Tiết mới vào đầu của fundList
                fundList.insert(fund, at: 0)
                let indexPath = IndexPath(row: 0, section: 0)
                tableView.insertRows(at: [indexPath], with: .top)
            }
        }
    }
    //Click Chi Tiết
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //Xác định dường di chuyển của màn hình
        if let destination = segue.destination as? ChiTietViewController {
            if let segName = segue.identifier {
                if segName == "showChiTiet" {
//                    print("Chi tiết giao dịch")
                    destination.navigationType = .showChiTiet
                    //lấy vị trí tương ứng với cell duoc chon
                    if let selectedIndexPath = tableView.indexPathForSelectedRow{
                        destination.fund = fundList[selectedIndexPath.row]
                    }
                }
            }
            else {
                print("Chưa đặt tên cho segue")
            }
        }
    }
    // Tính tổng tiền
    func updateTongTienLabel(newTongTien: Double) {
        //xoá chuỗi "đ" trên lblTongTien
        let tongTienWithoutCurrency = removeCurrencySymbol(from: lblTongTien.text ?? "0")
        if let tongTien = Double(tongTienWithoutCurrency) {
            let tongTienMoi = tongTien + newTongTien
            //Định dạng tiền vn
            
            let formattedPrice = formatCurrency(amount: tongTienMoi)
            

            lblTongTien.text = "\(formattedPrice)"
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
    //xoá chuỗi "đ" sau tổng tiền
    func removeCurrencySymbol(from string: String) -> String {
        var stringWithoutCurrency = string
        stringWithoutCurrency = stringWithoutCurrency.trimmingCharacters(in: .whitespacesAndNewlines)
        stringWithoutCurrency = stringWithoutCurrency.replacingOccurrences(of: "đ", with: "")
        stringWithoutCurrency = stringWithoutCurrency.replacingOccurrences(of: ".", with: "")
        return stringWithoutCurrency
    }
    //hàm hiển thị tổng tiền
    func updateTotalAmountDisplay() {
        // Lấy tổng số tiền từ cơ sở dữ liệu
        let totalAmount = dao?.fetchTotalAmount() ?? 0.0
        
        // Hiển thị tổng số tiền đã lấy được
        lblTongTien.text = formatCurrency(amount: totalAmount)
    }
    // Định nghĩa hàm addAmountToTotal
    func addAmountToTotal(amount: Double) {
        // Thực hiện cộng tiền vào tổng tiền
        if let dao = dao {
            let success = dao.addAmountToTotal(amount: amount)
            if success {
                print("Cộng tiền vào tổng tiền thành công")
            } else {
                print("Không thể cộng tiền vào tổng tiền")
            }
        }
    }
    
    
    
}
