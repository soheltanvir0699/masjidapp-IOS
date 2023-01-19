//
//  MyMasjidViewController.swift
//  MasjidApp
//
//  Created by Sohel Rana on 31/10/22.
//

import UIKit

class MyMasjidViewController: UIViewController {
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var addButton: UIBarButtonItem!
    var homeData: MosquesModel?
    fileprivate func myMasjidApiCalling() {
        Service.MyMasjidListApi { result in
            self.hideLoader()
            if result.success {
                self.homeData = result
                DispatchQueue.main.async {
                self.tblView.reloadData()
                }
                if self.homeData?.data?.count != 0 {
                    if self.homeData?.data![0].city != nil {
                        constant.city = (self.homeData?.data![0].city)!
                    }
                    if self.homeData?.data![0].country != nil {
                        constant.country = (self.homeData?.data![0].country)!
                    }
                    self.addButton.isEnabled = false
                    self.addButton.tintColor = .clear
                }else {
                    self.addButton.isEnabled = true
                    self.addButton.tintColor = .white
                }
            }else {
                self.showToast(message: "Something went wrong, please try again", styleColor: .white ,backgroundColor: .red)
            }
        } failure: { err in
            self.hideLoader()
            self.showToast(message: err, styleColor: .white ,backgroundColor: .red)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.showLoader(controller: self)
        myMasjidApiCalling()
        navigationController?.navigationBar.tintColor = .white
    }
    @IBAction func cancelAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @objc func RemoveAction(sender:UIButton) {
        let tag = sender.tag-10000
        self.showLoader(controller: self)
        let id = homeData!.data![tag].id
        Service.RemoveMasjid(salat_Id: "\(id)") { result in
            if result.success {
                self.showToast(message: result.message, styleColor: .white, backgroundColor: .systemGreen)
                self.myMasjidApiCalling()
            }else {
                self.hideLoader()
                self.showToast(message: result.message, styleColor: .white, backgroundColor: .red)
            }
        } failure: { err in
            self.hideLoader()
            self.showToast(message: err, styleColor: .white, backgroundColor: .red)
        }
    }
    
    @objc func UpdateAction(sender:UIButton) {
        let tag = sender.tag-1000
        let id = homeData!.data![tag].id
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "EditAndUpdateViewController") as? EditAndUpdateViewController
        vc?.masjid_id = "\(id)"
        vc?.Mosques_Data = homeData?.data![tag]
        self.navigationController?.pushViewController(vc!, animated: true)
    }

    @IBAction func addMasjidAction(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "EditAndUpdateViewController") as? EditAndUpdateViewController
        self.navigationController?.pushViewController(vc!, animated: true)
//        AlertController()
    }
    func AlertController() {
        let alert = UIAlertController(title: "Add Masjid / Create Next Update Schedule", message: "", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Add Masjid", style: .default, handler: { _ in
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "EditAndUpdateViewController") as? EditAndUpdateViewController
            self.navigationController?.pushViewController(vc!, animated: true)
            
        }))
        if homeData?.data?.count != 0 {
        alert.addAction(UIAlertAction(title: "Create Schedule", style: .default, handler: { _ in
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "NextUpdateViewController")
            self.navigationController?.pushViewController(vc!, animated: true)
        }))
        }
        present(alert, animated: false)
    }
}

extension MyMasjidViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if homeData != nil {
            return (homeData?.data!.count)!
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyMasjidCell") as? MyMasjidCell
        if homeData?.data![indexPath.row].mosque_icon != nil {
        cell?.imgView.sd_setImage(with: URL(string: (homeData?.data![indexPath.row].mosque_icon)!), placeholderImage: UIImage(named: "icon"))
        }else {
            cell?.imgView.sd_setImage(with: URL(string: ""), placeholderImage: UIImage(named: "icon"))
        }
        cell?.editBtn.tag = 1000+indexPath.row
        cell?.editBtn.addTarget(self, action: #selector(UpdateAction(sender:)), for: .touchUpInside)
        var address = (homeData?.data![indexPath.row].state)! + ", "
        address += (homeData?.data![indexPath.row].city)!
        address +=  ", " + (homeData?.data![indexPath.row].country)!
        cell?.addressLbl.text = address
        
        cell?.add_rm_fav_btn.tag = 10000+indexPath.row
        cell?.add_rm_fav_btn.addTarget(self, action: #selector(RemoveAction(sender:)), for: .touchUpInside)
        cell?.selectedBackgroundView = UIView()
        cell?.nameLbl.text = homeData?.data![indexPath.row].mosque_name
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}
