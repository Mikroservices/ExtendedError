import Vapor

public protocol TerminateError: AbortError {
    var code: String { get }
}
