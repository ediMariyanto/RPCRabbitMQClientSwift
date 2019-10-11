//
//  ViewController.swift
//  RPCRabbitMQClientSwift
//
//  Created by Cakra Tech on 12/10/19.
//  Copyright © 2019 edi. All rights reserved.
//

import UIKit

class ViewController: NSObject {
    
    
    @IBAction func btnTest(_ sender: Any) {
        let rpcClient = RPCClient(rmqConnection: Connection.connection.getConnection())
    
        let testData: Data //try! "String test data"
        
        let rpcMessage = rpcClient.call(messageReq: testData, rpcName: "request-rpc")!
        
        print("from Controller = \(rpcMessage)")
    }
    
    
}
