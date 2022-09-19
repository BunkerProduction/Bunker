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
    private var connectionError: String? {
        didSet {
            showError()
        }
    }
    private var roomModel: WaitingRoom? {
        didSet {
            navigateToWaitingRoom()
        }
    }
    private var connectionSubscriber: AnyCancellable?
    private var roomModelSubscriber: AnyCancellable?
    private var connectionErrorSubscriber: AnyCancellable?
    
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
        connectionErrorSubscriber = socketController.connectionErrorRecieved
            .receive(on: RunLoop.main)
            .assign(to: \.connectionError, on: self)

    }

    private func showError() {
        guard let error = connectionError else { return }
        viewController?.showError(errorString: error)
    }
    
    // MARK: - Interactions
    public func joinGame(code: String) {
        socketController.connectToGame(username: settings.username ?? "name", roomCode: code, isCreator: false)
    }
    
    // MARK: - Navigation
    private func navigateToWaitingRoom() {
        guard let roomModel = roomModel else {
            return
        }
        let waitingRoomVC = WaitingRoomViewController(data: roomModel)
        // cancel subscribtion to network results
        connectionSubscriber?.cancel()
        roomModelSubscriber?.cancel()
        
        viewController?.navigationController?.pushViewController(waitingRoomVC, animated: true)
    }
    
    public func navigatedBack() {
        self.binding()
    }
}
