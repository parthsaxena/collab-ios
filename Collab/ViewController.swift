//
//  ViewController.swift
//  Collab
//
//  Created by Parth Saxena on 9/22/18.
//  Copyright © 2018 Parth Saxena. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

class ViewController: UIViewController {

    @IBOutlet weak var firstNameField: HoshiTextField!
    @IBOutlet weak var lastNameField: HoshiTextField!
    @IBOutlet weak var emailField: HoshiTextField!
    @IBOutlet weak var passwordField: HoshiTextField!
    
    var overlayView: UIView?
    var activityIndicator: NVActivityIndicatorView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        overlayView = UIView(frame: self.view.frame)
        overlayView?.backgroundColor = UIColor.black
        overlayView?.alpha = 0
        self.view.addSubview(overlayView!)
        
        activityIndicator = NVActivityIndicatorView(frame: CGRect(x: self.view.center.x - 25, y: self.view.center.y - 25, width: 50, height: 50), type: .cubeTransition, color: UIColor.black, padding: nil)
        self.view.addSubview(activityIndicator!)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {                
        
        if GlobalVariables.alreadySignedIn {
            startLoading()
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
                            Firestore.firestore().collection("students").document(Auth.auth().currentUser!.uid).getDocument() { (document, error) in
                                if let error = error {
                                    print("Error getting documents: \(error)")
                                } else {
                                    if let document = document, document.exists {
                                        let assignmentDictionary = document.data()
                                        if let classes = assignmentDictionary!["classes"] as? [String] {
                                            GlobalVariables.classes = classes
                                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "MainVC")
                                            self.present(vc!, animated: true, completion: nil)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
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
    
    @IBAction func getStartedTapped(sender: Any) {
        startLoading()
        
        let firstName = firstNameField.text!
        let lastName = lastNameField.text!
        let email = emailField.text!
        let password = emailField.text!
        
        registerUser(firstName: firstName, lastName: lastName, email: email, password: password) { (success) in
            if (success) {
                self.stopLoading()
                print("Successfully registered user.")
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "haveClassCodeVC")
                self.present(vc!, animated: true, completion: nil)
            } else {
                self.stopLoading()
                print("Failed to register user.")
            }
        }
    }
    
    func registerUser(firstName: String, lastName: String, email: String, password: String, completion: @escaping (_ result: Bool) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if (error != nil) {
                completion(false)
            } else {
                if (result?.user != nil) {
                    print("Created user in Auth")
                    
                    let uid = result?.user.uid
                    Firestore.firestore().collection("students").document(uid!).setData([
                        "firstName": firstName,
                        "lastName": lastName,
                        "email": email
                    ])
                    completion(true)
                }
            }
        }    
    }


}

