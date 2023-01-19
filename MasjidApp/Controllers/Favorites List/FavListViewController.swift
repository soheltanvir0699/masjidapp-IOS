//
//  FavListViewController.swift
//  MasjidApp
//
//  Created by Sohel Rana on 30/10/22.
//

import UIKit
import SDWebImage
class FavListViewController: UIViewController {

    @IBOutlet weak var tblView: UITableView!
    var data: FavListModel?
    fileprivate func favApiCalling() {
        Service.FavListApi { result in
            self.hideLoader()
            if result.success {
                self.data = result
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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.showLoader(controller: self)
        favApiCalling()
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
        Service.RemoveToFavIdApi(fav_id: "\((data?.data[tag].id)!)") { result in
            if result.success {
                self.showToast(message: result.message, styleColor: .white, backgroundColor: .systemGreen)
                self.favApiCalling()
            }else {
                self.hideLoader()
                self.showToast(message: result.message, styleColor: .white, backgroundColor: .red)
            }
        } failure: { err in
            self.hideLoader()
            self.showToast(message: err, styleColor: .white, backgroundColor: .red)
        }

    }
    
    @objc func addFavDefAction(sender:UIButton) {
        let tag = sender.tag-1000 
        self.showLoader(controller: self)
        Service.AddToFavApi(salat_Id: "\((data?.data[tag].salat_Id[0].id)!)",is_default: "True") { resutl in
            if resutl.success {
                self.showToast(message: "Make Default Mosjid Successful.", styleColor: .white, backgroundColor: .systemGreen)
                self.favApiCalling()
            }else {
                self.showToast(message: resutl.message, styleColor: .white, backgroundColor: .red)
            }
        } failure: { err in
            self.showToast(message: err, styleColor: .white, backgroundColor: .red)
        }
    }

}

extension FavListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if data != nil {
            return (data?.data.count)!
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavCell") as? FavCell
        if data?.data[indexPath.row].salat_Id[0].mosque_icon != nil {
        cell?.imgView.sd_setImage(with: URL(string: (data?.data[indexPath.row].salat_Id[0].mosque_icon)!), placeholderImage: UIImage(named: "icon"))
        }
        cell?.add_fav_default.tag = 1000+indexPath.row
        cell?.add_fav_default.addTarget(self, action: #selector(addFavDefAction(sender:)), for: .touchUpInside)
        if data!.data[indexPath.row].is_default! {
            cell?.add_fav_default.tintColor = .systemOrange
        }else {
            cell?.add_fav_default.tintColor = .white
        }
        
        cell?.add_rm_fav_btn.tag = 10000+indexPath.row
        cell?.add_rm_fav_btn.addTarget(self, action: #selector(RemoveAction(sender:)), for: .touchUpInside)
        cell?.selectedBackgroundView = UIView()
        cell?.nameLbl.text = data?.data[indexPath.row].salat_Id[0].mosque_name
        
        return cell!
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MasjidDetailsViewController") as? MasjidDetailsViewController
        vc?.data = data?.data[indexPath.row].salat_Id[0]
        self.navigationController?.pushViewController(vc!, animated: true)
    }
}
