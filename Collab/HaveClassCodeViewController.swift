//
//  HaveClassCodeViewController.swift
//  Collab
//
//  Created by Parth Saxena on 9/22/18.
//  Copyright © 2018 Parth Saxena. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class HaveClassCodeViewController: UIViewController {

    @IBOutlet weak var codeField: HoshiTextField?
    
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
    
    @IBAction func goTapped(sender: Any) {
        startLoading()
        
        let code = codeField?.text
        checkCode(code: code!) { (result) in
            if !(result!) {
                self.stopLoading()
                let alert = UIAlertController(title: "Whoops", message: "There's no matching classes for that code!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                alert.view.tintColor = UIColor.red
                self.present(alert, animated: true, completion: nil)
            } else {
                self.stopLoading()
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "MainVC")
                self.present(vc!, animated: true, completion: nil)
                print("Success")
            }
        }
    }
    
    func checkCode(code: String, completion: @escaping (_ result: Bool?) -> Void) {
        Firestore.firestore().collection("classes").document(code).getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                Firestore.firestore().collection("students").document(Auth.auth().currentUser!.uid).updateData(["classes" : FieldValue.arrayUnion([code])])
                Firestore.firestore().collection("classes").document(code).updateData(["students" : FieldValue.arrayUnion([Auth.auth().currentUser!.uid])])
                Firestore.firestore().collection("students").document(Auth.auth().currentUser!.uid).getDocument(completion: { (document, error) in
                    if let error = error {
                        print("Error getting documents: \(error)")
                    } else {
                        if let document = document, document.exists {
                            if let studentDictionary = document.data() {
                                if let classes = studentDictionary["classes"] as? [String] {
                                    GlobalVariables.classes = classes
                                    completion(true)
                                } else {
                                    completion(false)
                                }
                            } else {
                                completion(false)
                            }
                        } else {
                            print("Document does not exist")
                            completion(false)
                        }
                    }
                })
            } else {
                print("Document does not exist")
                completion(false)
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
