_ = require 'lodash'
StatusPageReporter = require './statuspage-reporter'
meshbluAmqpAverageResponseTimeQuery = require '../queries/meshblu-amqp-average-response-time.cson'

class MeshbluAmqpAverageResponseTimeReporter extends StatusPageReporter
  page_id: 'c3jcws6d2z45'
  metric_id: 'qj4d433j0sp2'

  search: (callback) =>
    @client.search meshbluAmqpAverageResponseTimeQuery, (error, results, statusCode) =>
      callback null, results.aggregations?.recent.avg.value

  run: (callback) =>
    @search (error, results) =>
      return callback error if error?

      value = Math.floor(results ? 0)

      data =
        timestamp: Date.now() / 1000
        value: value

      @post data, callback

module.exports = MeshbluAmqpAverageResponseTimeReporter
