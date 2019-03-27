import Vapor

/// Default implementation of `TerminateError`.
///
///     throw Terminate(.badRequest, code: "somethingWasWrong", reason: "Something's not quite right...")
///
public struct Terminate: TerminateError {

    public var identifier: String

    public var status: HTTPResponseStatus
    public var headers: HTTPHeaders
    public var reason: String
    public var code: String

    public var sourceLocation: SourceLocation?
    public var stackTrace: [String]
    public var suggestedFixes: [String]

    /// Create a new `Terminate`, capturing current source location info.
    public init(
        _ status: HTTPResponseStatus,
        headers: HTTPHeaders = [:],
        code: String,
        reason: String? = nil,
        identifier: String? = nil,
        suggestedFixes: [String] = [],
        file: String = #file,
        function: String = #function,
        line: UInt = #line,
        column: UInt = #column
    ) {
        self.identifier = status.code.description
        self.headers = headers
        self.code = code
        self.status = status
        self.reason = reason ?? status.reasonPhrase
        self.suggestedFixes = suggestedFixes
        self.sourceLocation = SourceLocation(file: file, function: function, line: line, column: column, range: nil)
        self.stackTrace = Terminate.makeStackTrace()
    }
}
