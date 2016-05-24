_ = require 'lodash'
StatusPageReporter = require './statuspage-reporter'
meshbluWebsocketAverageResponseTimeQuery = require '../queries/meshblu-websocket-average-response-time.cson'

class MeshbluWebsocketAverageResponseTimeReporter extends StatusPageReporter
  page_id: 'c3jcws6d2z45'
  metric_id: 'srms68y38p3n'

  search: (callback) =>
    @client.search meshbluWebsocketAverageResponseTimeQuery, (error, results, statusCode) =>
      callback null, results.aggregations?.recent.avg.value

  run: (callback) =>
    @search (error, results) =>
      return callback error if error?

      value = Math.floor(results ? 0)

      data =
        timestamp: Date.now() / 1000
        value: value

      @post data, callback

module.exports = MeshbluWebsocketAverageResponseTimeReporter
