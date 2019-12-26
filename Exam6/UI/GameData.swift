//
//  GameData.swift
//  Exam6
//
//  Created by Dmitry Kim on 30.11.2019.
//  Copyright © 2019 Dmitry Kim. All rights reserved.
//

import Foundation

class GameData {
    
//    var winCombination:[[GameCellData]] = [
//        [.number(1), .number(2), .number(3), .number(4)],
//        [.number(5), .number(6), .number(7), .number(8)],
//        [.number(9), .number(10), .number(11), .number(12)],
//        [.number(13), .number(14), .number(15), .empty]
//    ]
//
//    func generateGameCombo() -> [[GameCellData]] {
//
//        return winCombination.shuffled()
//
//    }
    

    let winMatrix: [[String]] = [
        ["1", "2", "3", "4"],
        ["5", "6", "7", "8"],
        ["9", "10", "11", "12"],
        ["13", "14", "15", "0"],
    ]
    
    let undoCombo: [[String]] = []
    
    func easyNewGameMatrix() -> [[String]] {
        return [
            ["1", "2", "3", "4"],
            ["5", "6", "7", "8"],
            ["9", "10", "11", "12"],
            ["13", "14", "0", "15"],
        ]
    }
    
    func newGameMatrix() -> [[String]] {
        var matrix: [[String]] = [[""]]
        var tempArray: [String] = []
        
        var allElem = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "0"]
        
        var count = 0
        
        for i in 0...15 {
            
            let x = 15 - i // count of elements in alphabet
            let randomElementNum = Int.random(in: 0...x) // get random element
            
            let randomElement = allElem.remove(at: randomElementNum)
            
            tempArray.append(randomElement)
            
            if tempArray.count == 4 || (tempArray.count == 2 && count == 6){
                matrix.append(tempArray)
                
                tempArray = []
                count += 1
            }
            
            
        }
        matrix.remove(at: 0)
        
        return matrix

    }
    
}
