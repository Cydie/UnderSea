//
//  UserManager.swift
//  Undersea
//
//  Created by Vekety Robin on 2020. 07. 15..
//  Copyright © 2020. Vekety Robin. All rights reserved.
//

import Foundation
import Combine
import KeychainAccess
import SwiftJWT
import CocoaLumberjack

class UserManager {
    
    private(set) var refreshSubject: PassthroughSubject<TokenDTO, Error>?
    
    let loggedInUser = CurrentValueSubject<TokenDTO?, Never>(nil)
    private let worker = BaseApiWorker<UserManager.ApiService>()
    private var subscription: AnyCancellable?
    
    static let shared: UserManager = UserManager()
    private init() {}
    
    func login(_ data: LoginDTO) -> AnyPublisher<TokenDTO, Error> {
        
        let publisher: AnyPublisher<TokenDTO, Error> = worker.execute(target: .login(data))
        
        subscription = publisher
            .receive(on: DispatchQueue.global())
            .sink(receiveCompletion: { (result) in
                switch result {
                case .failure(_):
                    self.loggedInUser.send(nil)
                default:
                    print("-- UserManager: load data finished")
                    break
                }
            }, receiveValue: { (data: TokenDTO) in
                
                let keychain = Keychain(service: "hu.encosoft.Undersea")
                keychain["accessToken"] = data.accessToken
                keychain["refreshToken"] = data.refreshToken
                
                self.loggedInUser.send(data)
            
            })
        
        return publisher
        
    }
    
    func register(_ data: RegisterDTO) -> AnyPublisher<TokenDTO, Error> {
        
        let publisher: AnyPublisher<TokenDTO, Error> = worker.execute(target: .register(data))
        
        subscription = publisher
            .receive(on: DispatchQueue.global())
            .sink(receiveCompletion: { (result) in
                switch result {
                case .failure(_):
                    self.loggedInUser.send(nil)
                default:
                    print("-- UserManager: load data finished")
                    break
                }
            }, receiveValue: { (data: TokenDTO) in
                self.loggedInUser.send(data)
            })
        
        return publisher
        
    }
    
    func logout() {
        
        let _: AnyPublisher<EmptyResponse, Error> = worker.execute(target: .logout)
        loggedInUser.send(nil)
        
    }
    
    func updateToken() {
        
        let data = RenewDTO(refreshToken: loggedInUser.value?.refreshToken ?? "")
        refreshSubject = PassthroughSubject()
        subscription = worker.directExecute(target: .renew(data))
            .receive(on: DispatchQueue.global())
            .sink(receiveCompletion: { (result) in
                switch result {
                case .failure(_):
                    self.loggedInUser.send(nil)
                default:
                    print("-- UserManager: load data finished")
                    break
                }
                
                self.refreshSubject?.send(completion: result)
                self.refreshSubject = nil
                
            }, receiveValue: { (data: TokenDTO) in
                
                self.refreshSubject?.send(data)
                let keychain = Keychain(service: "hu.encosoft.Undersea")
                keychain["accessToken"] = data.accessToken
                keychain["refreshToken"] = data.refreshToken
                
                self.loggedInUser.send(data)
            
            })
        
    }
    
    func autoLogin() {
        
        let keychain = Keychain(service: "hu.encosoft.Undersea")
        
        guard let accessToken = keychain["accessToken"] else {
            return
        }
        
        guard let refreshToken = keychain["refreshToken"] else {
            return
        }
        
        do {
            let tokenData = try TokenDTO(refreshToken, accessToken)
            if tokenData.expirationDate + -600 < Date() {
                loggedInUser.send(tokenData)
            } else {
                updateToken()
            }
        } catch {
            DDLogDebug("Invalid access token format")
        }
        
    }
    
    func isExpired() -> Bool {
        
        if let value = loggedInUser.value {
            return value.expirationDate + -600 < Date()
        } else {
            return false
        }
        
    }
    
}
