_ = require 'lodash'
StatusPageReporter = require './statuspage-reporter'
meshbluCoreJobCountQuery = require '../queries/meshblu-core-job-count.cson'

class MeshbluCoreJobCountReporter extends StatusPageReporter
  page_id: 'c3jcws6d2z45'
  metric_id: '7xjrf0gpcn2s'

  search: (callback) =>
    @client.count meshbluCoreJobCountQuery, (error, results, statusCode) =>
      callback null, results.count

  run: (callback) =>
    @search (error, results) =>
      return callback error if error?

      # sample-rate 0.001
      value = Math.floor((results * 1000) / 60)

      data =
        timestamp: Date.now() / 1000
        value: value

      @post data, callback

module.exports = MeshbluCoreJobCountReporter
