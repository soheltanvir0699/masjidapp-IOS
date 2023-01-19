//
//  ForgotPasswordViewController.swift
//  MasjidApp
//
//  Created by Sohel Rana on 12/10/22.
//

import UIKit

class ForgotPasswordViewController: UIViewController {
    @IBOutlet weak var emailFld: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func resetAction(_ sender: TransitionButton) {
        self.view.endEditing(true)
        guard emailFld.text != "" else {
            self.showToast(message: "Email not found.", styleColor: .white,backgroundColor: .red)
            return
        }
        sender.startAnimation()
        Service.PasswordResetApi(email: emailFld.text!) { result in
            sender.stopAnimation()
            if result.success {
                self.showToast(message: "Reset link was sent to your email", styleColor: .white,backgroundColor: .systemGreen)
            }else {
                self.showToast(message: result.message!, styleColor: .white,backgroundColor: .red)
            }
        } failure: { err in
            sender.stopAnimation()
            self.showToast(message: err, styleColor: .white,backgroundColor: .red)
        }

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
