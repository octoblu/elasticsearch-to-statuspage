_ = require 'lodash'
StatusPageReporter = require './statuspage-reporter'
meshbluXmppAverageResponseTimeQuery = require '../queries/meshblu-xmpp-average-response-time.cson'

class MeshbluXmppAverageResponseTimeReporter extends StatusPageReporter
  page_id: 'c3jcws6d2z45'
  metric_id: 'wqq7tff28d2z'

  search: (callback) =>
    @client.search meshbluXmppAverageResponseTimeQuery, (error, results, statusCode) =>
      callback null, results.aggregations?.recent.avg.value

  run: (callback) =>
    @search (error, results) =>
      return callback error if error?

      value = Math.floor(results ? 0)

      data =
        timestamp: Date.now() / 1000
        value: value

      @post data, callback

module.exports = MeshbluXmppAverageResponseTimeReporter
