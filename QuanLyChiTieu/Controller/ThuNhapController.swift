//
//  ThuNhapController.swift
//  QuanLyChiTieu
//
//  Created by CNTT on 5/28/23.
//  Copyright © 2023 fit.tdc. All rights reserved.
//

import UIKit
import Charts

class ThuNhapController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var lblTongTien: UILabel!
    
    @IBOutlet weak var pieChart: PieChartView!
    
    
    @IBOutlet weak var btnAdd: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    var listGiaoDich = [GiaoDich]()
    
    var dsChiPhi:[String] = []
    
    
    
    
    private var fundList = [Fund]()
    
    private var dao:DatabaseLayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dao = DatabaseLayer()
        dao?.getAllGiaoDich(GiaoDichList: &listGiaoDich)
        //
        updateTotalAmountDisplay()
        btnAdd.layer.cornerRadius = 30
        tableView.rowHeight = 80
        tableView.dataSource = self
        tableView.delegate = self
        // Do any additional setup after loading the view.
        var tien = [Double]()
        //
        //dsChiPhi = ["tien nha", "Tien an", "Tien mua Sam"]
        for giaoDich in listGiaoDich {
            
                dsChiPhi.append(giaoDich.GhiChu)
                tien.append(Double(giaoDich.SoTien))
           
        }
        
        
     
        
        setPieChartView(name: dsChiPhi, value: tien)
        // Do any additional setup after loading the view.
        // khởi tạo cho dao
       
        
        // Lấy tổng số tiền từ cơ sở dữ liệu
        let totalAmount = dao?.fetchTotalAmount() ?? 0.0
        
        // Hiển thị tổng số tiền đã lấy được
        lblTongTien.text = formatCurrency(amount: totalAmount)
        
//        btnMenu.target = self.revealViewController()
//        btnMenu.action = #selector(SWRevealViewController.revealToggle(_:))
//        self.view.addGestureRecognizer((self.revealViewController()?.panGestureRecognizer())!)
        
    }
    
    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listGiaoDich.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let reuseCell = "ThuNhapTableCell"
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: reuseCell, for: indexPath)as? ChiPhiTableViewCell{
            
            //lấy dữ liệu để đổ vào table View
            let giaoDich = listGiaoDich[indexPath.row]
           
                //đổ dữ liệu từ chiPhi vào cell
            if giaoDich.Loai == 1 {
                cell.lblTen.text = "Thu Nhap"
                cell.lblTien.text = String(giaoDich.SoTien)
                //cell.lblDate.text = giaoDich.GhiChu
            }
            else{
                cell.lblTen.text = "Chi phi"
                cell.lblTien.text = String(giaoDich.SoTien)
                //cell.lblDate.text = giaoDich.GhiChu
            }
            
            
            //đổ dữ liệu từ chiPhi vào cell
            
            
            return cell
            
        }
        
        fatalError("Khong tao duoc cell")
        // Configure the cell...
    }
    
    // MARK: - Navigation
    @IBAction func unwindFromChiPhiDetailController(segue:UIStoryboardSegue){
        // ép kiểu ngược
        //Khi ấn nút Xác nhận của NapTienViewController
        if let source1 = segue.source as? ThemGiaoDichViewController{
            if let giaoDich = source1.sGiaoDich{
                    //Ghi vào database
                    let _ = dao?.insertGiaoDich(giaoDich: giaoDich)
                    // Cộng tiền vào tổng tiền
                    
                if giaoDich.Loai == 1 {
                    addAmountToTotal(amount: Double(giaoDich.SoTien))
                }
                else{
                    submountToTotal(amount: Double(giaoDich.SoTien))
                }
                    //Update the tongTien label
                    //nạp tiền
                    updateTotalAmountDisplay()
                    //
                    //updateTongTienLabel(newTongTien: fund.getSoTien())
                    //
                    // Thêm Chi Tiết mới vào đầu của fundList
                    listGiaoDich.insert(giaoDich, at: 0)
                    let indexPath = IndexPath(row: 0, section: 0)
                    tableView.insertRows(at: [indexPath], with: .top)
                
            }
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //Xác định dường di chuyển của màn hình
        if let destination = segue.destination as? ThemGiaoDichViewController {
            if let segName = segue.identifier {
                if segName == "addThuNhap" {
                    print("Thu Nhap1")
                     destination.navigationTypeThuNhap = .addThuNhap
                }
                else if segName == "addChiPhi" {
                    print("Chi Phi1")
                    destination.navigationTypeChiPhi = .addChiPhi
                }
            }
            else {
                print("Chưa đặt tên cho segue")
            }
        }
        
        
    }

    //// Định nghĩa hàm addAmountToTotal
    func submountToTotal(amount: Double) {
        // Thực hiện cộng tiền vào tổng tiền
        if let dao = dao {
            let success = dao.subAmountToTotal(amount: amount)
            if success {
                print("Tru tiền vào tổng tiền thành công")
            } else {
                print("Không thể Tru tiền vào tổng tiền")
            }
        }
    }
    //
    //MARK:ham bo tro
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
    //
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
    
    //
    //hàm hiển thị tổng tiền
    func updateTotalAmountDisplay() {
        // Lấy tổng số tiền từ cơ sở dữ liệu
        let totalAmount = dao?.fetchTotalAmount() ?? 0.0
        
        // Hiển thị tổng số tiền đã lấy được
        lblTongTien.text = formatCurrency(amount: totalAmount)
    }
    //MARK: cai dat bieu do
    func setPieChartView(name:[String], value:[Double]) {
        var pieArray:[ChartDataEntry] = []
        for i in 0..<name.count{
            let data:ChartDataEntry = ChartDataEntry(x: Double(i), y: value[i])
            pieArray.append(data)
        }
        let color:[UIColor] = [#colorLiteral(red: 1, green: 0.3435138905, blue: 0.1785498445, alpha: 1), #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1), #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1), #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1), #colorLiteral(red: 0.1764705926, green: 0.01176470611, blue: 0.5607843399, alpha: 1), #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1), #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1), #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)]
        let pieDataSet:PieChartDataSet = PieChartDataSet(values: pieArray, label: "Thu Nhap")
        let pieData:PieChartData = PieChartData(dataSet: pieDataSet)
        pieDataSet.colors = color
        pieChart.data = pieData
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
