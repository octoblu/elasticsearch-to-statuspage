_ = require 'lodash'
StatusPageReporter = require './statuspage-reporter'
meshbluCoreCapacityQuery = require '../queries/meshblu-core-capacity.cson'

class MeshbluCoreCapacityReporter extends StatusPageReporter
  page_id: 'c3jcws6d2z45'
  metric_id: '4d6vcs17cyps'

  search: (callback) =>
    @client.search meshbluCoreCapacityQuery, (error, results, statusCode) =>
      {buckets} = results.aggregations.recent.byType
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

      value = Math.floor((results.job / results.total) * 100)
      data =
        timestamp: Date.now() / 1000
        value: value

      @post data, callback

module.exports = MeshbluCoreCapacityReporter
