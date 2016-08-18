//
//  ViewController.swift
//  02-UDP客户端
//
//  Created by qingyun on 16/8/6.
//  Copyright © 2016年 QingYun. All rights reserved.
//

import UIKit
import CocoaAsyncSocket

class ViewController: UIViewController ,GCDAsyncUdpSocketDelegate{

    @IBOutlet weak var ipTF: UITextField!
    @IBOutlet weak var portTF: UITextField!
    @IBOutlet weak var sendTF: UITextField!
    
    @IBOutlet weak var receiveLabel: UILabel!
    var udpSocket:GCDAsyncUdpSocket!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //1.初始化udpSocket
        udpSocket = GCDAsyncUdpSocket(delegate: self, delegateQueue: dispatch_get_main_queue())
    }

    @IBAction func sendClick(sender: UIButton) {
        let ip = ipTF.text
        let port = UInt16(portTF.text!)!
        let string = sendTF.text!
        let data = string.dataUsingEncoding(NSUTF8StringEncoding)
        udpSocket.sendData(data, toHost: ip, port: port, withTimeout: -1, tag: 0)
        
        do{
            try udpSocket.beginReceiving()
        }catch{
            print(error)
        }
    }
    func showMsg(string:String){
        receiveLabel.text! += "\n\(string)"
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: - GCDAsyncUdpSocketDelegate
    func udpSocket(sock: GCDAsyncUdpSocket!, didSendDataWithTag tag: Int) {
        print("发送数据成功!")
    }

    //接收到服务器数据的代理方法
    func udpSocket(sock: GCDAsyncUdpSocket!, didReceiveData data: NSData!, fromAddress address: NSData!, withFilterContext filterContext: AnyObject!) {
        let string = String(data: data, encoding: NSUTF8StringEncoding)
        showMsg(string!)
    }
    
}

