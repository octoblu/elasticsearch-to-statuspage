request = require 'request'

class StatusPageReporter
  constructor: ({@client,@statusPageApiKey,@pageId,@dryRun}) ->

  post: (metricId, data, callback) =>
    options =
      headers:
        Authorization: "OAuth #{@statusPageApiKey}"
      url: "https://api.statuspage.io/v1/pages/#{@pageId}/metrics/#{metricId}/data.json"
      json: {data}

    if @dryRun
      console.log "Request would be:", options
      return callback()

    request.post options, (error, response, body) =>
      return callback error if error?
      return callback new Error('update failed') if response.statusCode > 399
      callback()

module.exports = StatusPageReporter
