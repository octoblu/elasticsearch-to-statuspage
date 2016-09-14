_     = require 'lodash'
query = require '../queries/meshblu-core-job-count.cson'

METRIC_IDS=
  'hpe': 'y8cv8jgjfs9p'
  'major': '7xjrf0gpcn2s'
  'minor': '7xjrf0gpcn2s'

class MeshbluCoreJobCountReporter
  constructor: ({@cluster,@client,@statusPageReporter}) ->
    throw new Error 'Missing cluster' unless @cluster?
    throw new Error 'Missing client' unless @client?
    throw new Error 'Missing statusPageReporter' unless @statusPageReporter?

    @metricId = METRIC_IDS[@cluster]
    throw new Error 'Missing Metric ID for cluster' unless @metricId?

  search: (callback) =>
    @client.count query, (error, results, statusCode) =>
      callback null, results.count

  run: (callback) =>
    @search (error, results) =>
      return callback error if error?

      # sample-rate 0.01
      value = Math.floor((results * 100) / 60)

      data =
        timestamp: Date.now() / 1000
        value: value

      @statusPageReporter.post @metricId, data, callback

module.exports = MeshbluCoreJobCountReporter
