//
//  DeviceService.swift
//  CoreFramework
//
//  Created by Алексей on 12.03.18.
//  Copyright © 2018 Medved-Studio. All rights reserved.
//

import Foundation
import MdsKit

public class DeviceService {

    private let tag = String.tag(DeviceService.self)
    private let guid = Guid.new
    private let apiQueue: AsyncQueue

    private let api: NotificationsDevicesApiService
    private let keys: ApiKeyService
    private let storage: LightStorage
    private let events: EventsAdapter<DeviceCacheServiceDelegate>

    public private(set) var device: Device?

    public init(_ api: NotificationsDevicesApiService, _ keys: ApiKeyService, _ storage: LightStorage) {

        apiQueue = AsyncQueue.createForApi(for: tag)

        self.api = api
        self.keys = keys
        self.storage = storage
        self.events = EventsAdapter<DeviceCacheServiceDelegate>(tag: tag)

        self.device = storage.get(.device)

        keys.subscribe(guid: guid, handler: self, tag: tag)
    }

    //Methods
    public func register(token: String) -> RequestResult<Device> {
        return RequestResult<Device>() { handler in

            let request = self.api.register(token: token)
            request.async(self.apiQueue) { response in

                if let device = response.data {
                    self.save(device)
                    self.events.invoke({ $0.deviceService(self, register: device) })

                    if self.keys.isAuth {
                        self.connect(with: device)
                    }
                }

                handler(response)
            }
        }
    }
    public func update(_ deviceId: Long, token: String) -> RequestResult<Device> {
        return RequestResult<Device> { handler in

            let request = self.api.update(deviceId, token: token)
            request.async(self.apiQueue, completion: { response in

                if let device = response.data {
                    self.save(device)
                    self.events.invoke({ $0.deviceService(self, update: device) })
                }

                handler(response)
            })
        }
    }
    public func connect(_ deviceId: Long) -> RequestResult<Device> {
        return RequestResult<Device> { handler in

            let request = self.api.connect(deviceId)
            request.async(self.apiQueue, completion: { response in

                if let device = response.data {
                    self.save(device)
                    self.events.invoke({ $0.deviceService(self, update: device) })
                }

                handler(response)
            })
        }
    }

    private func save(_ device: Device) {

        self.device = device
        storage.set(.device, value: device)
    }
}
extension DeviceService: IEventsEmitter {
    public typealias THandler = DeviceCacheServiceDelegate

    public func subscribe(guid: String, handler: DeviceCacheServiceDelegate, tag: String) {
        events.subscribe(guid: guid, handler: handler, tag: tag)
    }
    public func unsubscribe(guid: String) {
        events.unsubscribe(guid: guid)
    }
}
extension DeviceService: ApiKeyServiceDelegate {

    public func apiKeyService(_ service: ApiKeyService, update keys: ApiKeys, for role: ApiRole) {

        guard let device = device else {
            return
        }

        if (device.accountId == keys.id) {
            return
        }

        connect(with: device)
    }
    public func apiKeyService(_ service: ApiKeyService, logout role: ApiRole) {
        guard let device = device,
                let accountId = device.accountId else {
            return
        }

        let request = self.api.logout(device.id, accountId: accountId)
        request.async(.background, completion: { response in

            if let update = response.data {
                self.save(update)
                self.events.invoke({ $0.deviceService(self, update: update) })
            }
        })
    }
    private func connect(with device: Device) {

        let request = self.connect(device.id)
        request.async(.background, completion: { _ in })
    }
}

public protocol DeviceCacheServiceDelegate {
    func deviceService(_ service: DeviceService, register device: Device)
    func deviceService(_ service: DeviceService, update device: Device)
}
extension DeviceCacheServiceDelegate {
    public func deviceService(_ service: DeviceService, register device: Device) { }
    public func deviceService(_ service: DeviceService, update device: Device) { }
}
