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
    private var coinImageView: CoinView!
    let characterSkinTableView = UITableView()
    var characterCollection: [[Character]] {
        return [PoolOfPossibleCharacters.shared.getAllUserOwnedCharacters(), PoolOfPossibleCharacters.shared.getAllCharactersUserDoesNotHave()]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        characterSkinTableView.delegate = self
        characterSkinTableView.dataSource = self
        characterSkinTableView.register(CharacterSkinCell.self, forCellReuseIdentifier: CharacterSkinCell.reuseID)
        setupCharacterSkinTableView()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        setupNavigationBar()
    }
    
    func setupNavigationBar() {
        title = "Character Skins"
        let font = UIFont(name: "HelveticaNeue", size: 30)
        coinImageView = CoinView(numberOfCoins: currentPlayer?.playerCoins ?? 0, textFont: font, fontColor: .black)
        coinImageView.frame = CGRect(x: coinImageView.frame.origin.x, y: coinImageView.frame.origin.y, width: coinImageView.frame.width * 0.75, height: coinImageView.frame.height * 0.75)
        navigationItem.titleView = coinImageView
        guard let navBar = navigationController?.navigationBar else { return }
        navBar.tintColor = .black
        navBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.black]
        navBar.barTintColor = CONSTANTS.COLORS.MENU_BUTTONS
    }
    
    func setupCharacterSkinTableView() {
        characterSkinTableView.translatesAutoresizingMaskIntoConstraints = false
        characterSkinTableView.allowsSelection = false
        view.addSubview(characterSkinTableView)
        characterSkinTableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0/*UIApplication.shared.statusBarFrame.height*/).isActive = true
        characterSkinTableView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        characterSkinTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        characterSkinTableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
    }
}

extension CharacterSkinsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CharacterSkinCell.reuseID) as! CharacterSkinCell
        cell.setupCellWith(character: characterCollection[indexPath.section][indexPath.row], doesUserOwnSkin: indexPath.section == 0)
        cell.buttonDelegate = self
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

extension CharacterSkinsViewController: CharacterButtonDelegate {
    func didTapSetButton(character: Character) {
        currentPlayer?.setSelectedSkinByID(character.character_id)
        navigationController?.popViewController(animated: true)
    }
    func didTapRealMoneyPurchaseButton(character: Character) {
        print("money")
        let loadingView = FullPageLoadingIndicator(viewController: self)
        loadingView.startLoading()
        print(character.character_name)
        IAPHandler.shared.purchaseMyProduct(productIdentifier: character.product_id)
        IAPHandler.shared.purchaseStatusBlock = { [weak self] alertType in
            loadingView.stopLoading()
            switch alertType {
            case .purchased:
                self?.currentPlayer?.playerDidPurchaseSkin(character, wasRealMoneyPurchase: true)
                DispatchQueue.main.async { [weak self] in
                    self?.characterSkinTableView.reloadData()
                    self?.fadeInCongratsView(character)
                }
            case .restored:
                self?.currentPlayer?.playerDidPurchaseSkin(character, wasRealMoneyPurchase: true)
                DispatchQueue.main.async { [weak self] in
                    self?.characterSkinTableView.reloadData()
                    self?.fadeInCongratsView(character)
                }
            case .failed:
                print("failed!!!!!")
                let failedAlert = AlertView.getCustomAlert(title: "Oops", message: "Something went wrong.  Please check your internet or try again.")
                self?.present(failedAlert, animated: true, completion: nil)
            case .disabled:
                print("disabled!!!")
                let disabledAlert = AlertView.getCustomAlert(title: "Oops", message: "Looks like in app purchasing is disabled.")
                self?.present(disabledAlert, animated: true, completion: nil)
            }
        }
    }
    func didTapCoinPurchaseButton(character: Character) {
        if currentPlayer!.playerCoins < character.coinCost {
            present(AlertView.getCustomAlert(title: "", message: "You need \((character.coinCost - currentPlayer!.playerCoins).getCommaFormattedNumberToString()) more coins!", numberOfButtons: 1), animated: true, completion: nil)
        } else {
            currentPlayer!.playerDidPurchaseSkin(character, wasRealMoneyPurchase: false)
            coinImageView.updateCoinCount(currentPlayer!.playerCoins)
            characterSkinTableView.reloadData()
            fadeInCongratsView(character)
        }
    }
    func fadeInCongratsView(_ character: Character) {
        let congratsView = CongratsPurchaseView(character: character)
        let applicationWindow = UIApplication.shared.keyWindow
        applicationWindow?.addSubview(congratsView)
        congratsView.topAnchor.constraint(equalTo: applicationWindow!.topAnchor, constant: 0).isActive = true
        congratsView.rightAnchor.constraint(equalTo: applicationWindow!.rightAnchor, constant: 0).isActive = true
        congratsView.bottomAnchor.constraint(equalTo: applicationWindow!.bottomAnchor, constant: 0).isActive = true
        congratsView.leftAnchor.constraint(equalTo: applicationWindow!.leftAnchor, constant: 0).isActive = true
    }
}

