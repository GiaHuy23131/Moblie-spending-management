//
//  DatabaseLayer.swift
//  Spending Management
//
//  Created by CNTT on 5/23/23.
//  Copyright © 2023 fit.tdc. All rights reserved.
//

import Foundation
import UIKit
import os.log
class DatabaseLayer {
    //Mark: Database's Properties
    private let DB_NAME = "funds.sqlite"
    private let DB_PATH:String?
    private let database:FMDatabase?
    
    //MARK: Table's Properties
    //1. Fund Table
    private let FUND_TABLE_NAME = "funds"
    private let FUND_ID = "_id"
    private let FUND_SO_TIEN = "value"
    private let FUND_TONG_TIEN = "total_amount"
    private let FUND_DATETIME = "datetime"
    private let FUND_GHI_CHU = "ghichu"
    private let FUND_LICH_SU = "lichsu"

    //1. Danh muc Table
    private let DANHMUC_TABLE_NAME = "DanhMuc"
    private let DANHMUC_ID = "_id"
    private let DANHMUC_NAME = "tenhdanhmuc"
    private let DANHMUC_CHITIEU = "chitieu"
    private let DANHMUC_LOAI = "loai"
    private let DANHMUC_IMAGE = "image"
    //private let DANHMUC_MAUSAC = "mausac"
    private let DANHMUC_RED = "mausac_red"
    private let DANHMUC_GREEN = "mausac_green"
    private let DANHMUC_BLUE = "mausac_blue"
    
    //2.Giao dich table
    private let GIAODICH_TABLE_NAME = "GiaoDich"
    private let GIAODICH_ID = "_id"
    private let GIAODICH_GHICHU = "tenGD"
    private let GIAODICH_SOTIIEN = "soTien"
    private let GIAODICH_LOAI = "loaiGD"
    private let GIAODICH_IMAGE = "imageGD"
    
    //MARK: Contructors
    init() {
        let directions:[String] = NSSearchPathForDirectoriesInDomains(.documentDirectory, .allDomainsMask, true)
        //Khởi tạo DB_PATH
        DB_PATH = directions[0] + "/" + DB_NAME
        //Khởi tạo database
        database = FMDatabase(path: DB_PATH)
        //Thông báo cho người dùng tình trạng database
        if database != nil{
            //tạo bảng dữ liệu  cho database
            let _ = crateTables()
            let _ = createDanhMucTables()
            let _ = createGiaoDichTables()
            os_log("Database tạo thành công")
        }
        else{
            os_log("Database không tạo được")
        }
    }
    
    //****************************************************************
    //******* Định nghĩa các hàm primitives
    //****************************************************************
    
    // 1. Kiểm tra database có tồn tại hay không
    private func isDatabaseCreated()->Bool {
        return (database != nil) // khác nill return true
    }
    //2. Open database
    private func open()->Bool{
        var ok = false
        
        if isDatabaseCreated() {
            if database!.open(){
                ok = true
                os_log("Mở database thành công")
            }
            else{
                os_log("Không thể mở database")
            }
        }
        else{
            os_log("không thể mở database vì chưa tồn tại")
        }
        
        return ok
    }
    //3. Đóng database
    private func close ()->Bool{
        var ok = false
        
        if isDatabaseCreated() {
            if database!.close() {
                ok = true
                os_log("Đóng database thành công")
            }
            else{
                os_log("Không thể đóng database")
            }
        }
        return ok
    }
    
    //4. Tao cac bang du lieu
    private func createDanhMucTables() -> Bool {
        var ok = false
        // Cau lenh sql
        let sql = "CREATE TABLE \(DANHMUC_TABLE_NAME)("
            + DANHMUC_ID + " INTEGER PRIMARY KEY AUTOINCREMENT, "
            + DANHMUC_NAME + " TEXT, "
            + DANHMUC_CHITIEU + " INTEGER, "
            + DANHMUC_LOAI + " INTEGER, "
            + DANHMUC_IMAGE + " TEXT, "
            + DANHMUC_RED + " FLOAT, "
            + DANHMUC_GREEN + " FLOAT, "
            + DANHMUC_BLUE + " FLOAT)"
        
        // Thuc thi cau lenh sql
        if open() {
            if database!.executeStatements(sql) {
                ok = true
                os_log("Tao bang thanh cong")
            }else{
                os_log("Khong the tao bang danhmuc")
            }
        }
        
        return ok
        
    }
    
    //5. Tạo các bảng dữ liệu
    private func crateTables()->Bool {
        var ok = false
        //CÂU lệnh SQL
        let sql = "CREATE TABLE IF NOT EXISTS \(FUND_TABLE_NAME)("
            + FUND_ID + " INTEGER PRIMARY KEY AUTOINCREMENT, "
            + FUND_SO_TIEN + " DOUBLE, "
            + FUND_TONG_TIEN + " DOUBLE, "
            + FUND_DATETIME + " TEXT, "
            + FUND_GHI_CHU + " TEXT, "
            + FUND_LICH_SU + " TEXT)"
        //Thực thi câu lệnh sql
        if open() {
            if database!.executeStatements(sql) {
                ok = true
                os_log("Tạo bảng fund thành công")
            }
            else {
                os_log("Không thể tạo bảng funds")
            }
        }
        return ok
    }
    
    private func createGiaoDichTables() -> Bool {
        var ok = false
        // Cau lenh sql
        let sql = "CREATE TABLE \(GIAODICH_TABLE_NAME)("
            + GIAODICH_ID + " INTEGER PRIMARY KEY AUTOINCREMENT, "
            + GIAODICH_GHICHU + " TEXT, "
            + GIAODICH_SOTIIEN + " INTEGER, "
            + GIAODICH_LOAI + " INTEGER, "
            + GIAODICH_IMAGE + " TEXT)"
        
        // Thuc thi cau lenh sql
        if open() {
            if database!.executeStatements(sql) {
                ok = true
                os_log("Tao bang thanh cong")
            }else{
                os_log("Khong the tao bang danhmuc")
            }
        }
        
        return ok
        
    }
    //6. Xoá dữ liệu
    public func deleteTables() {
        let sql = "DROP TABLE IF EXISTS \(FUND_TABLE_NAME)"
        if open() {
            if database!.executeStatements(sql) {
                os_log("Xóa bảng thành công")
            } else {
                os_log("Không thể xóa bảng funds")
            }
            let _ = close()
        }
    }
    //****************************************************************
    //******* Định nghĩa các hàm primitives
    //****************************************************************
    
    //1. Insert fund vào database
    public func insert(fund:Fund)->Bool {
        var ok = false

        //Câu lệnh sql để insert dữ liệu vào database
        let sql = "INSERT INTO \(FUND_TABLE_NAME) ("
            + FUND_SO_TIEN + ", "
            + FUND_TONG_TIEN + ", "
            + FUND_DATETIME + ", "
            + FUND_GHI_CHU + ", "
            + FUND_LICH_SU + ")" + " VALUES (?, ?, ?, ?, ?)"
        //Thực hiện câu lệnh sql
        if open() {
            
            if database!.executeUpdate(sql, withArgumentsIn: [fund.getSoTien(),fund.getTongTien(), fund.getDataTime(), fund.getGhiChu(), fund.getLichSu()]) {
                // Cập nhật bảng để thêm cột total_amount (nếu cần)
                ok = true
                os_log("Thêm data fund thành công")
                
                let _ = close()
            }
        }
        else{
            os_log("Không ghi được data fund do không thể mở")
        }
        return ok
    }
    //2. đọc toàn bộ các fund từ database
    public func getAllFunds(funds: inout [Fund]) {
        let sql = "SELECT * FROM \(FUND_TABLE_NAME) ORDER BY \(FUND_DATETIME) DESC"
        //Thực hiện đọc dữ liệu
        if open() {
            var result:FMResultSet?
            //Xử lý ngoại lệ
            do {
                result = try database!.executeQuery(sql, values: nil)
            }
            catch {
                os_log("Lỗi khi đọc dữ liệu từ database")
            }

            //Xử lý kết quả đọc được
            if let result = result {
                while (result.next()) {
                    let soTien = result.double(forColumn: FUND_SO_TIEN)
                    let tongTien = result.double(forColumn: FUND_TONG_TIEN)
                    let dateTime = result.string(forColumn: FUND_DATETIME)  ?? ""
                    let ghiChu = result.string(forColumn: FUND_GHI_CHU)  ?? ""
                    let lichSu = result.string(forColumn: FUND_LICH_SU)  ?? ""

                    //Tạo biến meal đọc được
                    if let fund = Fund(soTien: Double(soTien),tongTien: Double(tongTien), dateTime: dateTime, ghiChu: ghiChu, lichSu: lichSu){
                        //Lưu vào mảng tham biến
                        funds.append(fund)
                    }
                }
            }
            let _ = close()
        }
    }
    //3. hiển thị tổng tiền từ database
    func fetchTotalAmount() -> Double {
        var totalAmount = 0.0
        
        // Câu lệnh SQL để lấy tổng số tiền từ bảng funds
        let sql = "SELECT \(FUND_TONG_TIEN) FROM \(FUND_TABLE_NAME)"
        
        // Mở kết nối đến cơ sở dữ liệu
        if open() {
            if let resultSet = database?.executeQuery(sql, withArgumentsIn: []) {
                if resultSet.next() {
                    totalAmount = resultSet.double(forColumn: FUND_TONG_TIEN)
                }
                resultSet.close()
            }
            let _ = close()
        }
        
        return totalAmount
    }

    //4. nạp tiền vào tổng tiền từ database
    func addAmountToTotal(amount: Double) -> Bool {
        var success = false
        
        // Câu lệnh SQL để nạp tiền vào tổng tiền
        let sql = "UPDATE \(FUND_TABLE_NAME) SET \(FUND_TONG_TIEN) = \(FUND_TONG_TIEN) + ?"
        
        // Mở kết nối đến cơ sở dữ liệu
        if open() {
            if database!.executeUpdate(sql, withArgumentsIn: [NSNumber(value: amount)]) {
                success = true
                os_log("Nạp tiền vào tổng tiền thành công")
            } else {
                os_log("Không thể nạp tiền vào tổng tiền: %@", database?.lastErrorMessage() ?? "")
            }
            let _ = close()
        } else {
            os_log("Không thể mở kết nối đến cơ sở dữ liệu")
        }
        
        return success
    }
    
    //
    //4. nạp tiền vào tổng tiền từ database
    func subAmountToTotal(amount: Double) -> Bool {
        var success = false
        
        // Câu lệnh SQL để nạp tiền vào tổng tiền
        let sql = "UPDATE \(FUND_TABLE_NAME) SET \(FUND_TONG_TIEN) = \(FUND_TONG_TIEN) - ?"
        
        // Mở kết nối đến cơ sở dữ liệu
        if open() {
            if database!.executeUpdate(sql, withArgumentsIn: [NSNumber(value: amount)]) {
                success = true
                os_log("Nạp tiền vào tổng tiền thành công")
            } else {
                os_log("Không thể nạp tiền vào tổng tiền: %@", database?.lastErrorMessage() ?? "")
            }
            let _ = close()
        } else {
            os_log("Không thể mở kết nối đến cơ sở dữ liệu")
        }
        
        return success
    }
    //MARK: sql cua bang danh muc
    //1. Insert DanhMuc vao database
    public func insertDanhMuc(danhMuc:DanhMuc) ->Bool {
        var ok = false
        // Chuyen anh thanh text truoc khi luu vao co so du lieu
        var strImage = ""
        let image = danhMuc.HinhDanhMuc
        let nsDataImage = image.pngData()! as NSData
        strImage = nsDataImage.base64EncodedString(options: .lineLength64Characters)
        
        // Cau lenh sql de insert du lieu vao database
        let sql = "INSERT INTO \(DANHMUC_TABLE_NAME) ("
            + DANHMUC_NAME + ", " + DANHMUC_CHITIEU + ", " + DANHMUC_LOAI + ", " + DANHMUC_IMAGE + ", " + DANHMUC_RED + ", " + DANHMUC_GREEN + ", " + DANHMUC_BLUE + ")"
            + "VALUES (?,?,?,?,?,?,?)"
        
        // Thuc hien cau lenh sql
        if open() {
            if database!.executeUpdate(sql, withArgumentsIn: [danhMuc.TenDanhMuc,danhMuc.ChiTieu,danhMuc.Loai,strImage,danhMuc.getRed(),danhMuc.getGreen(),danhMuc.getBlue()]) {
                ok = true
                os_log("Them danh muc thanh cong")
                let _ = close()
            }
            
        }else {
            os_log("Khong ghi duoc du lieu")
        }
        return ok
    }
    
    //2. Doc toan bo cac danh muc tu database
    public func getAllDanhMuc(DanhMucList: inout [DanhMuc]) {
        // Cau lenh sql
        let sql = "SELECT * FROM \(DANHMUC_TABLE_NAME) ORDER BY \(DANHMUC_LOAI) DESC"
        
        // Thuc hien doc du lieu
        if open() {
            var result:FMResultSet?
            
            // Xu ly ngoai le
            do {
                result = try database!.executeQuery(sql, values: nil)
            }
            catch {
                os_log("Loi khi doc du lieu tu databse")
            }
            
            
            // Xu ly ket qua doc duoc
            if let result = result {
                while (result.next()) {
                    let id = result.int(forColumn: DANHMUC_ID)
                    let name = result.string(forColumn: DANHMUC_NAME) ?? ""
                    
                    let chiTieu = result.int(forColumn: DANHMUC_CHITIEU)
                    let loai = result.int(forColumn: DANHMUC_LOAI)
                    let red = result.double(forColumn: DANHMUC_RED)
                    let green = result.double(forColumn: DANHMUC_GREEN)
                    let blue = result.double(forColumn: DANHMUC_BLUE)
                    
                    var image:UIImage? = nil
                    let strImage = result.string(forColumn: DANHMUC_IMAGE) ?? ""
                    if !strImage.isEmpty {
                        // Chuyen chuoi thanh anh
                        let dataImage = Data(base64Encoded: strImage, options: .ignoreUnknownCharacters)
                        image = UIImage(data: dataImage!)
                    }
                    
                    // Tao bien Meal doc duoc
                    //                    if let danhMuc = DanhMuc(id: Int(id), tenDanhMuc: name, hinhDanhMuc: image!, mauSac: UIColor(red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: 1), chiTieu: Int(chiTieu), loai: Int(loai)) {
                    //                        // Luu vao mang tham bien
                    //                        DanhMucList.append(danhMuc)
                    //                    }
                    let danhMuc = DanhMuc(id: Int(id), tenDanhMuc: name, hinhDanhMuc: image!, mauSac: UIColor(red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: 1), chiTieu: Int(chiTieu), loai: Int(loai))
                    // Luu vao mang tham bien
                    DanhMucList.append(danhMuc)
                    
                }
            }
            let _ = close()
        }
    }
    
    
    //3. Update DanhMuc vao database
    public func updateDanhMuc(danhMuc:DanhMuc, id:String) ->Bool {
        var ok = false
        // Chuyen anh thanh text truoc khi luu vao co so du lieu
        var strImage = ""
        let image = danhMuc.HinhDanhMuc
        let nsDataImage = image.pngData()! as NSData
        strImage = nsDataImage.base64EncodedString(options: .lineLength64Characters)
        
        // Cau lenh sql de UPDATE du lieu vao database
        let sql = "UPDATE \(DANHMUC_TABLE_NAME)" + " SET " + "\(DANHMUC_NAME)=?," + "\(DANHMUC_CHITIEU)=?," + "\(DANHMUC_LOAI)=?," + "\(DANHMUC_IMAGE)=?," + "\(DANHMUC_RED)=?," + "\(DANHMUC_GREEN)=?," + "\(DANHMUC_BLUE)=? " + "WHERE \(DANHMUC_ID)=?"
        
        
        // Thuc hien cau lenh sql
        if open() {
            if database!.executeUpdate(sql, withArgumentsIn: [danhMuc.TenDanhMuc,danhMuc.ChiTieu,danhMuc.Loai,strImage,danhMuc.getRed(),danhMuc.getGreen(),danhMuc.getBlue(),id]) {
                ok = true
                os_log("Sua danh muc thanh cong")
                let _ = close()
            }
            
        }else {
            os_log("Khong ghi duoc du lieu")
        }
        return ok
    }
    
    //4. Delete DanhMuc trong database
    public func deleteDanhMuc(id:String) ->Bool {
        var ok = false
        
        let sql = "DELETE FROM \(DANHMUC_TABLE_NAME) WHERE \(DANHMUC_ID)=?"
        
        
        // Thuc hien cau lenh sql
        if open() {
            if database!.executeUpdate(sql, withArgumentsIn: [id]) {
                ok = true
                os_log("Xoa danh muc thanh cong")
                let _ = close()
            }
            
        }else {
            os_log("Khong ghi duoc du lieu")
        }
        return ok
    }
    
    public func insertGiaoDich(giaoDich:GiaoDich) ->Bool {
        var ok = false
        // Chuyen anh thanh text truoc khi luu vao co so du lieu
        var strImage = ""
        let image = giaoDich.HinhDanhMuc
        let nsDataImage = image.pngData()! as NSData
        strImage = nsDataImage.base64EncodedString(options: .lineLength64Characters)
        
        // Cau lenh sql de insert du lieu vao database
        let sql = "INSERT INTO \(GIAODICH_TABLE_NAME) ("
            + GIAODICH_GHICHU + ", " + GIAODICH_SOTIIEN + ", " + GIAODICH_LOAI + ", " + GIAODICH_IMAGE + ")"
            + "VALUES (?,?,?,?)"
        
        // Thuc hien cau lenh sql
        if open() {
            if database!.executeUpdate(sql, withArgumentsIn: [giaoDich.GhiChu,giaoDich.SoTien,giaoDich.Loai,strImage]) {
                ok = true
                os_log("Them giao dich thanh cong")
                let _ = close()
            }
            
        }else {
            os_log("Khong ghi duoc du lieu")
        }
        return ok
    }
    
    //2. Doc toan bo cac danh muc tu database
    public func getAllGiaoDich(GiaoDichList: inout [GiaoDich]) {
        // Cau lenh sql
        let sql = "SELECT * FROM \(GIAODICH_TABLE_NAME) ORDER BY \(GIAODICH_LOAI) DESC"
        
        // Thuc hien doc du lieu
        if open() {
            var result:FMResultSet?
            
            // Xu ly ngoai le
            do {
                result = try database!.executeQuery(sql, values: nil)
            }
            catch {
                os_log("Loi khi doc du lieu tu databse")
            }
            
            
            // Xu ly ket qua doc duoc
            if let result = result {
                while (result.next()) {
                    let id = result.int(forColumn: GIAODICH_ID)
                    let name = result.string(forColumn: GIAODICH_GHICHU) ?? ""
                    
                    let soTien = result.int(forColumn: GIAODICH_SOTIIEN)
                    let loai = result.int(forColumn: GIAODICH_LOAI)
                    
                    var image:UIImage? = nil
                    let strImage = result.string(forColumn: GIAODICH_IMAGE) ?? ""
                    if !strImage.isEmpty {
                        // Chuyen chuoi thanh anh
                        let dataImage = Data(base64Encoded: strImage, options: .ignoreUnknownCharacters)
                        image = UIImage(data: dataImage!)
                    }
                    
                    // Tao bien Meal doc duoc
                    //                    if let danhMuc = DanhMuc(id: Int(id), tenDanhMuc: name, hinhDanhMuc: image!, mauSac: UIColor(red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: 1), chiTieu: Int(chiTieu), loai: Int(loai)) {
                    //                        // Luu vao mang tham bien
                    //                        DanhMucList.append(danhMuc)
                    //                    }
                    let giaoDich = GiaoDich(id: Int(id), ghiChu: name, hinhDanhMuc: image!, soTien: Int(soTien), loai: Int(loai))
                    // Luu vao mang tham bien
                    GiaoDichList.append(giaoDich)
                    
                }
            }
            let _ = close()
        }
    }
    
//    //4. chuyển từ tổng tiền database này vào tổng tiền của database khác
//    func transferAmountToAnotherTable(amount: Double, sourceTableName: String, sourceTotalColumnName: String, destinationTableName: String, destinationTotalColumnName: String) -> Bool {
//        var success = false
//
//        // Câu lệnh SQL để trừ tiền từ bảng nguồn
//        let deductSql = "UPDATE \(FUND_TABLE_NAME) SET \(FUND_TONG_TIEN) = \(FUND_TONG_TIEN) - ?"
//        // Câu lệnh SQL để cộng tiền vào bảng đích
//        let addSql = "UPDATE \(FUND_TABLE_QUAN_LI) SET \(FUND_TIEN_QUAN_LI) = \(FUND_TIEN_QUAN_LI) + ?"
//
//        // Mở kết nối đến cơ sở dữ liệu
//        if open() {
//            database!.beginTransaction()
//
//            // Trừ tiền từ bảng nguồn
//            if database!.executeUpdate(deductSql, withArgumentsIn: [NSNumber(value: amount)]) {
//                // Cộng tiền vào bảng đích
//                if database!.executeUpdate(addSql, withArgumentsIn: [NSNumber(value: amount)]) {
//                    success = true
//                    os_log("Chuyển tiền thành công")
//                    database!.commit()
//                } else {
//                    os_log("Không thể cộng tiền vào bảng đích: %@", database?.lastErrorMessage() ?? "")
//                    database!.rollback()
//                }
//            } else {
//                os_log("Không thể trừ tiền từ bảng nguồn: %@", database?.lastErrorMessage() ?? "")
//                database!.rollback()
//            }
//
//            let _ = close()
//        } else {
//            os_log("Không thể mở kết nối đến cơ sở dữ liệu")
//        }
//
//        return success
//    }
    

    
}
