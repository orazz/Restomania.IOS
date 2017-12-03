//
//  SelectedTownsService.swift
//  FindMe
//
//  Created by Алексей on 02.12.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation
import IOSLibrary
import AsyncTask
import Gloss

public protocol SelectedTownsServiceDelegate: class {

    func selectedTownsService(_ :SelectedTownsService, select: Long)
    func selectedTownsService(_ :SelectedTownsService, unselect: Long)
}
public class SelectedTownsService {
    public typealias THandler = SelectedTownsServiceDelegate

    private let tag = String.tag(SelectedTownsService.self)
    private let client = ApiServices.Users.towns
    private let adapter: CacheAdapter<TownContainer>
    private let apiQueue: AsyncQueue
    private let eventsAdapter: EventsAdapter<THandler>

    public init() {

        adapter = CacheAdapter<TownContainer>(tag: tag, filename: "selected-towns.json")
        apiQueue = AsyncQueue.createForApi(for: tag)
        eventsAdapter = EventsAdapter<THandler>(tag: tag)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(enterToBackground),
                                               name: Notification.Name.UIApplicationDidEnterBackground,
                                               object: nil)
    }
    public func load() {
        adapter.loadCached()
    }
    public func clear() {
        adapter.clear()
    }

    //MARK: Local
    public func isSelected(_ town: Town) -> Bool {
        return nil != adapter.extender.find(town.ID)
    }
    public func select(_ town: Town) {
        select(TownContainer(for: town))
    }
    private func select(_ town: TownContainer) {
        adapter.addOrUpdate(town)

        eventsAdapter.Trigger(action: { $0.selectedTownsService(self, select: town.ID) })
        Log.Debug(tag, "Select town #\(town.ID)")
    }
    public func unselect(_ town: Town) {
        adapter.remove(TownContainer(for: town))

        eventsAdapter.Trigger(action: { $0.selectedTownsService(self, unselect: town.ID) })
        Log.Debug(tag, "Unselect town #\(town.ID)")
    }
    public func all() -> [Long] {
        return adapter.extender.all.map{ $0.ID }
    }

    //MARK: Remote
    public func saveToRemote() {

        let request = client.update(towns: self.all())
        request.async(.background, completion: { response in

            if response.isFail {
                if (response.statusCode != .Forbidden && response.statusCode != .ConnectionError) {
                    Log.Warning(self.tag, "Problem with update selected townss.")
                }
            }
            else if response.isSuccess {
                Log.Info(self.tag, "Update selected towns.")
            }
        })
    }
    public func takeFromRemote() {

        let request = client.take()
        request.async(.background, completion: { response in

            if response.isFail {
                if (response.statusCode != .Forbidden && response.statusCode != .ConnectionError) {
                    Log.Warning(self.tag, "Problem with take selected towns.")
                }
            }
            else if response.isSuccess {
                Log.Info(self.tag, "Request selected towns.")

                for townId in response.data! {
                    self.select(TownContainer(townId))
                }
            }
        })
    }

    @objc private func enterToBackground() {
        saveToRemote()
    }
}
extension SelectedTownsService: IEventsEmitter {

    public func subscribe(guid: String, handler: SelectedTownsServiceDelegate, tag: String) {
        eventsAdapter.subscribe(guid: guid, handler: handler, tag: tag)
    }
    public func unsubscribe(guid: String) {
        eventsAdapter.unsubscribe(guid: guid)
    }
}
extension SelectedTownsServiceDelegate {

    func selectedTownsService(_ :SelectedTownsService, select: Long) { }
    func selectedTownsService(_ :SelectedTownsService, unselect: Long) { }
}
private class TownContainer: ICached {

    public let ID: Long

    public init(_ id: Long) {
        self.ID = id
    }
    public init(for town: Town) {
        self.ID = town.ID
    }

    //MARK: ICopying
    public required init(source: TownContainer) {
        self.ID = source.ID
    }

    //MARK: Glossy
    public required init?(json: JSON) {
        self.ID = (BaseDataType.Keys.ID <~~ json)!
    }
    public func toJSON() -> JSON? {
        return jsonify([
            BaseDataType.Keys.ID ~~> self.ID
        ])
    }
}
