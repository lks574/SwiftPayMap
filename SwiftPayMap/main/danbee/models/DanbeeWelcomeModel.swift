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
    let result: [DanbeeResultResult]
    
    private enum CodingKeys: String, CodingKey {
        case channel_id, chatbot_id, result
    }
}

struct DanbeeResultResult: Decodable {
    let imgRoute: String
    let message: String
    let optionList: [DanbeeOptionList]
    
    private enum CodingKeys: String, CodingKey {
        case imgRoute,message, optionList
    }
}

struct DanbeeOptionList: Decodable {
    let id: String
    let type: String
    let value: String
    let label: String
    
    private enum CodeingKeys: String, CodingKey {
        case id, type, value, label
    }
}
