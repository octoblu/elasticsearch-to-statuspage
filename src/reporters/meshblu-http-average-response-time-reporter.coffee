_     = require 'lodash'
query = require '../queries/meshblu-http-average-response-time.cson'
debug   = require('debug')('octoblu-metrics-elasticsearch-to-statuspage:meshblu-http-average-response-time')
METRIC_IDS=
  'hpe': 'qbqdr66g7fjq'
  'major': 'qhvy6759n5xq'
  'minor': 'qhvy6759n5xq'

class MeshbluHttpAverageResponseTimeReporter
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

module.exports = MeshbluHttpAverageResponseTimeReporter
