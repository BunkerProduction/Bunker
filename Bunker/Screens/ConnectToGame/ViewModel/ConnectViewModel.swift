//
//  ConnectViewModel.swift
//  Bunker
//
//  Created by Дмитрий Соколов on 22.05.2022.
//

import Foundation
import Combine

final class ConnectViewModel {
    private let socketController = WebSocketController.shared
    private let settings = UserSettings.shared
    private weak var viewController: RoomCodeViewController?
    private var connectionStatus: Bool = false
    private var roomModel: WaitingRoom? {
        didSet {
            navigateToWaitingRoom()
        }
    }
    private var connectionSubscriber: AnyCancellable?
    private var roomModelSubscriber: AnyCancellable?
    
    // MARK: - Init
    init(_ viewController: RoomCodeViewController) {
        self.viewController = viewController
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
    
    // MARK: - Interactions
    public func joinGame(code: String) {
        socketController.connectToGame(id: code)
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
