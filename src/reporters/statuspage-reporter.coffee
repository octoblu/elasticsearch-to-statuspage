request = require 'request'
elasticsearch = require 'elasticsearch'

class StatusPageReporter
  constructor: ({@elasticsearch_uri, @statuspage_api_key}) ->
    @client = elasticsearch.Client {host: @elasticsearch_uri}

  post: (data, callback) =>
    options =
      headers:
        Authorization: "OAuth #{@statuspage_api_key}"
      url: "https://api.statuspage.io/v1/pages/#{@page_id}/metrics/#{@metric_id}/data.json"
      json: {data}

    request.post options, (error, response, body) =>
      return callback error if error?
      return callback new Error('Update Failed') if response.statusCode > 399
      callback()

module.exports = StatusPageReporter
