//
//  ApiDataResponse.swift
//  IOS Library
//
//  Created by Алексей on 15.07.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Gloss

public class ApiDataResponse<TData: Decodable> : ApiResponse
{
    public let Data: TData
    
    public required init(json: JSON)
    {
        self.Data = ("Data" <~~ json)!
        
        super.init(json: json)
    }
}
