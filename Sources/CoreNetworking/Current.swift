import Foundation
import OSLog

let Current = World()

struct World {
    var logger: Logger { Logger(subsystem: "CoreNetworking", category: "CoreNetworking") }
}
