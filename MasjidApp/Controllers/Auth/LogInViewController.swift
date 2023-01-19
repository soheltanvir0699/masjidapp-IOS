//
//  LogInViewController.swift
//  MasjidApp
//
//  Created by Sohel Rana on 11/10/22.
//

import UIKit

class LogInViewController: UIViewController {
    @IBOutlet weak var passLbl: UITextField!
    
    @IBOutlet weak var emailLbl: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    @IBAction func signUpAction(_ sender: Any) {
        AlertController()
    }
    
    @IBAction func logInAction(_ sender: TransitionButton) {
        self.view.endEditing(true)
        guard let email = emailLbl.text, email != ""  else {
            self.showToast(message: "Email not found.", styleColor: .white,backgroundColor: .red)
            return
        }
        guard let password = passLbl.text, password != ""  else {
            self.showToast(message: "Password not found.", styleColor: .white,backgroundColor: .red)
            return
        }
        sender.startAnimation()
        Service.LoginApi(email: email, pass: password) { result in
            sender.stopAnimation()
            
            if result.success {
                constant.authToken = result.token!
                print(result.user?.image, "profile image")
                constant.loginEmail = result.user!.email
                constant.isCreator = result.user!.is_creator!
                if result.user?.image != nil {
                    constant.userImage = (result.user?.image!)!
                    print(constant.userImage, "profile image 2")
                }
                if result.message != nil {
                    self.showToast(message: result.message!, styleColor: .white,backgroundColor: .systemGreen)
                }else {
                self.showToast(message: "Log in Successful.", styleColor: .white,backgroundColor: .systemGreen)
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    self.dismiss(animated: true)
                }
                
            }else {
                if result.message != nil {
                    self.showToast(message: result.message!, styleColor: .white,backgroundColor: .red)
                }else {
                self.showToast(message: "Unable to login with credentials provided.", styleColor: .white,backgroundColor: .red)
                }
            }
        } failure: { err in
            sender.stopAnimation()
            self.showToast(message: "Unable to login with credentials provided.", styleColor: .white,backgroundColor: .red)
        }

    }
    @IBAction func BackBtnAction(_ sender: Any) {
        dismiss(animated: true)
    }
    func AlertController() {
        let alert = UIAlertController(title: "LOG IN", message: "", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Sign Up As a User", style: .default, handler: { _ in
            constant.login_type = 0
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "SignUpViewController")
            self.navigationController?.pushViewController(vc!, animated: true)
            
        }))
        alert.addAction(UIAlertAction(title: "Sign Up As a Admin", style: .default, handler: { _ in
            constant.login_type = 1
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "SignUpViewController")
            self.navigationController?.pushViewController(vc!, animated: true)
        }))
        present(alert, animated: false)
    }

}
