import Vapor

/// Default implementation of `TerminateError`.
///
///     throw Terminate(.badRequest, code: "somethingWasWrong", reason: "Something's not quite right...")
///
public struct Terminate: TerminateError {

    /// HTTP response status (400/401/403 etc.).
    public let status: HTTPResponseStatus
    
    /// Custom response headers.
    public let headers: HTTPHeaders
    
    /// Error code.
    public let code: String
    
    /// Error reason.
    public let reason: String
    
    /// Fixes suggested for user.
    public let suggestedFixes: [String]

    /// Error location in the source.
    public let sourceLocation: SourceLocation?
    
    /// Current stack trace.
    public let stackTrace: [String]

    /// Create a new `Terminate`, capturing current source location info.
    public init(
        _ status: HTTPResponseStatus,
        headers: HTTPHeaders = [:],
        code: String,
        reason: String? = nil,
        suggestedFixes: [String] = [],
        file: String = #file,
        function: String = #function,
        line: UInt = #line,
        column: UInt = #column
    ) {
        self.status = status
        self.headers = headers
        self.code = code
        self.reason = reason ?? status.reasonPhrase
        self.suggestedFixes = suggestedFixes
        self.sourceLocation = SourceLocation(file: file, function: function, line: line, column: column, range: nil)
        self.stackTrace = Thread.callStackSymbols
    }
}
