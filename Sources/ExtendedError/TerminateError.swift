//
//  TerminateError.swift
//  Letterer/ExtendedError
//
//  Created by Marcin Czachurski on 14/11/2018.
//

import Vapor

public protocol TerminateError: AbortError {
    var code: String { get }
}
