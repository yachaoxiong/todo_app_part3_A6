//
//  ViewController.swift
//  todo_list_MAPD714_Group6
//
//  App Name: todo list
//  Course : MAPD714
//  Author : Yachao Xiong 301298033, Mingyuan Xie 301275467
//
//
//  App Revision History
//  V1.0 init app and add basic UI              -  2022-11-13
//  V1.1 added details  page UI                 -  2022-11-13
//
//  App Revision History part 2
//  V2.0 added edit function and btns function       -  2022-11-27
//  V2.1 fixed errors and update table btn function  -  2022-11-27
//  v2.2 added revision history                      -  2022-11-27
//
//  About the App
//  This app is to create tasks for the todo list.
//
//  Created by Yachao on 2022-11-13.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var listTable: UITableView!
    var todolist = [[String:String]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.modalPresentationStyle = .fullScreen
        initData()
        listTable.dataSource = self
        listTable.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        initData()
        listTable.dataSource = self
        listTable.delegate = self
        listTable.reloadData()
    }
    // init data
    func initData(){
        todolist = UserDefaults.standard.object(forKey: "arrayTodoList") as? [[String:String]] ?? [[String:String]]()
    }
    // table rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todolist.count
    }
 
    // set data for every row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let list =  todolist[indexPath.row]
        let cell =  listTable.dequeueReusableCell(withIdentifier: "cell",for:indexPath) as? todolistViewCell
        
        cell!.title.text = list["title"]
       
       
        
        let isFinished = list["isFinished"] == "true" ? true : false
      
       
        
        let hasDueDate = list["hasDueDate"] == "true" ? true : false
        if(hasDueDate){

            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            let dueDate = dateFormatter.date(from: list["dueDate"] ?? "")!
            
            let currentDate = Date()
            
            if(dueDate > currentDate ){
               cell!.status.text = list["dueDate"]
                
            }else{
               cell!.status.text = "OverDue"
               cell!.status.textColor = UIColor.red
            }
        }else{
            cell!.status.text = " "
        }
        
        if isFinished {
           
            cell!.title.textColor = UIColor.systemGray5
            cell!.status.text = "Completed"
            cell!.status.textColor = UIColor.black
        }else{
           
            cell!.title.textColor = UIColor.black
        }
        
        
 
        return cell!
    }
    // start a new screen
    @objc func detailsScreen(sender: UIButton){
        
        let vc = storyboard?.instantiateViewController(identifier: "detailsScreen") as! DetailsViewController
        let nc = UINavigationController(rootViewController: vc)
        vc.title = "Todo Details"
        vc.selectedTodo = sender.tag 
       
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromLeft
        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
        view.window!.layer.add(transition, forKey: kCATransition)
        
        present(nc, animated: false)
        

    }
    // update the todo item status
     @objc func updateTitle(_ sender:UISwitch!){

         let indexPath = NSIndexPath(row: sender.tag, section: 0)
     
         let cell = listTable.cellForRow(at: indexPath as IndexPath) as! todolistViewCell
         if sender.isOn{
             cell.title.textColor = UIColor.systemGray5
             cell.status.text = "Completed"
             cell.status.textColor =  UIColor.black
           
         }else{
             cell.title.textColor = UIColor.black
             let hasDueDate = todolist[sender.tag]["hasDueDate"] == "true" ? true : false
             
             if(hasDueDate){
                 let dateFormatter = DateFormatter()
                 dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                 let dueDate = dateFormatter.date(from: todolist[sender.tag]["dueDate"] ?? "")!

                 let currentDate = Date()

                 if(dueDate < currentDate ){
                     cell.status.text = "OverDue"
                     cell.status.textColor = UIColor.red
                 }else{
                     cell.status.text =  todolist[sender.tag]["dueDate"]
                     
                 }
             }else{
                 cell.status.text = " "
             }
         }
         
         
         let hasDueDate = sender.isOn ? "true" : "false"
         todolist[sender.tag]["isFinished"] = hasDueDate
         UserDefaults.standard.set(todolist,forKey:"arrayTodoList")
    }
    
    // start the new screen to add new todo item
    @IBAction func button_addItem_Pressed(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(identifier: "detailsScreen") as! DetailsViewController
        vc.title = "New Todo"
    
        present(vc,animated: true)
    }
    
}


