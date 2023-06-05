//
//  DanhMucViewController.swift
//  DoAn
//
//  Created by CNTT on 5/24/23.
//  Copyright © 2023 fit.tdc. All rights reserved.
//

import UIKit

class ThemGiaoDichViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,UITextFieldDelegate, UINavigationControllerDelegate{
    
    
    @IBOutlet weak var edtSoTien: UITextField!
    @IBOutlet weak var edtGhiChu: UITextField!
    @IBOutlet weak var imgDanhMuc: UIImageView!
    
    @IBOutlet weak var lblLoai: UILabel!
    @IBOutlet weak var myCollectionView: UICollectionView!
    
    @IBOutlet weak var switchLoaiOutlet: UISwitch!
    
    //Định nghĩa biến emun cho đường đi của màn hình
    enum NavigationType {
        case addThuNhap
        case addChiPhi
    }
    
    var navigationTypeThuNhap:NavigationType = .addThuNhap
    var navigationTypeChiPhi:NavigationType = .addChiPhi
    
    @IBAction func switchLoai(_ sender: UISwitch) {
        isSwitchOn = sender.isOn
        myCollectionView.reloadData()
        
        if isSwitchOn {
            lblLoai.text = "Thu nhập"
            itemList.sort { $0.Loai < $1.Loai }
            
        } else {
            lblLoai.text = "Chi phí"
            itemList.sort { $0.Loai > $1.Loai }
            
        }
    }
    
    //chuẩn bị dữ liệu và gửi đi trước khi chuyển màn hình
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let ghiChu = edtGhiChu.text ?? ""
        let soTien = edtSoTien.text ?? ""
        let img = self.imgDanhMuc.image
        let loai = isSwitchOn ? 1 : 2
        //print(loai)
        sGiaoDich = GiaoDich(id: -1, ghiChu: ghiChu, hinhDanhMuc: img!, soTien: Int(soTien)!, loai: loai)
        
    }
    
    @IBAction func btnCancel(_ sender: Any) {
        if navigationTypeThuNhap == .addThuNhap {
            print("ThuNhap")
            //Quay về màn hình trước
            dismiss(animated: true, completion: nil)
        }
        else if navigationTypeChiPhi == .addChiPhi{
            print("ChiPhi")
            // Chuyển đến màn hình trước đó
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    
    //Tạo đối tượng giao dịch
    var sGiaoDich:GiaoDich?
    //id: -1, ghiChu : "empty", hinhDanhMuc: UIImage(named: "1")!, soTien: 1, loai: 1
    //
    var isSwitchOn: Bool = true
    var itemList = [DanhMuc]()
    var color:UIColor = UIColor(red: 0/255, green: 55/255, blue: 55/255, alpha: 1)
    
    var id:Int = -1
    
    //Khai bao database
    private var dao:DatabaseLayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //
        edtSoTien.delegate = self
        edtGhiChu.delegate = self
        // Khoi tao cho dao
        dao = DatabaseLayer()
        
        // Doc du lieu tu database vao mealList
        dao?.getAllDanhMuc(DanhMucList: &itemList)
        myCollectionView.reloadData()
        if switchLoaiOutlet.isOn {
            lblLoai.text = "Thu nhập"
            itemList.sort { $0.Loai < $1.Loai }
        }
        else{
            lblLoai.text = "Chi phí"
            itemList.sort { $0.Loai > $1.Loai }
            
        }
        
    }
    
    
    
    func layCounLoai1() -> Int{
        var count:Int = 0
        for item in itemList {
            if item.Loai == 1{
                count += 1
            }
        }
        return count
    }
    func layCounLoai2() -> Int{
        var count:Int = 0
        for item in itemList {
            if item.Loai == 2{
                count += 1
            }
        }
        return count
        
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // Trả về số lượng section
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //#warning Incomplete implementation, return the number of items
        if isSwitchOn {
            return layCounLoai1()
        }
        else{
            return layCounLoai2()
        }
        //return itemList.count
    }
    
    //delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //print("Called")
        edtSoTien.resignFirstResponder()
        edtGhiChu.resignFirstResponder()
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        sGiaoDich?.SoTien = Int(edtSoTien.text!)!
        sGiaoDich?.GhiChu = edtGhiChu.text!
        updateSaveState()
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        //btnSave.isEnabled = false
    }
    
    private func updateSaveState() {
        let ghiChu = edtGhiChu.text ?? ""
        let soTien = edtSoTien.text ?? ""
        
        //btnSave.isEnabled = !ghiChu.isEmpty || !soTien.isEmpty
    }
    
    //tạo cell danh muc
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let reuseCell = "DanhMucCollectionViewCell"
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseCell, for: indexPath) as? DanhMucCollectionViewCell {
            
            let danhMuc = itemList[indexPath.row]
            
            if (isSwitchOn && danhMuc.Loai == 1) || (!isSwitchOn && danhMuc.Loai == 2) {
                cell.lblDanhMuc.text = danhMuc.TenDanhMuc
                cell.btnDanhMuc.backgroundColor = danhMuc.MauSac
                cell.btnDanhMuc.setImage(danhMuc.HinhDanhMuc, for: .normal)
                cell.btnDanhMuc.layer.cornerRadius = 45
                cell.btnDanhMuc.tag = indexPath.row
                cell.btnDanhMuc.addTarget(self, action: #selector(play), for: .touchUpInside)
            }
            else {
                cell.lblDanhMuc.text = ""
                cell.btnDanhMuc.backgroundColor = .clear
                cell.btnDanhMuc.setImage(nil, for: .normal)
                cell.btnDanhMuc.layer.cornerRadius = 0
                cell.btnDanhMuc.tag = 0
                cell.btnDanhMuc.removeTarget(nil, action: nil, for: .allEvents)
            }
            
            return cell
        }
        // Configure the cell
        fatalError("Khong tao duoc cell")
    }
    
    
    
    @objc func play(sender:UIButton)
    {
        imgDanhMuc.backgroundColor = sender.backgroundColor
        imgDanhMuc.image = sender.currentImage
        sGiaoDich?.HinhDanhMuc = sender.currentImage!
        
    }
    
}


  

