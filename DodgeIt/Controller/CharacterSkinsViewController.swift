//
//  CharacterSkinsViewController.swift
//  DodgeIt
//
//  Created by admin on 11/21/17.
//  Copyright © 2017 esohjay. All rights reserved.
//

import UIKit

class CharacterSkinsViewController: UIViewController {
    var currentPlayer: Player?
    let characterSkinTableView = UITableView()
    let characterCollection = [PoolOfPossibleCharacters.shared.getAllUserOwnedCharacters(), PoolOfPossibleCharacters.shared.getAllCharactersUserDoesNotHave()]
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        characterSkinTableView.delegate = self
        characterSkinTableView.dataSource = self
        characterSkinTableView.register(CharacterSkinCell.self, forCellReuseIdentifier: CharacterSkinCell.reuseID)
        setupCharacterSkinTableView()
    }
    
    func setupCharacterSkinTableView() {
        characterSkinTableView.translatesAutoresizingMaskIntoConstraints = false
        characterSkinTableView.allowsSelection = false
        view.addSubview(characterSkinTableView)
        characterSkinTableView.topAnchor.constraint(equalTo: view.topAnchor, constant: UIApplication.shared.statusBarFrame.height).isActive = true
        characterSkinTableView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        characterSkinTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        characterSkinTableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
    }
}

extension CharacterSkinsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CharacterSkinCell.reuseID) as! CharacterSkinCell
        cell.setupCellWith(character: characterCollection[indexPath.section][indexPath.row], doesUserOwnSkin: indexPath.section == 0)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return characterCollection[section].count
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return characterCollection.count // Owned and Unowned characters
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "Owned" : "Unowned"
    }
}

extension CharacterSkinsViewController: UITableViewDelegate {
    
}
