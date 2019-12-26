//
//  ListOfRecorts.swift
//  Exam6
//
//  Created by Dmitry Kim on 30.11.2019.
//  Copyright © 2019 Dmitry Kim. All rights reserved.
//

import UIKit

class ListOfRecorts: UITableViewController {

    let reuseId = "ScoresCell"
    let winners = ListOfRecortsData().getFromLeaderBoard()
        
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return winners.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseId, for: indexPath)
        
        cell.textLabel?.text = winners[indexPath.row].name
        cell.detailTextLabel?.text = winners[indexPath.row].score
        
        return cell
    }
    
}
