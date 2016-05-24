_ = require 'lodash'
StatusPageReporter = require './statuspage-reporter'
meshbluHttpAverageResponseTimeQuery = require '../queries/meshblu-http-average-response-time.cson'

class MeshbluHttpAverageResponseTimeReporter extends StatusPageReporter
  page_id: 'c3jcws6d2z45'
  metric_id: 'qhvy6759n5xq'

  search: (callback) =>
    @client.search meshbluHttpAverageResponseTimeQuery, (error, results, statusCode) =>
      callback null, results.aggregations.recent.avg.value

  run: (callback) =>
    @search (error, results) =>
      return callback error if error?

      value = Math.floor(results)

      data =
        timestamp: Date.now() / 1000
        value: value

      @post data, callback

module.exports = MeshbluHttpAverageResponseTimeReporter
