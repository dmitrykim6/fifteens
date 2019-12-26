//
//  ListOfRecortsData.swift
//  Exam6
//
//  Created by Dmitry Kim on 30.11.2019.
//  Copyright © 2019 Dmitry Kim. All rights reserved.
//

import Foundation

struct Winner: Codable {
    
    let name: String
    let score: String
    
}

class ListOfRecortsData {
    
    let keyforStorage = "allLeaders"
    let encoder = JSONEncoder()
    let decoder = JSONDecoder()
    let storage = UserDefaults.standard

    
    var allLeader: [Winner] = []
    

    
    func addToLeaderBoard(leader: Winner) {
        
        allLeader = getFromLeaderBoard()
        
        allLeader.append(leader)
        
        let encodedData = try? encoder.encode(allLeader)
        storage.set(encodedData, forKey: keyforStorage)
    }
    
    func getFromLeaderBoard() -> [Winner]{
        
        if let data = storage.data(forKey: keyforStorage),
            let winners = try? self.decoder.decode([Winner].self, from: data) {

            return winners
        }
        print("not work")
        return []
    }
}
