_             = require 'lodash'
async         = require 'async'
elasticsearch = require 'elasticsearch'
debug         = require('debug')('octoblu-metrics-elasticsearch-to-statuspage:reporter-runner')

MeshbluCoreCapacityReporter                 = require './reporters/meshblu-core-capacity-reporter'
MeshbluCoreAverageResponseTimeReporter      = require './reporters/meshblu-core-average-response-time-reporter'
MeshbluHttpAverageResponseTimeReporter      = require './reporters/meshblu-http-average-response-time-reporter'
MeshbluSocketIOAverageResponseTimeReporter  = require './reporters/meshblu-socket-io-average-response-time-reporter'
MeshbluWebsocketAverageResponseTimeReporter = require './reporters/meshblu-websocket-average-response-time-reporter'
MeshbluMqttAverageResponseTimeReporter      = require './reporters/meshblu-mqtt-average-response-time-reporter'
MeshbluXmppAverageResponseTimeReporter      = require './reporters/meshblu-xmpp-average-response-time-reporter'
MeshbluAmqpAverageResponseTimeReporter      = require './reporters/meshblu-amqp-average-response-time-reporter'
MeshbluCoapAverageResponseTimeReporter      = require './reporters/meshblu-coap-average-response-time-reporter'
MeshbluCoreJobCountReporter                 = require './reporters/meshblu-core-job-count-reporter'
NanoctyeEngineCapacityReporter              = require './reporters/nanocyte-engine-capacity-reporter'
StatusPageReporter                          = require './reporters/statuspage-reporter'

class ReporterRunner
  constructor: ({elasticSearchUri,dryRun,cluster,statusPageApiKey,pageId,intervalSeconds,forever}) ->
    throw new Error 'Missing elasticSearchUri' unless elasticSearchUri?
    throw new Error 'Missing cluster' unless cluster?
    throw new Error 'Missing statusPageApiKey' unless statusPageApiKey?
    throw new Error 'Missing pageId' unless pageId?
    client = elasticsearch.Client {host: elasticSearchUri, dryRun}
    statusPageReporter = new StatusPageReporter {client,pageId,statusPageApiKey,dryRun}
    @intervalSeconds = intervalSeconds ? 60
    @forever = forever ? false

    @meshbluCoreCapacityReporter = new MeshbluCoreCapacityReporter {cluster,client,statusPageReporter}
    @meshbluCoreAverageResponseTimeReporter = new MeshbluCoreAverageResponseTimeReporter {cluster,client,statusPageReporter}
    @meshbluHttpAverageResponseTimeReporter = new MeshbluHttpAverageResponseTimeReporter {cluster,client,statusPageReporter}
    @meshbluSocketIOAverageResponseTimeReporter = new MeshbluSocketIOAverageResponseTimeReporter {cluster,client,statusPageReporter}
    @meshbluWebsocketAverageResponseTimeReporter = new MeshbluWebsocketAverageResponseTimeReporter {cluster,client,statusPageReporter}
    @meshbluMqttAverageResponseTimeReporter = new MeshbluMqttAverageResponseTimeReporter {cluster,client,statusPageReporter}
    @meshbluXmppAverageResponseTimeReporter = new MeshbluXmppAverageResponseTimeReporter {cluster,client,statusPageReporter}
    @meshbluAmqpAverageResponseTimeReporter = new MeshbluAmqpAverageResponseTimeReporter {cluster,client,statusPageReporter}
    @meshbluCoapAverageResponseTimeReporter = new MeshbluCoapAverageResponseTimeReporter {cluster,client,statusPageReporter}
    @meshbluCoreJobCountReporter = new MeshbluCoreJobCountReporter {cluster,client,statusPageReporter}
    @nanocyteEngineCapacityReporter = new NanoctyeEngineCapacityReporter {cluster,client,statusPageReporter}

  run: (callback) =>
    return @_runForever callback if @forever
    @_run callback

  _runForever: (callback) =>
    debug 'will run forever'
    @_run (error) =>
      debug 'first run', { error }
      return callback error if error?
      debug 'running forever...'
      async.forever @_runWithDelay, callback

  _runWithDelay: (callback) =>
    intervalMs = @intervalSeconds * 1000
    debug 'delaying for', intervalMs
    _.delay @_run, intervalMs, callback

  _run: (callback) =>
    debug 'running...'
    tasks = [
      async.apply @meshbluCoreCapacityReporter.run
      async.apply @meshbluCoreAverageResponseTimeReporter.run
      async.apply @meshbluHttpAverageResponseTimeReporter.run
      async.apply @meshbluSocketIOAverageResponseTimeReporter.run
      async.apply @meshbluWebsocketAverageResponseTimeReporter.run
      async.apply @meshbluMqttAverageResponseTimeReporter.run
      async.apply @meshbluXmppAverageResponseTimeReporter.run
      async.apply @meshbluAmqpAverageResponseTimeReporter.run
      async.apply @meshbluCoapAverageResponseTimeReporter.run
      async.apply @meshbluCoreJobCountReporter.run
      async.apply @nanocyteEngineCapacityReporter.run
    ]
    async.series tasks, (error) =>
      debug 'run done', { error }
      return callback error if error?
      callback null

module.exports = ReporterRunner
