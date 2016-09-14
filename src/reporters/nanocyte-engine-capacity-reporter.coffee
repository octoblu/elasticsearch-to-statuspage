_     = require 'lodash'
query = require '../queries/nanocyte-engine-capacity.cson'

METRIC_IDS=
  'hpe': 'bztqsg88cs3g'
  'major': 'c106mdk7qwyg'
  'minor': 'c106mdk7qwyg'

class NanocyteEngineCapacityReporter
  constructor: ({@cluster,@client,@statusPageReporter}) ->
    throw new Error 'Missing cluster' unless @cluster?
    throw new Error 'Missing client' unless @client?
    throw new Error 'Missing statusPageReporter' unless @statusPageReporter?

    @metricId = METRIC_IDS[@cluster]
    throw new Error 'Missing Metric ID for cluster' unless @metricId?

  search: (callback) =>
    @client.search query, (error, results, statusCode) =>
      {buckets} = results.aggregations?.recent.byType
      results = {total: 0}
      _.each buckets, (bucket) =>
        {value} = bucket.sumElapsedTime
        key = bucket.key.replace /metric:nanocyte-engine-simple:/, ''
        results.total += value
        results[key] = value
      callback null, results

  run: (callback) =>
    @search (error, results) =>
      return callback error if error?

      results.job ?= 0
      value = Math.floor((results.job / results.total) * 100)
      data =
        timestamp: Date.now() / 1000
        value: value

      @statusPageReporter.post @metricId, data, callback

module.exports = NanocyteEngineCapacityReporter
