//
//  AttackInteractor.swift
//  Undersea
//
//  Created by Vekety Robin on 2020. 07. 15..
//  Copyright © 2020. Vekety Robin. All rights reserved.
//

import Foundation
import Combine

extension Attack {
    
    class AttackInteractor {
        
        private lazy var presenter: AttackPresenterProtocol = setPresenter()
        var setPresenter: (() -> AttackPresenterProtocol)!
        
        private let worker = Attack.ApiWorker()
        let dataSubject = CurrentValueSubject<DataModelType, Error>(DataModelType())
        let loadingSubject = CurrentValueSubject<Bool, Never>(false)
        let loadMoreSubject = CurrentValueSubject<Bool, Never>(false)
        private var subscription: AnyCancellable?
     
        private var page = 1
        private var pageSize = 20
        
        func handleUsecase(_ event: Attack.Usecase) {
            
            switch event {
            case .load(let userName):
                loadData(userName)
            case .loadMore(let userName):
                loadMore(userName)
            }
            
        }
        
        private func loadData(_ userName: String?) {
            
            page = 1
            loadingSubject.send(true)
            subscription = worker.getAttack(userName)
                .receive(on: DispatchQueue.global())
                .sink(receiveCompletion: { (result) in
                    self.loadingSubject.send(false)
                    switch result {
                    case .failure(_):
                        //self.sendTestData()
                        self.dataSubject.send(completion: result)
                    default:
                        print("-- Interactor: load data finished")
                        break
                    }
                }, receiveValue: { data in
                    sleep(2)
                    self.dataSubject.send(data)
                })
            
        }
        
        private func loadMore(_ userName: String) {
            
            loadMoreSubject.send(true)
            subscription = worker.getAttack(userName, page: page + 1)
            .receive(on: DispatchQueue.global())
            .sink(receiveCompletion: { (result) in
                self.loadMoreSubject.send(false)
                switch result {
                case .failure(_):
                    self.dataSubject.send(completion: result)
                default:
                    print("-- Profile Interactor: load data finished")
                    break
                }
            }, receiveValue: { data in
                sleep(1)
                self.page += 1
                var tmp = self.dataSubject.value
                tmp.append(contentsOf: data)
                self.dataSubject.send(tmp)
            })
            
        }
        
    }
    
}
