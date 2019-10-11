//
//  RPCClient.swift
//  core
//
//  Created by Cakra Tech on 09/10/19.
//  Copyright © 2019 corpus. All rights reserved.
//

import Foundation
import RMQClient

class RPCClient{
    
    let semaphore = DispatchSemaphore(value: 0)
    let rmqConn: RMQConnection
    
    init(rmqConnection: RMQConnection) {
        self.rmqConn = rmqConnection
    }
    
    
    func dispatchTimeFromNow(_ seconds: Double) -> DispatchTime {
        return DispatchTime.now() + Double(Int64(seconds * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
    }
    
    func call(messageReq: Data, rpcName: String) -> (RMQMessage?){
        
        let ch = rmqConn.createChannel()
        
        let consumer = CustomConsumer(channel : ch, rpcClient: self)
        ch.basicConsume(consumer)
        
        let properties: [RMQValue] = [
            RMQBasicReplyTo("amq.rabbitmq.reply-to")
        ]
        
        ch.defaultExchange().publish(messageReq, routingKey: rpcName, properties: properties as! [RMQValue & RMQBasicValue])
        
        semaphore.wait(timeout: dispatchTimeFromNow(8))
        
        return consumer.getMessage()
    }
    
    
    class CustomConsumer: RMQConsumer {
        let semaphore : DispatchSemaphore
        init(channel: RMQChannel, rpcClient: RPCClient ) {
            semaphore = rpcClient.semaphore
            super.init(channel: channel, queueName: "amq.rabbitmq.reply-to", options: [.exclusive, .noAck])
            
        }
        var message: RMQMessage?
        
        override func consume(_ message: RMQMessage!) {
            self.message = message
            semaphore.signal()
        }
        
        func getMessage()->(RMQMessage?){
            return message
        }
    }
    
}

