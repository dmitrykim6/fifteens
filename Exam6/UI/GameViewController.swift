//
//  GameViewController.swift
//  Exam6
//
//  Created by Dmitry Kim on 30.11.2019.
//  Copyright © 2019 Dmitry Kim. All rights reserved.
//

import UIKit

enum GameCellData {
    case number(Int)
    case empty
}

class GameViewController: UICollectionViewController {
    
    @IBOutlet weak var counter: UINavigationItem!
    @IBAction func newGame(_ sender: UIBarButtonItem) {
        newGame()
    }
    @IBAction func undoAction(_ sender: UIBarButtonItem) {
        if let undo = undoCombo{
            gameMatrix = undo
            collectionView.reloadData()
        }
        
    }
    
    let lb = ListOfRecortsData()
    
    let segueId = "toLeaderBoard" // id segue to Leader board
    let reuseId = "GameCell"
    
    
    
    var oldIndexPath = IndexPath()
    var prevIndexPath = IndexPath()
    var emptyCellPath = IndexPath() // for save empty cell position
    
    var counterNum = 0
    
    
    // Configure matrix
    
    // Win game matrix
    var winMatrix = GameData().winMatrix
        
    // Start game
    // easy or hard game
//    var gameMatrix = GameData().newGameMatrix()
    var gameMatrix = GameData().easyNewGameMatrix()
    
    // UNDO matrix
    var undoCombo: [[String]]?
    
    
    var prevSelectedCell: GameCell?
    var prevSelectedCellIndexPath: [Int]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set counter to 0 steps
        counter?.title = "0"
        
    }

    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        //create and configure flow layout
        if let flowLayout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            
            //
            let itemsPerLine: CGFloat = 4
            let sectionInset: CGFloat = 10
            let itemSpacing: CGFloat = 10
            let lineSpacing: CGFloat = 5

            let adjustedWidth =
                    self.collectionView.bounds.size.width
                    + itemSpacing
                    - sectionInset * 2

            let itemWidth =
                    adjustedWidth / itemsPerLine - itemSpacing

            let itemHeight: CGFloat = itemWidth
            
            flowLayout.itemSize = CGSize(width: itemWidth, height: itemHeight)
            flowLayout.minimumInteritemSpacing = itemSpacing
            flowLayout.minimumLineSpacing = lineSpacing
            
            flowLayout.sectionInset =
                UIEdgeInsets(top: sectionInset, left: sectionInset, bottom: sectionInset, right: sectionInset)
            
            self.collectionView.reloadData()
            
        }
        
    }
    
    func newGame() -> Void {
        
        undoCombo = nil // delete undo matrix
        gameMatrix = GameData().newGameMatrix() //create new game matrix
        counterNum = 0
        counter.title = String(counterNum)
        
        self.collectionView.reloadData()
        
    }
    
    func showLeaderBoard() {
//        print(lb.getFromLeaderBoard())
        performSegue(withIdentifier: segueId, sender: nil)
    }
    
    
    func saveToLeaderBoard(name: [UITextField]?) {
        
        if let data = name,
            data.count > 0{
            
            if let name = data[0].text{
                if name.count > 0 {

                    let newWinner = Winner(name: name, score: counter.title ?? "")
                    
                    lb.addToLeaderBoard(leader: newWinner)
                
                }else {
                    print("NIL")
                }
                
            }
        
        }
        showAlert()
        
    }
    
    func showAlertSaveRecord() {
        
        let alertSaveName = UIAlertController(
            title: "YOU WIN", message: "Save your name", preferredStyle: .alert)
        
        let saveScore = UIAlertAction(
                        title: "Save",
                        style: .default,
                        handler: {_ in self.saveToLeaderBoard(name: alertSaveName.textFields)})
        let cancel = UIAlertAction(
                        title: "Cancel",
                        style: .default,
                        handler: {_ in self.showAlert()})
        
        
        alertSaveName.addTextField { (textField) in
            textField.placeholder = "input your name"
        }
        
        alertSaveName.addAction(saveScore)
        alertSaveName.addAction(cancel)
        
        present(alertSaveName, animated: true, completion: nil)
        
    }
    
    func showAlert() {
        let alertWin = UIAlertController(
                        title: """
            You Win!
            Steps: \(counterNum)
            """,
                        message: "",
                        preferredStyle: .alert
                        )
        
        let alertButton = UIAlertAction(
                        title: "New Game",
                        style: .default,
                        handler: {_ in self.newGame()})
        
        let hitButton = UIAlertAction(
                        title: "High Scores",
                        style: .default,
                        handler: {_ in self.showLeaderBoard()})
        
        alertWin.addAction(alertButton)
        alertWin.addAction(hitButton)
        
        present(alertWin, animated: true, completion: nil)
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return gameMatrix.count
    }


    override func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
        ) -> Int {
        return gameMatrix[section].count
    }

    override func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
        ) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseId, for: indexPath) as? GameCell else { fatalError() }
    
        if gameMatrix[indexPath.section][indexPath.item] != "0" {
            cell.number.text = String(gameMatrix[indexPath.section][indexPath.item])
            cell.backgroundColor = .lightGray
        } else {
            cell.number.text = ""
            cell.backgroundColor = .gray
            
            emptyCellPath = indexPath // save empty cell position
        }

        
        return cell
    }

}


extension GameViewController {
    func isNeighbor(firstElem: [Int]?, secondElem: [Int]?) -> Bool {
        
        guard let firstElem = firstElem,
            let secondElem = secondElem else { return false }
        
        let firstElemSection = firstElem[0]
        let firstElemnItem = firstElem[1]
        let secondElemSection = secondElem[0]
        let secondElemItem = secondElem[1]

        if abs(firstElemnItem - secondElemItem) == 1 &&
            firstElemSection == secondElemSection{
            
            return true
            
        }else if abs(firstElemSection - secondElemSection) == 1 &&
            firstElemnItem == secondElemItem {
            
            return true
            
        } else {
            
            return false
            
        }

    }
    
    func shuffle(firstElem: [Int]?, secondElem: [Int]?) {
        
        guard let firstElem = firstElem,
            let secondElem = secondElem else { fatalError() }
        
        let firstElemValue = gameMatrix[firstElem[0]][firstElem[1]]
        
        self.gameMatrix[firstElem[0]][firstElem[1]] = self.gameMatrix[secondElem[0]][secondElem[1]]
        
        self.gameMatrix[secondElem[0]][secondElem[1]] = firstElemValue
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            
        guard let cell = collectionView.cellForItem(at: indexPath) as? GameCell else { fatalError() }
        guard let oldCell = collectionView.cellForItem(at: emptyCellPath) as? GameCell else { fatalError() }
        
        if isNeighbor(firstElem: [emptyCellPath.section, emptyCellPath.item], secondElem: [indexPath.section, indexPath.item]){
            
            //save undo matrix
            undoCombo = gameMatrix
            
            let label = cell.number.text
            
            shuffle(firstElem: [emptyCellPath.section, emptyCellPath.item], secondElem: [indexPath.section, indexPath.item])
            
            counterNum += 1
            counter.title = String(counterNum)
            
            oldCell.number.text = label
            oldCell.backgroundColor = .lightGray

                
//            collectionView.reloadData()
            collectionView.reloadItems(at: [indexPath])
            
            // check for win
            if winMatrix == gameMatrix {
                
                print("You win!")
                
                showAlertSaveRecord()
                
            }
            
            
        }
    }

}

