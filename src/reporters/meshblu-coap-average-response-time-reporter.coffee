_ = require 'lodash'
StatusPageReporter = require './statuspage-reporter'
meshbluCoapAverageResponseTimeQuery = require '../queries/meshblu-coap-average-response-time.cson'

class MeshbluCoapAverageResponseTimeReporter extends StatusPageReporter
  page_id: 'c3jcws6d2z45'
  metric_id: '4phn8v4njdlt'

  search: (callback) =>
    @client.search meshbluCoapAverageResponseTimeQuery, (error, results, statusCode) =>
      callback null, results.aggregations?.recent.avg.value

  run: (callback) =>
    @search (error, results) =>
      return callback error if error?

      value = Math.floor(results ? 0)

      data =
        timestamp: Date.now() / 1000
        value: value

      @post data, callback

module.exports = MeshbluCoapAverageResponseTimeReporter
