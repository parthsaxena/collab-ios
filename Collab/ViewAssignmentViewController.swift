//
//  ViewAssignmentViewController.swift
//  Collab
//
//  Created by Parth Saxena on 9/23/18.
//  Copyright © 2018 Parth Saxena. All rights reserved.
//

import UIKit
import FirebaseFirestore

class ViewAssignmentViewController: UIViewController {

    @IBOutlet weak var subjectLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var membersLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        var className = GlobalVariables.assignmentViewing!["class"] as! String
        var title: String?
        Firestore.firestore().collection("classes").document(className).getDocument() { (document, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                if let document = document, document.exists {
                    let data = document.data()
                    title = data!["title"] as! String
                }
            }
        }
        
        self.subjectLabel.text = className
        self.titleLabel.text = title
        self.membersLabel.text = "2 members"
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func chatTapped(sender: Any) {
        let vc = AddRandomMessagesChatViewController()
        self.present(vc, animated: true, completion: nil)
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
