//
//  Building+Extension.swift
//  Undersea
//
//  Created by Vekety Robin on 2020. 07. 23..
//  Copyright © 2020. Vekety Robin. All rights reserved.
//

import Foundation
import CocoaLumberjack

extension City.CityPageViewModel.Building {
    
    init(buildingData: BuildingDTO) {
        self.id = buildingData.id
        self.name = buildingData.name
        self.description = buildingData.description
        self.price = buildingData.price
        self.count = buildingData.count
        self.remainingRounds = buildingData.remainingRounds
        switch buildingData.id {
        case 1:
            self.imageName = "reefCastle"
        case 2:
            self.imageName = "flowManager"
        default:
            DDLogDebug("Unknown building id \(buildingData.id)")
            self.imageName = ""
        }
    }
    
}
