//
//  SignUpViewController.swift
//  MasjidApp
//
//  Created by Sohel Rana on 12/10/22.
//

import UIKit
import M13Checkbox

class SignUpViewController: UIViewController, UIImagePickerControllerDelegate , UINavigationControllerDelegate {
    @IBOutlet weak var profileImg: UIImageView!
    
    @IBOutlet weak var confirmPassLbl: UITextField!
    @IBOutlet weak var passwordLbl: UITextField!
    @IBOutlet weak var userLbl: UITextField!
    @IBOutlet weak var emailLbl: UITextField!
    @IBOutlet weak var nameLbl: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        profileImg.layer.cornerRadius = profileImg.frame.height / 2
        profileImg.layer.borderWidth = 1
        profileImg.layer.borderColor = UIColor.gray.cgColor
        imageUploadAction.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(pickimage)))

    }
    

    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func signUpAction(_ sender: TransitionButton) {
        self.view.endEditing(true)
        guard let email = emailLbl.text, email != ""  else {
            self.showToast(message: "Email not found.", styleColor: .white,backgroundColor: .red)
            return
        }
        guard let password = passwordLbl.text, password != ""  else {
            self.showToast(message: "Password not found.", styleColor: .white,backgroundColor: .red)
            return
        }
        guard let name = nameLbl.text, name != ""  else {
            self.showToast(message: "Name not found.", styleColor: .white,backgroundColor: .red)
            return
        }
        guard let con_password = confirmPassLbl.text, con_password != ""  else {
            self.showToast(message: "Confitm Password not found.", styleColor: .white,backgroundColor: .red)
            return
        }
        let image = resizeImage(image: profileImg.image!, newWidth: 60)
        var is_creator = "False"
        if constant.login_type == 0 {
            is_creator = "False"
        }else {
            is_creator = "True"
        }
        sender.startAnimation()
        Service.LogupApi(image: image, is_creator: is_creator, name: name, email: email, pass: password) { result in
            sender.stopAnimation()
            if result.success {
                if result.message != nil {
                    self.showToast(message: result.message!, styleColor: .white,backgroundColor: .systemGreen)
                }else {
                self.showToast(message: "Sign Up Successful.", styleColor: .white,backgroundColor: .systemGreen)
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    self.navigationController?.popViewController(animated: true)
                }
            }else {
                self.showToast(message: "Sign Up Unsuccessful.", styleColor: .white,backgroundColor: .red)
            }
            
        } failure: { err in
            sender.stopAnimation()
            self.showToast(message: err, styleColor: .white,backgroundColor: .red)
        }

        
    }
    @IBOutlet weak var imageUploadAction: UIImageView!
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        DispatchQueue.main.async {
            self.profileImg.image = info[UIImagePickerController.InfoKey(rawValue: UIImagePickerController.InfoKey.originalImage.rawValue)] as? UIImage
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    @objc func pickimage()  {
       let imagecontroller = UIImagePickerController()
        imagecontroller.delegate = self
        imagecontroller.sourceType = UIImagePickerController.SourceType.photoLibrary
        self.present(imagecontroller, animated: true, completion: nil)
        print("tap")
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
