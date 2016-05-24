_ = require 'lodash'
StatusPageReporter = require './statuspage-reporter'
meshbluSocketIOAverageResponseTimeQuery = require '../queries/meshblu-socket-io-average-response-time.cson'

class MeshbluSocketIOAverageResponseTimeReporter extends StatusPageReporter
  page_id: 'c3jcws6d2z45'
  metric_id: 't9j454w95wj2'

  search: (callback) =>
    @client.search meshbluSocketIOAverageResponseTimeQuery, (error, results, statusCode) =>
      callback null, results.aggregations?.recent.avg.value

  run: (callback) =>
    @search (error, results) =>
      return callback error if error?

      value = Math.floor(results)

      data =
        timestamp: Date.now() / 1000
        value: value

      @post data, callback

module.exports = MeshbluSocketIOAverageResponseTimeReporter
