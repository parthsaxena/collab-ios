//
//  SignInViewController.swift
//  Collab
//
//  Created by Parth Saxena on 9/22/18.
//  Copyright © 2018 Parth Saxena. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class SignInViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    var overlayView: UIView?
    var activityIndicator: NVActivityIndicatorView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        overlayView = UIView(frame: self.view.frame)
        overlayView?.backgroundColor = UIColor.black
        overlayView?.alpha = 0
        self.view.addSubview(overlayView!)
        
        activityIndicator = NVActivityIndicatorView(frame: CGRect(x: self.view.center.x - 25, y: self.view.center.y - 25, width: 50, height: 50), type: .cubeTransition, color: UIColor.black, padding: nil)
        self.view.addSubview(activityIndicator!)
        
        // Do any additional setup after loading the view.
    }
    
    func startLoading() {
        UIView.animate(withDuration: 0.3) {
            self.overlayView?.alpha = 0.6
        }
        activityIndicator?.startAnimating()
    }
    
    func stopLoading() {
        UIView.animate(withDuration: 0.3) {
            self.overlayView?.alpha = 0
        }
        activityIndicator?.stopAnimating()
    }
    
    @IBAction func signInTapped(sender: Any) {
        startLoading()
        let email = self.emailField.text
        let password = self.passwordField.text
        
        signInUser(email: email!, password: password!) { (result) in
            if result {
                self.stopLoading()
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "MainVC")
                self.present(vc!, animated: true, completion: nil)
            } else {
                self.stopLoading()
                let alert = UIAlertController(title: "Whoops", message: "Wrong e-mail/password combination!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                alert.view.tintColor = UIColor.red
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func signInUser(email: String, password: String, completion: @escaping (_ result: Bool) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if error != nil {
                print(error)
                completion(false)
            } else {
                if result != nil {
                    // QUERY TEACHERS
                    Firestore.firestore().collection("students").document(Auth.auth().currentUser!.uid).getDocument() { (document, err) in
                        if let err = err {
                            print("Error getting documents: \(err)")
                        } else {
                            if let document = document, document.exists {
                                print("Got document")
                                if let studentDictionary = document.data() {
                                    if let chatsArray = studentDictionary["chats"] as? [String] {
                                        GlobalVariables.chats = chatsArray
                                    }
                                    Firestore.firestore().collection("students").whereField("email", isEqualTo: email).getDocuments(completion: { (snapshot, error) in
                                        if let error = error {
                                            print("Error getting documents: \(error)")
                                        } else {
                                            for document in snapshot!.documents {
                                                let assignmentDictionary = document.data()
                                                if let classes = assignmentDictionary["classes"] as? [String] {
                                                    GlobalVariables.classes = classes
                                                    completion(true)
                                                }
                                            }
                                        }
                                    })
                                }
                            }
                        }
                    }
                }
            }
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
