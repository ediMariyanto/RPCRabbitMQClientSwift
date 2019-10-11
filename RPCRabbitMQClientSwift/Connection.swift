//
//  Connection.swift
//  core
//
//  Created by Cakra Tech on 08/10/19.
//  Copyright © 2019 corpus. All rights reserved.
//

import Foundation
import RMQClient


class Connection{
    
    static let connection = Connection()
    
    var rmqConnection: RMQConnection!
    
    private init(){}
    
    func getConnection() -> RMQConnection {
        if (rmqConnection != nil){
            return rmqConnection!
        }
        
        print("Attempting to connect to local RabbitMQ broker")
        let delegate = RMQConnectionDelegateLogger()
        rmqConnection = RMQConnection(uri: "your URI", delegate: delegate)
        rmqConnection!.start()
        
        return rmqConnection!
    }
    
}


