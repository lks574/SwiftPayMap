//
//  DanbeeMoya.swift
//  SwiftPayMap
//
//  Created by KyungSeok Lee on 2019. 3. 7..
//  Copyright © 2019년 KyungSeok Lee. All rights reserved.
//

import Moya

enum DanbeeMoya {
    
    static private let danbeeApikey = "adec5c1317872c8663297aea2f3a7175660ce9d099d8fa853869d0393d3deeee"    // header
    static private let chatbotId = "8cea128d-bdc3-4d86-99ed-3cb7d0f80df3"                                   // parameter
    
    
    // case로 표시 되는건 끝점
    case welcome
    case engine(String)
}

extension DanbeeMoya : TargetType {
    
    // 베이스 URL (공용 URL)
    var baseURL: URL {
        return URL(string: "https://danbee.ai/chatflow")!
    }
    
    // EndPoint
    var path: String {
        switch self {
        case .welcome:
            return "/welcome.do"
        case .engine:
            return "/engine.do"
        }
    }
    
    // 각각의 Method
    var method: Moya.Method {
        return .post
    }
    
    // 단위 테스트시 네트워크에 연결하지 않고 이 객체를 보낸다.
    var sampleData: Data {
        return Data()
    }
    
    // 기본요청(plain request), 데이터 요청(data request), 파라미터 요청(parameter request), 업로드 요청(upload request) 등
    var task: Task {
        switch self {
        case .welcome:
            //URLEncoding.default
            return .requestParameters(parameters: ["chatbot_id": DanbeeMoya.chatbotId], encoding: JSONEncoding.default)
            
        case .engine(let message):
            return .requestParameters(parameters: ["chatbot_id": DanbeeMoya.chatbotId, "input_sentence": message], encoding: JSONEncoding.default)
            
//        default:
//            return .requestPlain
        }
        
    }
    
    var headers: [String : String]? {
        return ["Content-Type": "application/json", "danbee_apikey" : DanbeeMoya.danbeeApikey]
    }
    
    // api 요청의 정의를 제공 (현재는 200~299 사이 요청이 성공으로 확인)
    var validationType: ValidationType {
        return .successCodes
    }
}


