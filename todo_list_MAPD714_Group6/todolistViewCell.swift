//
//  todolistViewCell.swift
//  todo_list_MAPD714_Group6
//  App Name: todo list
//  Course : MAPD714
//  Author : Yachao Xiong 301298033, Mingyuan Xie 301275467
//
//
//  App Revision History
//  V1.0 init app and add basic UI              -  2022-11-13
//  V1.1 added details list page UI             -  2022-11-13
//
//  About the App
//  This app is to create tasks for the todo list.
//
//  Created by Yachao on 2022-11-13.
//


import UIKit

class todolistViewCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    
    @IBOutlet weak var status: UILabel!
    
    @IBOutlet weak var isFinished: UISwitch!
    @IBOutlet weak var editBtn: UIButton!
    

    
}
