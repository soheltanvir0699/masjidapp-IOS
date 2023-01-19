//
//  NextSchListViewController.swift
//  MasjidApp
//
//  Created by Sohel Rana on 15/12/22.
//

import UIKit

class NextSchListViewController: UIViewController {
    var homeData: schUpdModel?
    @IBOutlet weak var tblView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = .white
        // Do any additional setup after loading the view.
        showLoader(controller: self)
        SchListApiCalling()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        SchListApiCalling()
    }
    
    fileprivate func SchListApiCalling() {
        Service.getSchMasjidApi{ result in
            self.hideLoader()
            if result.success {
                self.homeData = result
                DispatchQueue.main.async {
                self.tblView.reloadData()
                }
            }else {
                self.showToast(message: result.message!, styleColor: .white ,backgroundColor: .red)
            }
        } failure: { err in
            self.hideLoader()
            self.showToast(message: err, styleColor: .white ,backgroundColor: .red)
        }
    }
    
    @IBAction func addAction(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "NextUpdateViewController")
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    @objc func RemoveAction(sender:UIButton) {
        let tag = sender.tag-10000
        self.showLoader(controller: self)
        let id = homeData!.data![tag].id
        Service.RemoveSch(Id: "\(id)") { result in
            if result.success {
                self.showToast(message: result.message, styleColor: .white, backgroundColor: .systemGreen)
                self.SchListApiCalling()
            }else {
                self.hideLoader()
                self.showToast(message: result.message, styleColor: .white, backgroundColor: .red)
            }
        } failure: { err in
            self.hideLoader()
            self.showToast(message: err, styleColor: .white, backgroundColor: .red)
        }
    }
    @IBAction func cancelAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @objc func UpdateAction(sender:UIButton) {
        let tag = sender.tag-1000
        let id = homeData!.data![tag].id
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "NextUpdateViewController") as? NextUpdateViewController
        vc?.update_id = "\(id)"
        vc?.sch_Data = homeData?.data![tag]
        self.navigationController?.pushViewController(vc!, animated: true)
    }

}

extension NextSchListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if homeData != nil {
            return (homeData?.data!.count)!
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NextSchCell") as? NextSchCell
        cell?.editBtn.tag = 1000+indexPath.row
        cell?.editBtn.addTarget(self, action: #selector(UpdateAction(sender:)), for: .touchUpInside)
        cell?.addressLbl.text = homeData?.data![indexPath.row].update_date
        cell?.nameLbl.text = homeData?.data![indexPath.row].name
        
        if homeData!.data![indexPath.row].is_expired {
            DispatchQueue.main.async {
                cell?.expiredLbl.isHidden = false
            }
           
        }else {
            DispatchQueue.main.async {
                cell?.expiredLbl.isHidden = true
            }
        }
        
        cell?.add_rm_fav_btn.tag = 10000+indexPath.row
        cell?.add_rm_fav_btn.addTarget(self, action: #selector(RemoveAction(sender:)), for: .touchUpInside)
        cell?.selectedBackgroundView = UIView()
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}

