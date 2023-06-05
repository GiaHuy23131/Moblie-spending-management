//
//  DanhMucDetailViewController.swift
//  DoAn
//
//  Created by CNTT on 5/24/23.
//  Copyright © 2023 fit.tdc. All rights reserved.
//

import UIKit

class DanhMucDetailViewController: UIViewController, UINavigationControllerDelegate  {
    
    @IBOutlet weak var detailCollectionView: UICollectionView!
    
    
    @IBOutlet weak var lblLoai: UILabel!
    @IBOutlet weak var edtTenDanhMuc: UITextField!
    @IBOutlet weak var imgDanhMuc: UIImageView!
    @IBOutlet weak var edtChiTieu: UITextField!
    
    
    
    
    @IBAction func btnColorRed(_ sender: UIButton) {
        imgDanhMuc.backgroundColor = sender.backgroundColor
        sDanhMuc.MauSac = sender.backgroundColor!
    }
    @IBAction func btnColorGreen(_ sender: UIButton) {
        imgDanhMuc.backgroundColor = sender.backgroundColor
        sDanhMuc.MauSac = sender.backgroundColor!
    }
    @IBAction func btnColorYellow(_ sender: UIButton) {
        imgDanhMuc.backgroundColor = sender.backgroundColor
        sDanhMuc.MauSac = sender.backgroundColor!
    }
    @IBAction func btnColorBlue(_ sender: UIButton) {
        imgDanhMuc.backgroundColor = sender.backgroundColor
        sDanhMuc.MauSac = sender.backgroundColor!
    }
    
    
    
    @IBOutlet weak var btnColor0: UIButton!
    @IBAction func btnColorAtcion0(_ sender: UIButton) {
        imgDanhMuc.backgroundColor = sender.backgroundColor
        sDanhMuc.MauSac = sender.backgroundColor!
    }
    
    
    @IBOutlet weak var btnNewColor: UIButton!
    @IBAction func btnCustomColorAction(_ sender: Any) {
        let color = self.storyboard?.instantiateViewController(withIdentifier: "ColorViewController") as! ColorViewController
        
        
        color.danhMuc = sDanhMuc
        //color.navigationType = .editDanhMuc
        
        
        //                home.danhMuc.append(itemList[indexpath1.row])
        //        detail.danhMuc = itemList
        //        detail.sIconList = iconList
        
        self.navigationController?.pushViewController(color, animated: false)
        
        
    }
    
    @IBOutlet weak var btnSave: UIBarButtonItem!
    @IBAction func btnSave(_ sender: Any) {
        switch navigationType {
        case .newDanhMuc:
            if let complete = dao?.insertDanhMuc(danhMuc: sDanhMuc){
                let main = self.storyboard?.instantiateViewController(withIdentifier: "DanhMucViewController") as! DanhMucViewController
                dao?.getAllDanhMuc(DanhMucList: &main.itemList)
                self.navigationController?.popToRootViewController(animated: false)
                
            }
            break
        case .editDanhMuc:
            if let complete = dao?.updateDanhMuc(danhMuc: sDanhMuc, id: String(sDanhMuc.Id)) {
                let main = self.storyboard?.instantiateViewController(withIdentifier: "DanhMucViewController") as! DanhMucViewController
                dao?.getAllDanhMuc(DanhMucList: &main.itemList)
                self.navigationController?.popViewController(animated: false)
            }
            break
        }
        
    }
    
    
    
    @IBAction func btnCancel(_ sender: Any) {
        let main = self.storyboard?.instantiateViewController(withIdentifier: "DanhMucViewController") as! DanhMucViewController
        
        self.navigationController?.popViewController(animated: false)
    }
    
    @IBOutlet weak var switchLoaiOutlet: UISwitch!
    @IBAction func switchLoai(_ sender: UISwitch) {
        if (sender.isOn) {
            lblLoai.text = "Thu nhập"
            sDanhMuc.Loai = 1
        }
        else {
            lblLoai.text = "Chi phí"
            sDanhMuc.Loai = 2
        }
    }
    
    
    @IBOutlet weak var btnXoaOutet: UIButton!
    @IBAction func btnXoa(_ sender: UIButton) {
        if let del = dao?.deleteDanhMuc(id: String(sDanhMuc.Id)) {
            self.navigationController?.popViewController(animated: false)
        }
    }
    
    
    var sDanhMuc = DanhMuc(id: -1, tenDanhMuc: "", hinhDanhMuc: UIImage(named: "1")!, mauSac: .red, chiTieu: 1, loai: 1)
    
    var danhMuc = [DanhMuc]()
    var sIconList = [UIImage]()
    var customColor:UIColor = .white
    
    
    enum NavigationType {
        case newDanhMuc
        case editDanhMuc
    }
    
    private var dao:DatabaseLayer?
    var navigationType:NavigationType = .newDanhMuc
    
    override func viewDidLoad() {
        
        layHinh()
        
        edtTenDanhMuc.delegate = self
        edtChiTieu.delegate = self
        
        // Khoi tao cho dao
        dao = DatabaseLayer()
        
        detailCollectionView.backgroundColor = .white
        btnColor0.backgroundColor = customColor
        
        
        if navigationType == .newDanhMuc{
            btnXoaOutet.isEnabled = false
        }
        
        
        let ppDanhMuc = sDanhMuc
        // doi ten tanh navigationbar
        navigationItem.title = ppDanhMuc.TenDanhMuc
        
        edtTenDanhMuc.text = ppDanhMuc.TenDanhMuc
        edtChiTieu.text = String(ppDanhMuc.ChiTieu)
        imgDanhMuc.image = ppDanhMuc.HinhDanhMuc
        imgDanhMuc.backgroundColor = ppDanhMuc.MauSac
        if (ppDanhMuc.Loai == 1) {
            switchLoaiOutlet.isOn = true
            lblLoai.text = "Thu nhập"
        }else  {
            switchLoaiOutlet.isOn = false
            lblLoai.text = "Chi phí"
        }
        
        
        
        
    }
    
    
    func layHinh(){
        for temp in 1..<64 {
            if let img:UIImage = UIImage(named: "\(temp)"){
                sIconList.append(img)
            }
        }
    }
    //    func xuLyMau() {
    //        btnColor.layer.cornerRadius = 10
    //    }
    
    
    
}

extension DanhMucDetailViewController: UITextFieldDelegate,UICollectionViewDelegate, UICollectionViewDataSource
{
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //print("Called")
        edtTenDanhMuc.resignFirstResponder()
        edtChiTieu.resignFirstResponder()
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        //print("\(edtMealName.text!)")
        navigationItem.title = edtTenDanhMuc.text
        sDanhMuc.TenDanhMuc = edtTenDanhMuc.text!
        sDanhMuc.ChiTieu = Int(edtChiTieu.text!)!
        updateSaveState()
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        btnSave.isEnabled = false
    }
    
    private func updateSaveState() {
        let tenDanhMuc = edtTenDanhMuc.text ?? ""
        let chiPhi = edtChiTieu.text ?? ""
        
        btnSave.isEnabled = !tenDanhMuc.isEmpty || !chiPhi.isEmpty
        
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // Trả về số lượng section
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sIconList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let reuseCell = "DanhMucDetailCollectionViewCell"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseCell, for: indexPath) as! DanhMucDetailCollectionViewCell
        
        cell.btnIcon.setImage(sIconList[indexPath.row], for: .normal)
        cell.btnIcon.layer.cornerRadius = 20
        cell.btnIcon.tag = indexPath.row
        cell.btnIcon.addTarget(self, action: #selector(play) , for: .touchUpInside)
        return cell
        
    }
    
    @objc func play(sender:UIButton)
    {
        imgDanhMuc.image = sender.currentImage
        sDanhMuc.HinhDanhMuc = sender.currentImage!
    }
    
    //MARK: - Navigation
    //    @IBAction func unwindFromColor(_ segue: UIStoryboardSegue) {
    //        if let source = segue.source as? ColorViewController {
    //            if let danhMuc = source.danhMuc {
    //                if danhMuc.Id == -1 {
    //                    if let color = source.sColor {
    //                        imgDanhMuc.backgroundColor = color
    //                        sDanhMuc.MauSac = color
    //                    }
    //                }
    //                else{
    //                    sDanhMuc = danhMuc
    //                    if let color = source.sColor {
    //                        imgDanhMuc.backgroundColor = color
    //                        sDanhMuc.MauSac = color
    //                    }
    //                }
    //            }
    //
    //        }
    //
    //    }
    
    
    
    
    
    
    //In a storyboard-based application, you will often want to do a little preparation before navigation
    //Chuan bi du lieu va gui di truoc khi chuyen man hinh
    //    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    //        if let btnBarItem = sender as? UIBarButtonItem {
    //            // Neu dung la btnSave
    //            if (btnBarItem === btnSave) {
    //                let ten = edtTenDanhMuc.text ?? "a" //Hoac la chuoi hoac la rong
    //                let hinh = imgDanhMuc.image
    //                let mau = imgDanhMuc.backgroundColor
    //                let chiTieu = Int(edtChiTieu.text ?? "0")
    //                let loai = (switchLoaiOutlet.isOn == true) ? 1 : 2
    //                sDanhMuc = DanhMuc(id: sDanhMuc.Id ,tenDanhMuc: ten, hinhDanhMuc: hinh!, mauSac: mau!, chiTieu: chiTieu!, loai: loai)
    //                //ppanhMuc = sDanhMuc!
    //            }
    //        }else if let btnColor = sender as? UIButton {
    //            // Neu dung la btnSave
    //            if (btnColor === btnNewColor) {
    //                let ten = edtTenDanhMuc.text ?? "a" //Hoac la chuoi hoac la rong
    //                let hinh = imgDanhMuc.image
    //                let mau = imgDanhMuc.backgroundColor
    //                let chiTieu = Int(edtChiTieu.text ?? "0")
    //                let loai = (switchLoaiOutlet.isOn == true) ? 1 : 2
    //                sDanhMuc = DanhMuc(id: sDanhMuc.Id ,tenDanhMuc: ten, hinhDanhMuc: hinh!, mauSac: mau!, chiTieu: chiTieu!, loai: loai)
    //                //ppanhMuc = sDanhMuc!
    //            }
    //        }
    //        else {
    //            // Tac nhan khong phai la UIBarButtonItem
    //            print("Chuyen sang man hinh khac")
    //        }
    //
    //    }
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
