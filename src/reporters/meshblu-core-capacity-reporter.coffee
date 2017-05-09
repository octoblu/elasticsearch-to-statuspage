_     = require 'lodash'
query = require '../queries/meshblu-core-capacity.cson'
debug   = require('debug')('octoblu-metrics-elasticsearch-to-statuspage:meshblu-core-capacity')

METRIC_IDS=
  'hpe': '28tpsdvd6nx7'
  'major': '4d6vcs17cyps'
  'minor': '4d6vcs17cyps'

class MeshbluCoreCapacityReporter
  constructor: ({@cluster,@client,@statusPageReporter}) ->
    throw new Error 'Missing cluster' unless @cluster?
    throw new Error 'Missing client' unless @client?
    throw new Error 'Missing statusPageReporter' unless @statusPageReporter?

    @metricId = METRIC_IDS[@cluster]
    throw new Error 'Missing Metric ID for cluster' unless @metricId?

  search: (callback) =>
    @client.search query, (error, results, statusCode) =>
      return callback error if error?
      {buckets} = results.aggregations?.recent.byType
      results = {total: 0}
      _.each buckets, (bucket) =>
        {value} = bucket.sumElapsedTime
        key = bucket.key.replace /meshblu-core-dispatcher:/, ''
        results.total += value
        results[key] = value
      callback null, results

  run: (callback) =>
    @search (error, results) =>
      return callback error if error?

      results.job ?= 0
      value = Math.floor((results.job / results.total) * 100)
      value = 0 if _.isNaN value
      data =
        timestamp: Date.now() / 1000
        value: value
      debug 'reporting', data
      @statusPageReporter.post @metricId, data, callback

module.exports = MeshbluCoreCapacityReporter
