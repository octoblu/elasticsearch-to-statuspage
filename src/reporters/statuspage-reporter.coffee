_       = require 'lodash'
request = require 'request'
async   = require 'async'
debug   = require('debug')('octoblu-metrics-elasticsearch-to-statuspage:statuspage-reporter')

class StatusPageReporter
  constructor: ({@client,@statusPageApiKey,@pageId,@dryRun}) ->
    debug 'constructed'
    @post = @_postRetry

  _postRetry: (metricId, data, callback) =>
    retryOptions = { times: 3, interval: 1000 }
    async.retry retryOptions, async.apply(@_post, metricId, data), callback

  _post: (metricId, data, callback) =>
    debug '_post', { metricId, data }
    options =
      headers:
        Authorization: "OAuth #{@statusPageApiKey}"
      url: "https://api.statuspage.io/v1/pages/#{@pageId}/metrics/#{metricId}/data.json"
      json: {data}

    if @dryRun
      console.log "Request would be:", options
      return callback()

    request.post options, (error, response, body) =>
      debug '_post result', { error, statusCode: response?.statusCode, body }
      return callback error if error?
      return callback new Error('update failed') if response.statusCode > 399
      callback()

module.exports = StatusPageReporter
