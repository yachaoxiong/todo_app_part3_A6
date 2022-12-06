//
//  DetailsViewController.swift
//  todo_list_MAPD714_Group6
//  App Name: todo list
//  Course : MAPD714
//  Author : Yachao Xiong 301298033, Mingyuan Xie 301275467
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
//
//  Created by Yachao on 2022-11-13.
//


import UIKit

class DetailsViewController:
    UIViewController {
    @IBOutlet weak var textView_name: UITextField!
    @IBOutlet weak var updateBtn: UIButton!
    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var pageTitle: UILabel!
    @IBOutlet weak var textField_details: UITextField!
    @IBOutlet weak var completeLabel: UILabel!
    @IBOutlet weak var switch_hasDueDate: UISwitch!
    @IBOutlet weak var datePicker_picakDate: UIDatePicker!
    @IBOutlet weak var datePickerView: UIStackView!
    @IBOutlet weak var switch_isCompleted: UISwitch!
    var arr = [[String:String]]()
    var selectedTodo = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        initDetails()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initDetails()
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    // init data for editing or creating
    func initDetails(){
         arr =  UserDefaults.standard.object(forKey: "arrayTodoList") as? [[String:String]] ?? [[String:String]]()
        if(self.navigationItem.title == "New Todo"){
            self.textView_name.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
            
            deleteBtn.isHidden = true
            updateBtn.isHidden = true
            cancelBtn.isHidden = true
            switch_hasDueDate.isHidden = true
            switch_isCompleted.isHidden = true
            completeLabel.isHidden = true
        }else{
            let selectedItem = arr[selectedTodo]
            textView_name.text = selectedItem["title"]
            textField_details.text = selectedItem["details"]
            selectedItem["isFinished"] == "true" ? switch_isCompleted.setOn(true, animated: true) : switch_isCompleted.setOn(false, animated: true)
            selectedItem["hasDueDate"] == "true" ? switch_hasDueDate.setOn(true, animated: true) : switch_hasDueDate.setOn(false, animated: true)
            if(selectedItem["hasDueDate"] == "true"){
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                let datePicker_dueDate = dateFormatter.date(from: selectedItem["dueDate"] ?? "")
                datePicker_picakDate.date = datePicker_dueDate!
            }
        }
        pageTitle.text = self.navigationItem.title
        if !switch_hasDueDate.isOn{
            datePicker_picakDate.isHidden = true
        }
       
    }
   // show btns when users enter the title of todo item
    @objc private func textFieldDidChange(_ textField: UITextField) {
        updateBtn.setTitle("Create", for: .normal)
        updateBtn.isHidden = false
        cancelBtn.isHidden = false
        switch_hasDueDate.isHidden = false
    }
    // hide or show datePicker
    @IBAction func button_dueDate_pressed(_ sender: UISwitch!) {
        if sender.isOn{
            datePicker_picakDate.isHidden = false
        }
        else{
            datePicker_picakDate.isHidden = true
        }
    }
    // update or create a new todo item
    @IBAction func button_update_pressed(_ sender: UIButton) {
        
        if(self.navigationItem.title == "New Todo"){
            self.createOrUpdate()
            self.goBack()
        }else{
            
            let alert = UIAlertController(title: "Update Todo", message: "Are you sure to Update it?", preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default,handler: {
                _ in
                
                self.createOrUpdate()
                self.goBack()
            }))
            
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default,handler: {
                _ in
               print("cancel")
            }))
            
            self.present(alert,animated: true,completion: nil)
        
        }
    }
    // delete function
    @IBAction func button_delete_pressed(_ sender: UIButton) {
        let alert = UIAlertController(title: "Delete Todo", message: "Are you sure to delete it?", preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default,handler: {
            _ in
            
            self.deleteItem()
            self.goBack()
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default,handler: {
            _ in
           print("cancel")
        }))
        
        self.present(alert,animated: true,completion: nil)
    }
    // cancel function
    @IBAction func button_cancel_pressed(_ sender: UIButton) {
        if(self.navigationItem.title == "New Todo"){
         goBack()
        }else{
            let showAlert =  cancelUpdate()
             print(showAlert)
             if(showAlert){
                 
                 let alert = UIAlertController(title: "Cancel Update", message: "Are you sure to Cancel it?", preferredStyle: UIAlertController.Style.alert)
                 
                 alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default,handler: {
                     _ in

                     self.goBack()
                 }))
                 
                 alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default,handler: {
                     _ in
                    print("cancel")
                 }))
                 
                 self.present(alert,animated: true,completion: nil)
                 
             }else{
                 goBack()
             }
        }
      
    }
    // back to home screen
    func goBack()  {
      self.dismiss(animated: true, completion: nil)
    }
    // remove item from todo list
    func deleteItem(){
        arr.remove(at: selectedTodo)
        UserDefaults.standard.set(arr,forKey:"arrayTodoList")
    }
    // create a new todo or update it
    func createOrUpdate() {
            let text_name = textView_name.text ?? ""
            let text_details = textField_details.text ?? ""
            let switch_hasDueDate = switch_hasDueDate.isOn ? "true" : "false"
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            let datePicker_dueDate = dateFormatter.string(from: datePicker_picakDate.date)
            let switch_isCompleted = switch_isCompleted.isOn ? "true" : "false"
        if(self.navigationItem.title == "New Todo"){
            var dict = [String:String]()
            dict["title"] = text_name
            dict["details"] = text_details
            dict["hasDueDate"] = switch_hasDueDate
            dict["isFinished"] = switch_isCompleted
            dict["dueDate"] = datePicker_dueDate
            arr.append(dict)
            print("arr.count is: \(arr.count)")
            UserDefaults.standard.set(arr,forKey:"arrayTodoList")
        }else{
            arr[selectedTodo]["title"] = text_name
            arr[selectedTodo]["details"] = text_details
            arr[selectedTodo]["hasDueDate"] = switch_hasDueDate
            arr[selectedTodo]["isFinished"] = switch_isCompleted
            arr[selectedTodo]["dueDate"] = datePicker_dueDate
            UserDefaults.standard.set(arr,forKey:"arrayTodoList")
        }
    }
    // cancel update 
    func cancelUpdate()-> Bool{
        let text_name = textView_name.text ?? ""
        let text_details = textField_details.text ?? ""
        let switch_hasDueDate = switch_hasDueDate.isOn ? "true" : "false"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        let datePicker_dueDate = dateFormatter.string(from: datePicker_picakDate.date)
        let switch_isCompleted = switch_isCompleted.isOn ? "true" : "false"
        
        if(arr[selectedTodo]["title"] != text_name || arr[selectedTodo]["details"] != text_details || arr[selectedTodo]["hasDueDate"] != switch_hasDueDate || arr[selectedTodo]["isFinished"] != switch_isCompleted) {
            return true
        }else{
            if(arr[selectedTodo]["hasDueDate"] == "true"){
                if(datePicker_dueDate != arr[selectedTodo]["dueDate"]){
                    print(datePicker_dueDate)
                    print(arr[selectedTodo]["dueDate"])
                    print("due date is diff")
                    return true
                }else{
                    return false
                }
              
            }else{
                return false
            }
        }
    }
}



