import Foundation

public protocol QalamLoggable: Sendable, RawRepresentable, CaseIterable where RawValue == String {}
