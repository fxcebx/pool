#' @include DBI.R
NULL

#' DBIConnection methods.
#'
#' Pool object wrappers around DBIConnection methods. For the original
#' documentation, see:
#' \itemize{
#'  \item \code{\link[DBI]{dbSendQuery}}
#'  \item \code{\link[DBI]{dbGetQuery}}
#'  \item \code{\link[DBI]{dbListResults}}
#'  \item \code{\link[DBI]{dbListFields}}
#'  \item \code{\link[DBI]{dbListTables}}
#'  \item \code{\link[DBI]{dbReadTable}}
#'  \item \code{\link[DBI]{dbWriteTable}}
#'  \item \code{\link[DBI]{dbExistsTable}}
#'  \item \code{\link[DBI]{dbRemoveTable}}
#' }
#'
#' @name DBI-connection
NULL

## Throw error here since this would require keeping a connection
## open and never releasing it back to the pool.
#' @param conn,statement,... See \code{\link[DBI]{dbSendQuery}}.
#' @export
#' @rdname DBI-connection
setMethod("dbSendQuery", "Pool", function(conn, statement, ...) {
  stop("Must use `conn <- pool$fetch(); dbSendQuery(conn, statement, ...)` ",
       "instead. Remember to `release(conn)` when `conn` is no longer ",
       "necessary.")
})

## Always use this, except if dealing with transactions that
## cannot be dealt with using withTransaction(...)
#' @export
#' @rdname DBI-connection
setMethod("dbGetQuery", "Pool", function(conn, statement, ...) {
  connection <- conn$fetch()
  on.exit(release(connection))
  DBI::dbGetQuery(connection, statement, ...)
})

#' @export
#' @rdname DBI-connection
setMethod("dbListResults", "Pool", function(conn, ...) {
  list()
})

#' @export
#' @rdname DBI-connection
setMethod("dbListFields", "Pool", function(conn, name, ...) {
  connection <- conn$fetch()
  on.exit(release(connection))
  DBI::dbListFields(connection, name)
})

#' @export
#' @rdname DBI-connection
setMethod("dbListTables", "Pool", function(conn, ...) {
  connection <- conn$fetch()
  on.exit(release(connection))
  DBI::dbListTables(connection)
})

#' @export
#' @rdname DBI-connection
setMethod("dbReadTable", "Pool", function(conn, name, ...) {
  connection <- conn$fetch()
  on.exit(release(connection))
  DBI::dbReadTable(connection, name, ...)
})

#' @param name,value See \code{\link[DBI]{dbWriteTable}}.
#' @export
#' @rdname DBI-connection
setMethod("dbWriteTable", "Pool", function(conn, name, value, ...) {
  connection <- conn$fetch()
  on.exit(release(connection))
  DBI::dbWriteTable(connection, name, value, ...)
})

#' @export
#' @rdname DBI-connection
setMethod("dbExistsTable", "Pool", function(conn, name, ...) {
  connection <- conn$fetch()
  on.exit(release(connection))
  DBI::dbExistsTable(connection, name, ...)
})

#' @export
#' @rdname DBI-connection
setMethod("dbRemoveTable", "Pool", function(conn, name, ...) {
  connection <- conn$fetch()
  on.exit(release(connection))
  DBI::dbRemoveTable(connection, name, ...)
})