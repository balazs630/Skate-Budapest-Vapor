//
//  configure.swift
//  SkateBudapestBackend
//
//  Created by Horváth Balázs on 2018. 11. 21..
//

import Vapor
import SQLite
import FluentSQLite

public func configure(_ config: inout Config, _ env: inout Environment, _ services: inout Services) throws {
    try registerEngineRouter(to: &services)
    registerMiddlewares(to: &services)

    let directory = DirectoryConfig.detect()
    let filePath = directory.workDir + "skate-budapest.db"
    let sqlite = try SQLiteDatabase(storage: .file(path: filePath))

    var databases = DatabasesConfig()
    databases.add(database: sqlite, as: .sqlite)
    services.register(databases)

    try services.register(FluentSQLiteProvider())

    let migrations = MigrationConfig()
    services.register(migrations)
}

private func registerEngineRouter(to services: inout Services) throws {
    let router = EngineRouter.default()
    try routes(router)

    services.register(router, as: Router.self)
}

private func registerMiddlewares(to services: inout Services) {
    var middlewares = MiddlewareConfig()
    // Serves files from `Public/` directory
    middlewares.use(FileMiddleware.self)

    // Catches errors and converts to HTTP response
    middlewares.use(ErrorMiddleware.self)

    services.register(middlewares)
}
