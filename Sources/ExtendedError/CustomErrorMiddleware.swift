//
//  CustomErrorMiddleware.swift
//  Letterer/ExtendedError
//
//  Created by Marcin Czachurski on 14/11/2018.
//

import Vapor

/// Captures all errors and transforms them into an internal server error HTTP response.
public final class CustomErrorMiddleware: Middleware, ServiceType {

    /// Structure of `CustomErrorMiddleware` default response.
    internal struct ErrorResponse: Codable {
        /// Always `true` to indicate this is a non-typical JSON response.
        var error: Bool

        /// The reason for the error.
        var reason: String

        // The code of the reason.
        var code: String?
    }

    /// See `ServiceType`.
    public static func makeService(for worker: Container) throws -> CustomErrorMiddleware {
        return try .default(environment: worker.environment, log: worker.make())
    }

    /// Create a `CustomErrorMiddleware`. Logs errors to a `Logger` based on `Environment`
    /// and converts `Error` to `Response` based on conformance to `AbortError` and `Debuggable`.
    ///
    /// - parameters:
    ///     - environment: The environment to respect when presenting errors.
    ///     - log: Log destination.
    public static func `default`(environment: Environment, log: Logger) -> CustomErrorMiddleware {
        return .init { req, error in
            // log the error
            log.report(error: error, verbose: !environment.isRelease)

            // variables to determine
            let status: HTTPResponseStatus
            let reason: String
            let headers: HTTPHeaders
            let code: String?

            // inspect the error type
            switch error {
            case let terminate as TerminateError:
                // this is an terminate error, we should use its status, reason, code, and headers
                reason = terminate.reason
                status = terminate.status
                headers = terminate.headers
                code = terminate.code
            case let abort as AbortError:
                // this is an abort error, we should use its status, reason, and headers
                reason = abort.reason
                status = abort.status
                headers = abort.headers
                code = "abortError"
            case let validation as ValidationError:
                // this is a validation error
                reason = validation.reason
                status = .badRequest
                headers = [:]
                code = "validationError"
            case let debuggable as Debuggable where !environment.isRelease:
                // if not release mode, and error is debuggable, provide debug
                // info directly to the developer
                reason = debuggable.reason
                status = .internalServerError
                headers = [:]
                code = "internalApplicationError"
            default:
                // not an abort error, and not debuggable or in dev mode
                // just deliver a generic 500 to avoid exposing any sensitive error info
                reason = "Something went wrong."
                status = .internalServerError
                headers = [:]
                code = "internalApplicationError"
            }

            // create a Response with appropriate status
            let res = req.response(http: .init(status: status, headers: headers))

            // attempt to serialize the error to json
            do {
                let errorResponse = ErrorResponse(error: true, reason: reason, code: code)
                res.http.body = try HTTPBody(data: JSONEncoder().encode(errorResponse))
                res.http.headers.replaceOrAdd(name: .contentType, value: "application/json; charset=utf-8")
            } catch {
                res.http.body = HTTPBody(string: "Oops: \(error)")
                res.http.headers.replaceOrAdd(name: .contentType, value: "text/plain; charset=utf-8")
            }
            return res
        }
    }

    /// Error-handling closure.
    private let closure: (Request, Error) -> (Response)

    /// Create a new `CustomErrorMiddleware`.
    ///
    /// - parameters:
    ///     - closure: Error-handling closure. Converts `Error` to `Response`.
    public init(_ closure: @escaping (Request, Error) -> (Response)) {
        self.closure = closure
    }

    /// See `Middleware`.
    public func respond(to req: Request, chainingTo next: Responder) throws -> Future<Response> {
        let response: Future<Response>
        do {
            response = try next.respond(to: req)
        } catch {
            response = req.eventLoop.newFailedFuture(error: error)
        }

        return response.mapIfError { error in
            return self.closure(req, error)
        }
    }
}
