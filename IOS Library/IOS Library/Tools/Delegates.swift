//
//  Delegates.swift
//  IOSLibrary
//
//  Created by Алексей on 21.12.17.
//  Copyright © 2017 Medved-Studio. All rights reserved.
//

import Foundation

public typealias Trigger = (() -> Void)
public typealias Action<T1> = ((T1) ->  Void)

public typealias Function<T1, T2> = ((T1) -> T2)
public typealias Predicate<T1> = Function<T1, Bool>

