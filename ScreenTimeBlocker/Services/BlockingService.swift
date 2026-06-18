import Foundation
import FamilyControls
import ManagedSettings

protocol BlockingService {
    var isRealImplementation: Bool { get }
    func requestAuthorization() async throws -> Bool
    func getAuthorizationStatus() -> String
    func blockApps(_ selection: FamilyActivitySelection)
    func unblockApps()
}

@available(iOS 15.0, *)
class RealBlockingService: BlockingService {
    let isRealImplementation = true
    private let store = ManagedSettingsStore()
    
    func requestAuthorization() async throws -> Bool {
        try await AuthorizationCenter.shared.requestAuthorization(for: .individual)
        return AuthorizationCenter.shared.authorizationStatus == .approved
    }
    
    func getAuthorizationStatus() -> String {
        let status = AuthorizationCenter.shared.authorizationStatus
        switch status {
        case .notDetermined: return "Not Determined"
        case .denied: return "Denied"
        case .approved: return "Approved"
        @unknown default: return "Unknown"
        }
    }
    
    func blockApps(_ selection: FamilyActivitySelection) {
        store.shield.applications = selection.applicationTokens.isEmpty ? nil : selection.applicationTokens
        store.shield.applicationCategories = selection.categoryTokens.isEmpty ? nil : .specific(selection.categoryTokens)
    }
    
    func unblockApps() {
        store.shield.applications = nil
        store.shield.applicationCategories = nil
    }
}

class MockBlockingService: BlockingService {
    let isRealImplementation = false
    private var blockedAppCount = 0
    
    func requestAuthorization() async throws -> Bool {
        print("🔧 [MOCK] Simulating authorization request...")
        try await Task.sleep(nanoseconds: 500_000_000)
        print("✅ [MOCK] Authorization granted")
        return true
    }
    
    func getAuthorizationStatus() -> String {
        return "Approved (Mock)"
    }
    
    func blockApps(_ selection: FamilyActivitySelection) {
        blockedAppCount = selection.applicationTokens.count
        print("🚫 [MOCK] Blocking \(blockedAppCount) apps")
    }
    
    func unblockApps() {
        print("✅ [MOCK] Unblocking all apps")
        blockedAppCount = 0
    }
}

class BlockingServiceFactory {
    static func create() -> BlockingService {
        #if targetEnvironment(simulator)
        print("🔧 Running in simulator - using mock service")
        return MockBlockingService()
        #else
        if canUseRealService() {
            print("✅ Using real Screen Time API")
            return RealBlockingService()
        } else {
            print("⚠️ Real Screen Time API unavailable - using mock")
            return MockBlockingService()
        }
        #endif
    }
    
    private static func canUseRealService() -> Bool {
        if #available(iOS 15.0, *) {
            do {
                let _ = AuthorizationCenter.shared.authorizationStatus
                return true
            } catch {
                return false
            }
        }
        return false
    }
}