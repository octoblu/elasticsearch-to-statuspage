_     = require 'lodash'
query = require '../queries/meshblu-amqp-average-response-time.cson'

METRIC_IDS=
  'hpe': 'w5vkpwrj6f6g'
  'major': 'qj4d433j0sp2'
  'minor': 'qj4d433j0sp2'

class MeshbluAmqpAverageResponseTimeReporter
  constructor: ({@cluster,@client,@statusPageReporter}) ->
    throw new Error 'Missing cluster' unless @cluster?
    throw new Error 'Missing client' unless @client?
    throw new Error 'Missing statusPageReporter' unless @statusPageReporter?

    @metricId = METRIC_IDS[@cluster]
    throw new Error 'Missing Metric ID for cluster' unless @metricId?

  search: (callback) =>
    @client.search query, (error, results, statusCode) =>
      callback null, results.aggregations?.recent.avg.value

  run: (callback) =>
    @search (error, results) =>
      return callback error if error?

      value = Math.floor(results ? 0)

      data =
        timestamp: Date.now() / 1000
        value: value

      @statusPageReporter.post @metricId, data, callback

module.exports = MeshbluAmqpAverageResponseTimeReporter
