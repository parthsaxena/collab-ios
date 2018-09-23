//
//  StreamViewController.swift
//  
//
//  Created by Parth Saxena on 9/22/18.
//

import UIKit
import FirebaseFirestore

class StreamViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var streamTableView: UITableView!
    
    var feedObjects = NSMutableArray()
    
    var overlayView: UIView?
    var activityIndicator: NVActivityIndicatorView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
        //UIColor(red: 0/255, green: 155/255, blue: 13/255, alpha: 1.0)
        self.navigationController?.navigationBar.titleTextAttributes =
            [NSAttributedString.Key.foregroundColor: UIColor.white,
             NSAttributedString.Key.font: UIFont(name: "OpenSans-Bold", size: 21)!]
        
        overlayView = UIView(frame: self.view.frame)
        overlayView?.backgroundColor = UIColor.black
        overlayView?.alpha = 0
        self.view.addSubview(overlayView!)
        
        activityIndicator = NVActivityIndicatorView(frame: CGRect(x: self.view.center.x - 25, y: self.view.center.y - 25, width: 50, height: 50), type: .cubeTransition, color: UIColor.black, padding: nil)
        self.view.addSubview(activityIndicator!)
        
        startLoading()

        let adjustForTabbarInsets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: self.tabBarController!.tabBar.frame.height, right: 0)
        self.streamTableView.contentInset = adjustForTabbarInsets
        self.streamTableView.scrollIndicatorInsets = adjustForTabbarInsets
        
        streamTableView.backgroundColor = UIColor.clear
        let footerView = UIView()
        footerView.backgroundColor = UIColor(red: 224/225, green: 224/225, blue: 224/225, alpha: 1.0)
        streamTableView.tableFooterView = footerView
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
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
    
    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.feedObjects.count
    }
    var i = 0
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! StreamTableViewCell
        print("Loading Cell")
        if let feedObject = self.feedObjects[indexPath.row] as? [String: Any] {
            let timestamp = feedObject["timestamp"] as! NSDate
            let content = feedObject["content"] as! String
            print(feedObject)
            cell.contentTextView.text = content
        }
        return cell
    }

    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 166
    }
    
    func loadData() {
        var i = 0
        if GlobalVariables.classes != nil {
            for className in GlobalVariables.classes! {
                i+=1
                print("ClassName: \(className)")
                Firestore.firestore().collection("feed").whereField("class", isEqualTo: className).getDocuments() { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        for document in querySnapshot!.documents {
                            print("Got document")
                            let feedDictionary = document.data()
                            self.feedObjects.add(feedDictionary)
                        }
                        if i == GlobalVariables.classes!.count {
                            self.stopLoading()
                            print("Reloading")
                            self.streamTableView.reloadData()
                        }
                    }
                }
            }
        } else {
            self.stopLoading()
            print("Reloading")
            self.streamTableView.reloadData()
        }
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
