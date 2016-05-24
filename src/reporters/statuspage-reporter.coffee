request = require 'request'
elasticsearch = require 'elasticsearch'

class StatusPageReporter
  constructor: ({@elasticsearch_uri, @statuspage_api_key, @dry_run}) ->
    @client = elasticsearch.Client {host: @elasticsearch_uri, @dry_run}

  post: (data, callback) =>
    options =
      headers:
        Authorization: "OAuth #{@statuspage_api_key}"
      url: "https://api.statuspage.io/v1/pages/#{@page_id}/metrics/#{@metric_id}/data.json"
      json: {data}

    if @dry_run
      console.log "Request would be:", options
      return callback()

    request.post options, (error, response, body) =>
      return callback error if error?
      return callback new Error('Update Failed') if response.statusCode > 399
      callback()

module.exports = StatusPageReporter
