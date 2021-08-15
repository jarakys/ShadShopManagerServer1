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
    app.migrations.add(InitialInstagramData())
    app.migrations.add(InitialGoodsInfoData())
    app.migrations.add(InitialConnectedServicesDb())
    app.logger.logLevel = .debug
    app.jwt.signers.use(.hs256(key: "O484ZLGkf9vrNbNXTFI6GSHapULJOdF9"))
    try app.autoMigrate().wait()
    try routes(app)
}


private func configureDbSchemas() {
    
}
