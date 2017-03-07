//
//  Pagination.swift
//  OraChallenge
//
//  Created by Jorge Vivas on 3/6/17.
//  Copyright © 2017 JorgeVivas. All rights reserved.
//

import UIKit
import SwiftyJSON

class Pagination: NSObject {

    var currentPage: Int?
    var perPage: Int?
    var pageCount: Int?
    var totalCount: Int?
    
    required init?(json: SwiftyJSON.JSON) {
        self.currentPage = json["current_page"].int
        self.perPage = json["per_page"].int
        self.pageCount = json["page_count"].int
        self.totalCount = json["total_count"].int
    }
}
