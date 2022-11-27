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
        initData()
        listTable.dataSource = self
        listTable.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        print("start new data")
        initData()
        listTable.dataSource = self
        listTable.delegate = self
        listTable.reloadData()
    }
    
    func initData(){
        todolist = UserDefaults.standard.object(forKey: "arrayTodoList") as? [[String:String]] ?? [[String:String]]()
        print("todolist")
        print(todolist)
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
        cell!.status.text = list["dueDate"]
       
        
        let isFinished = list["isFinished"] == "true" ? true : false
        cell!.isFinished.setOn(isFinished, animated: true)
        cell!.isFinished.tag = indexPath.row
        cell?.editBtn.tag = indexPath.row
        
        if isFinished {
            cell!.title.textColor = UIColor.systemGray5
            cell!.status.text = "Completed"
        }
        
        cell!.editBtn.addTarget(self, action: #selector(detailsScreen(sender:)), for: .touchUpInside)
        cell!.isFinished.addTarget(self, action: #selector(updateTitle), for: .touchUpInside)
        return cell!
    }
    
    @objc func detailsScreen(sender: UIButton){
        
        let vc = storyboard?.instantiateViewController(identifier: "detailsScreen") as! DetailsViewController
        let nc = UINavigationController(rootViewController: vc)
        vc.title = "Todo Details"
        vc.selectedTodo = sender.tag 
        present(nc, animated: true,completion: nil)
    }
    
     @objc func updateTitle(_ sender:UISwitch!){

         let indexPath = NSIndexPath(row: sender.tag, section: 0)
     
         let cell = listTable.cellForRow(at: indexPath as IndexPath) as! todolistViewCell
         if sender.isOn{
             cell.title.textColor = UIColor.systemGray5
             cell.status.text = "Completed"
         }else{
             cell.title.textColor = UIColor.black
             cell.status.text = todolist[sender.tag]["dueDate"] 
         }
    }
    
    
    @IBAction func button_addItem_Pressed(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(identifier: "detailsScreen") as! DetailsViewController
        vc.title = "New Todo"
    
        present(vc,animated: true)
    }
    
}


