import Vapor
import Fluent
import FluentSQLiteDriver

// configures your application
public func configure(_ app: Application) throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    // register routes
    app.databases.use(.sqlite(.file("Data.sqlite")), as: .sqlite)
    try app.register(collection: AuthController())
    app.migrations.add(InititalUserScheme())
    app.logger.logLevel = .debug
    try app.autoMigrate().wait()
    try routes(app)
}


private func configureDbSchemas() {
    
}
