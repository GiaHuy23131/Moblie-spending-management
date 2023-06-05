//
//  DanhMucViewController.swift
//  DoAn
//
//  Created by CNTT on 5/24/23.
//  Copyright © 2023 fit.tdc. All rights reserved.
//

import UIKit

class DanhMucViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var lblLoai: UILabel!
    @IBOutlet weak var myCollectionView: UICollectionView!
    
    @IBOutlet weak var switchLoaiOutlet: UISwitch!
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
    
    
    @IBAction func btnAdd(_ sender: UIBarButtonItem) {
        
        
        let detail = self.storyboard?.instantiateViewController(withIdentifier: "DanhMucDetailViewController") as! DanhMucDetailViewController
        
        self.navigationController?.pushViewController(detail, animated: false)
    }
    
    
    var isSwitchOn: Bool = true
    
    var itemList = [DanhMuc]()
    var color:UIColor = UIColor(red: 0/255, green: 55/255, blue: 55/255, alpha: 1)
    
    var id:Int = -1
    //var iconList = [UIImage]()
    
    
    private var dao:DatabaseLayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
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
                cell.btnDanhMuc.addTarget(self, action: #selector(viewdetail), for: .touchUpInside)
            } else {
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
    
    
    @objc func viewdetail(sender:UIButton)
    {
        let indexpath1 = IndexPath(row: sender.tag, section: 0)
        
        let detail = self.storyboard?.instantiateViewController(withIdentifier: "DanhMucDetailViewController") as! DanhMucDetailViewController
        
        
        detail.sDanhMuc = itemList[indexpath1.row]
        id = itemList[indexpath1.row].Id
        detail.navigationType = .editDanhMuc
        
        
        //                home.danhMuc.append(itemList[indexpath1.row])
        //        detail.danhMuc = itemList
        //        detail.sIconList = iconList
        
        self.navigationController?.pushViewController(detail, animated: false)
    }
    
    
    
    
    
    // Sau khi bam Save se dduoc chuyen qua ham nay
    //    @IBAction func unwindFromDanhMucDetailViewController(segue: UIStoryboardSegue) {
    //        if let source = segue.source as? DanhMucDetailViewController {
    //            let danhMuc = source.sDanhMuc
    //
    ////            if source.navigationType == .editDanhMuc {
    ////                if let selectedIndexPaths = myCollectionView.indexPathsForSelectedItems {
    ////                    for indexPath in selectedIndexPaths {
    ////                        itemList[indexPath.item] = danhMuc
    ////                        myCollectionView.reloadItems(at: [indexPath])
    ////                    }
    ////                }
    ////            }
    ////            else{
    ////                let newIndexPath = IndexPath(item: itemList.count, section: 0)
    ////                itemList.append(danhMuc)
    ////                myCollectionView.insertItems(at: [newIndexPath])
    ////            }
    //
    //            switch (source.navigationType){
    //            case .newDanhMuc:
    //                // Them mon an moi vao Table View cua MealList
    //                let newIndexPath = IndexPath(item: itemList.count, section: 0)
    //                itemList.append(danhMuc)
    //                myCollectionView.insertItems(at: [newIndexPath])
    //            //break
    //            case .editDanhMuc:
    //                // Lay Vi Tri cell duoc chon truoc do
    //                if let selectedIndexPaths = myCollectionView.indexPathsForSelectedItems {
    //                    for indexPath in selectedIndexPaths {
    //                        itemList[indexPath.item] = danhMuc
    //                        myCollectionView.reloadItems(at: [indexPath])
    //                    }
    //                }
    //                break
    //            }
    //
    //        }
    //    }
    
    
    // Chuan bi du lieu va gui di truoc khi chuyen man hinh
    //    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    //        if let destination = segue.destination as? DanhMucDetailViewController {
    //            if let segueName = segue.identifier {
    //                if (segueName == "addDanhMuc") {
    //                    destination.navigationType = .newDanhMuc
    //                }
    //                else {
    //                    destination.navigationType = .editDanhMuc
    //                    print("prepare")
    //
    ////                    for danhMuc in itemList {
    ////                        if danhMuc.Id == id {
    ////                            destination.sDanhMuc = danhMuc
    ////                            break
    ////                        }
    ////                    }
    //
    //
    ////                    if let selectedIndexPaths = myCollectionView.indexPathsForSelectedItems,
    ////                        let selectedIndexPath = selectedIndexPaths.first {
    ////
    ////                        destination.sDanhMuc = itemList[selectedIndexPath.item]
    ////                    }
    //
    //                }
    //            }
    //            else{
    //                print("Chua dat ten cho segue")
    //            }
    //        }
    //        else {
    //
    //        }
    //    }
    
}
