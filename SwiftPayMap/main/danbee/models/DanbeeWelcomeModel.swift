//
//  DanbeeWelcomeModel.swift
//  SwiftPayMap
//
//  Created by KyungSeok Lee on 2019. 3. 7..
//  Copyright © 2019년 KyungSeok Lee. All rights reserved.
//

struct ResponseSetApi: Decodable {
    let code: String
    let result: DanbeeResult
    private enum CodingKeys: String, CodingKey {
        case code, result
    }
}

struct DanbeeResult : Decodable {
    let channel_id: String
    let chatbot_id: String
    let result: [DanbeeWelcomeModel]
    
    private enum CodingKeys: String, CodingKey {
        case channel_id, chatbot_id, result
    }
}

struct DanbeeWelcomeModel: Decodable {
    let imgRoute: String
    let message: String
    
    private enum CodingKeys: String, CodingKey {
        case imgRoute,message
    }
}
