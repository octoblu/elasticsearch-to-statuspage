_     = require 'lodash'
query = require '../queries/meshblu-socket-io-average-response-time.cson'
debug   = require('debug')('octoblu-metrics-elasticsearch-to-statuspage:meshblu-socket-io-average-response-time')

METRIC_IDS=
  'hpe': '8fwcsp185c11'
  'major': 't9j454w95wj2'
  'minor': 't9j454w95wj2'

class MeshbluSocketIOAverageResponseTimeReporter
  constructor: ({@cluster,@client,@statusPageReporter}) ->
    throw new Error 'Missing cluster' unless @cluster?
    throw new Error 'Missing client' unless @client?
    throw new Error 'Missing statusPageReporter' unless @statusPageReporter?

    @metricId = METRIC_IDS[@cluster]
    throw new Error 'Missing Metric ID for cluster' unless @metricId?

  search: (callback) =>
    @client.search query, (error, results, statusCode) =>
      return callback error if error?
      callback null, results.aggregations?.recent.avg.value

  run: (callback) =>
    @search (error, results) =>
      return callback error if error?

      value = Math.floor(results ? 0)

      data =
        timestamp: Date.now() / 1000
        value: value

      debug 'reporting', data
      @statusPageReporter.post @metricId, data, callback

module.exports = MeshbluSocketIOAverageResponseTimeReporter
