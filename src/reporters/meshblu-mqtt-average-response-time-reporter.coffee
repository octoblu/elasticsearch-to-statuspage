_ = require 'lodash'
StatusPageReporter = require './statuspage-reporter'
meshbluMqttAverageResponseTimeQuery = require '../queries/meshblu-mqtt-average-response-time.cson'

class MeshbluMqttAverageResponseTimeReporter extends StatusPageReporter
  page_id: 'c3jcws6d2z45'
  metric_id: 'n8tkgcd1vy76'

  search: (callback) =>
    @client.search meshbluMqttAverageResponseTimeQuery, (error, results, statusCode) =>
      callback null, results.aggregations?.recent.avg.value

  run: (callback) =>
    @search (error, results) =>
      return callback error if error?

      value = Math.floor(results ? 0)

      data =
        timestamp: Date.now() / 1000
        value: value

      @post data, callback

module.exports = MeshbluMqttAverageResponseTimeReporter
