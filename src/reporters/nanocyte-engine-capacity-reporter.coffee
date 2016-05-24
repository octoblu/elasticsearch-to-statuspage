_ = require 'lodash'
StatusPageReporter = require './statuspage-reporter'
nanocyteEngineCapacityQuery = require '../queries/nanocyte-engine-capacity.cson'

class NanocyteEngineCapacityReporter extends StatusPageReporter
  page_id: 'c3jcws6d2z45'
  metric_id: 'c106mdk7qwyg'

  search: (callback) =>
    @client.search nanocyteEngineCapacityQuery, (error, results, statusCode) =>
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

      value = Math.floor((results.job / results.total) * 100)
      data =
        timestamp: Date.now() / 1000
        value: value

      @post data, callback

module.exports = NanocyteEngineCapacityReporter
