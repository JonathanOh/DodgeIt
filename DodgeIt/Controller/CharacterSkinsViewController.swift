//
//  CharacterSkinsViewController.swift
//  DodgeIt
//
//  Created by admin on 11/21/17.
//  Copyright © 2017 esohjay. All rights reserved.
//

import UIKit
import Firebase

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
        Analytics.logEvent("user_opened_store", parameters: [:])
        navigationController?.navigationBar.isHidden = false
        setupNavigationBar()
    }
    
    func setupNavigationBar() {
        title = "Character Skins"
        let font = UIFont(name: CONSTANTS.FONT_NAMES.DEFAULT, size: 45)
        coinImageView = CoinView(numberOfCoins: currentPlayer?.playerCoins ?? 0, textFont: font, fontColor: .black)
        coinImageView.frame = CGRect(x: coinImageView.frame.origin.x, y: coinImageView.frame.origin.y, width: coinImageView.frame.width * 0.75, height: coinImageView.frame.height * 0.75)
        navigationItem.titleView = coinImageView
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Restore", style: .plain, target: self, action: #selector(restorePurchasesTapped))
        guard let navBar = navigationController?.navigationBar else { return }
        navBar.tintColor = .black
        navBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.black]
        navBar.barTintColor = CONSTANTS.COLORS.MENU_BUTTONS
    }
    
    @objc func restorePurchasesTapped() {
        IAPHandler.shared.restorePurchase()
        let loadingView = FullPageLoadingIndicator(viewController: self)
        loadingView.startLoading()
        IAPHandler.shared.purchaseStatusBlock = { [weak self] alertType in
            loadingView.stopLoading()
            switch alertType {
            case .restored:
                let restoredAlert = AlertView.getCustomAlert(title: "", message: "Your purchases have been restored!")
                self?.present(restoredAlert, animated: true, completion: nil)
            default:
                let failedAlert = AlertView.getCustomAlert(title: "Oops", message: "Something went wrong.")
                self?.present(failedAlert, animated: true, completion: nil)
            }
        }
    }
    
    func setupCharacterSkinTableView() {
        characterSkinTableView.translatesAutoresizingMaskIntoConstraints = false
        characterSkinTableView.allowsSelection = false
        view.addSubview(characterSkinTableView)
        characterSkinTableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0/*UIApplication.shared.statusBarFrame.height*/).isActive = true
        characterSkinTableView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        characterSkinTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        characterSkinTableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        
        setupTableFooterView()
    }
    
    func setupTableFooterView() {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: characterSkinTableView.frame.width, height: 50))
        footerView.backgroundColor = .white
        
        let privacyPolicyButton = UIButton()//UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 25))
        //privacyPolicyButton.backgroundColor = .red
        privacyPolicyButton.setTitle("Privacy Policy", for: .normal)
        privacyPolicyButton.titleLabel?.font = UIFont(name: CONSTANTS.FONT_NAMES.DEFAULT, size: 25)
        privacyPolicyButton.setTitleColor(.black, for: .normal)
        privacyPolicyButton.addTarget(self, action: #selector(didTapPrivacyPolicy), for: .touchUpInside)
        footerView.addSubview(privacyPolicyButton)
        privacyPolicyButton.constrainCenterXTo(anchor: footerView.centerXAnchor)
        privacyPolicyButton.constrainCenterYTo(anchor: footerView.centerYAnchor)
        privacyPolicyButton.constrainHeightTo(dimension: footerView.heightAnchor, multiplier: 0.5)
        privacyPolicyButton.constrainWidthTo(dimension: footerView.widthAnchor, multiplier: 0.4)
        
        characterSkinTableView.tableFooterView = footerView
    }
    
    @objc func didTapPrivacyPolicy() {
        print("did tap privacy")
        navigationController?.pushViewController(PrivacyPolicyViewController(), animated: true)
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
//    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        if characterCollection.count == (section + 1) {
//            let footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 25))
//            footerView.backgroundColor = .red
//            return footerView
//        }
//        return nil
//    }
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

