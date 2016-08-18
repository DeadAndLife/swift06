//
//  ViewController.swift
//  01-socket第三方库实现TCP客户端
//
//  Created by qingyun on 16/8/6.
//  Copyright © 2016年 QingYun. All rights reserved.
//

import UIKit
import CocoaAsyncSocket


class ViewController: UIViewController,GCDAsyncSocketDelegate {

    @IBOutlet weak var ipTF: UITextField!
    @IBOutlet weak var portTF: UITextField!
    @IBOutlet weak var sendTF: UITextField!
    
    @IBOutlet weak var connectBtn: UIButton!
    @IBOutlet weak var receiveLabel: UILabel!
    var socket:GCDAsyncSocket!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //1.初始化套接字
        socket = GCDAsyncSocket(delegate: self, delegateQueue: dispatch_get_main_queue())
        
        
    }

    //2.连接服务器
    @IBAction func connectClick(sender: UIButton) {
        if sender.titleLabel?.text == "连接"{
            let ip = ipTF.text
            let port = UInt16(portTF.text!)!
            
            //所有有throws标识的函数,表示可能抛出错误的函数,可以使用do-catch捕获或者try? /try!;try?返回可选,try!如果有错误抛出会崩掉
            do {
                try socket.connectToHost(ip, onPort: port)
            }catch{
                print(error)
            }
        }else {
            socket.disconnect()//主动断开连接
            sender.setTitle("连接", forState: .Normal)
        }
    }
    
    @IBAction func sendClick(sender: UIButton) {
        let str = sendTF.text!
        let data = str.dataUsingEncoding(NSUTF8StringEncoding)
        
        socket.writeData(data, withTimeout: -1, tag: 0)
    }
    
    func showMsg(string:String){
        receiveLabel.text! += "\n\(string)"
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: - GCDAsyncSocketDelegate
    //连接服务器成功的代理方法
    func socket(sock: GCDAsyncSocket!, didConnectToHost host: String!, port: UInt16) {
        print("连接服务器成功!ip:\(host),port:\(port)")
        
        //改变按钮的标题
        connectBtn.setTitle("断开", forState: .Normal)
        //连接成功后主动接收服务器的数据
        socket.readDataWithTimeout(-1, tag: 0)
    }

    //接收到数据的代理方法
    func socket(sock: GCDAsyncSocket!, didReadData data: NSData!, withTag tag: Int) {
        
        let string = String(data: data, encoding: NSUTF8StringEncoding)
        print("接收到服务器发来的数据:\(string)")
        showMsg(string!)
        
        //连接成功后主动接收服务器的数据
        socket.readDataWithTimeout(-1, tag: 0)
    }
    
    //发送数据成功的代理
    func socket(sock: GCDAsyncSocket!, didWriteDataWithTag tag: Int) {
        print("发送数据成功!\(tag)")
    }
    
    func socketDidDisconnect(sock: GCDAsyncSocket!, withError err: NSError!) {
        print("断开连接!")
        if err != nil{//非自己主动断开时,会有err
            print(err)
        }
    }
}

