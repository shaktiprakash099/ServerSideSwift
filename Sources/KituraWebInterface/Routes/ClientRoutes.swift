import Foundation
import KituraStencil
import Kitura

func initializeClientRoutes(app: App) {
  // 1
  app.router.setDefault(templateEngine: StencilTemplateEngine())
  // 2
  app.router.all(middleware: StaticFileServer())
  
  // 3
    app.router.get("/") { _, response, _ in
        if let database = app.database {
            // 1
            Acronym.Persistence.getAll(from: database) { acronyms, error in
                guard let acronyms = acronyms else {
                    response.send(error?.localizedDescription)
                    return
                }
                var contextAcronyms: [[String: Any]] = []
                for acronym in acronyms {
                    // 2
                    if let id = acronym.id {
                        // 3
                        let map = ["short": acronym.short, "long": acronym.long, "id": id]
                        contextAcronyms.append(map)
                    }
                }
                // 4
                do {
                    try response.render("home", context: ["acronyms": contextAcronyms])
                } catch let error {
                    response.send(error.localizedDescription)
                }
            }
        }
    }
}
