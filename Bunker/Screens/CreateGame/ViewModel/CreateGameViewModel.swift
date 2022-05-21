//
//  CreateGameViewModel.swift
//  Bunker
//
//  Created by Дмитрий Соколов on 21.05.2022.
//

import Foundation
import Combine

final class CreateGameViewModel {
    private let socketController = WebSocketController.shared
    private let settings = UserSettings.shared
    private weak var viewController: CreateGameViewController?
    
    private var gamePref = GamePreferences() {
        didSet {
            validateData()
        }
    }
    private var roomModel: WaitingRoom? {
        didSet {
            navigateToWaitingRoom()
        }
    }
    public var username: String = ""{
        didSet {
            settings.username = username
            validateData()
        }
    }
    public var votingTime: Int = 0 {
        didSet{
            self.gamePref.votingTime = votingTime
            validateData()
        }
    }
    private var connectionStatus: Bool = false {
        didSet {
            validateData()
        }
    }
    private var isDataValid: Bool = false {
        didSet{
            setScreenData()
        }
    }
    private var connectionSubscriber: AnyCancellable?
    private var roomModelSubscriber: AnyCancellable?
    
    // MARK: - Init
    init(_ vc: CreateGameViewController) {
        self.viewController = vc
        if let name = settings.username {
            self.username = name
        }
        
        binding()
    }
    
    // MARK: - Binding
    private func binding() {
        connectionSubscriber = socketController.connectionStatusSub
            .receive(on: RunLoop.main)
            .assign(to: \.connectionStatus, on: self)
        roomModelSubscriber = socketController.waitingRoomRecieved
            .receive(on: RunLoop.main)
            .assign(to: \.roomModel, on: self)
    }
    
    // MARK: - Data validation
    private func setScreenData() {
        viewController?.setScreenData(username: username, prefs: gamePref, isDataValid)
    }
    
    private func validateData() {
        if(!username.isEmpty && gamePref.catastrophe != nil && connectionStatus &&
           gamePref.difficulty != nil && gamePref.votingTime != 0) {
            isDataValid = true
        } else {
            isDataValid = false
        }
    }
    
    // MARK: - Interactions
    public func choosePack() {
        let packVC = PackViewController()
        if let pack = gamePref.catastrophe {
            packVC.chosenPack = pack
        }
        packVC.delegate = self
        viewController?.navigationController?.pushViewController(packVC, animated: true)
    }
    
    public func createGame() {
        socketController.sendGamePref()
    }
    
    // MARK: - Navigation
    private func navigateToWaitingRoom() {
        guard let roomModel = roomModel else {
            return
        }
        let waitingRoomVC = WaitingRoomViewController(data: roomModel)
        viewController?.navigationController?.pushViewController(waitingRoomVC, animated: true)
    }
}

// MARK: - PackDelegate
extension CreateGameViewModel: PackViewControllerDelegate {
    func packSet(_ pack: Catastrophe) {
        self.gamePref.catastrophe = pack
    }
}
