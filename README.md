<p align="center">
<img src="https://user-images.githubusercontent.com/1342803/36623515-7293b4ec-18d3-11e8-85ab-4e2f8fb38fbd.png" width="320" alt="API Template">
<br>
<br>
<a href="http://docs.vapor.codes/3.0/">
<img src="http://img.shields.io/badge/read_the-docs-2196f3.svg" alt="Documentation">
</a>
<a href="https://discord.gg/vapor">
<img src="https://img.shields.io/discord/431917998102675485.svg" alt="Team Chat">
</a>
<a href="LICENSE">
<img src="http://img.shields.io/badge/license-MIT-brightgreen.svg" alt="MIT License">
</a>
<a href="https://circleci.com/gh/vapor/api-template">
<img src="https://circleci.com/gh/vapor/api-template.svg?style=shield" alt="Continuous Integration">
</a>
<a href="https://swift.org">
<img src="http://img.shields.io/badge/swift-4.1-brightgreen.svg" alt="Swift 4.1">
</a>
</p>

<!--
<img src="http://i.imgur.com/xxxxxxxxx.png" width="80px" />
-->
<h1>Skate-Budapest Vapor Backend</h1>

Simple backend for Skate-Budapest iOS app using Swift with Vapor web framework.


## Specification

- See the [API Documentation](https://balazs630.github.io/Skate-Budapest-Vapor/) (Swagger with ReDoc)
- Preview spec version for branch [`[gh-pages]`](https://github.com/balazs630/Skate-Budapest-Vapor/tree/gh-pages)


## Installation

Install Vapor and PostgreSQL with [Homebrew](https://brew.sh):
```
brew install vapor/tap/vapor
brew install postgresql
```

Clone the project, then execute:
```
vapor update
```

It will download the dependencies and generate an Xcode project for you.


## Deployment

See [this guide](VM%20INSTANCE%20README.md) how I managed to host the service with Google Cloud on Compute Engine VM.


## Uptime check
Using Uptime Robot with endpoint checks in every minute, see [public status page](http://uptimerobot.libertyskate.hu/).

Sends e-mail notification/SMS if the endpoints are down.