_ = require 'lodash'
StatusPageReporter = require './statuspage-reporter'
meshbluAverageResponseTimeQuery = require '../queries/meshblu-core-average-response-time.cson'

class MeshbluCoreAverageResponseTimeReporter extends StatusPageReporter
  page_id: 'c3jcws6d2z45'
  metric_id: '55nnqw88pczc'

  search: (callback) =>
    @client.search meshbluAverageResponseTimeQuery, (error, results, statusCode) =>
      callback null, results.aggregations.recent.avg.value

  run: (callback) =>
    @search (error, results) =>
      return callback error if error?

      value = Math.floor(results)

      data =
        timestamp: Date.now() / 1000
        value: value

      @post data, callback

module.exports = MeshbluCoreAverageResponseTimeReporter
