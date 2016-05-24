async = require 'async'
MeshbluCoreCapacityReporter = require './reporters/meshblu-core-capacity-reporter'
MeshbluCoreAverageResponseTimeReporter = require './reporters/meshblu-core-average-response-time-reporter'
MeshbluHttpAverageResponseTimeReporter = require './reporters/meshblu-http-average-response-time-reporter'
MeshbluSocketIOAverageResponseTimeReporter = require './reporters/meshblu-socket-io-average-response-time-reporter'
MeshbluWebsocketAverageResponseTimeReporter = require './reporters/meshblu-websocket-average-response-time-reporter'
MeshbluMqttAverageResponseTimeReporter = require './reporters/meshblu-mqtt-average-response-time-reporter'
MeshbluXmppAverageResponseTimeReporter = require './reporters/meshblu-xmpp-average-response-time-reporter'
MeshbluAmqpAverageResponseTimeReporter = require './reporters/meshblu-amqp-average-response-time-reporter'
MeshbluCoapAverageResponseTimeReporter = require './reporters/meshblu-coap-average-response-time-reporter'
MeshbluCoreJobCountReporter = require './reporters/meshblu-core-job-count-reporter'
NanoctyeEngineCapacityReporter = require './reporters/nanocyte-engine-capacity-reporter'

class ReporterRunner
  constructor: ({@elasticsearch_uri, @statuspage_api_key, @dry_run}) ->
    @meshbluCoreCapacityReporter = new MeshbluCoreCapacityReporter {@elasticsearch_uri, @statuspage_api_key, @dry_run}
    @meshbluCoreAverageResponseTimeReporter = new MeshbluCoreAverageResponseTimeReporter {@elasticsearch_uri, @statuspage_api_key, @dry_run}
    @meshbluHttpAverageResponseTimeReporter = new MeshbluHttpAverageResponseTimeReporter {@elasticsearch_uri, @statuspage_api_key, @dry_run}
    @meshbluSocketIOAverageResponseTimeReporter = new MeshbluSocketIOAverageResponseTimeReporter {@elasticsearch_uri, @statuspage_api_key, @dry_run}
    @meshbluWebsocketAverageResponseTimeReporter = new MeshbluWebsocketAverageResponseTimeReporter {@elasticsearch_uri, @statuspage_api_key, @dry_run}
    @meshbluMqttAverageResponseTimeReporter = new MeshbluMqttAverageResponseTimeReporter {@elasticsearch_uri, @statuspage_api_key, @dry_run}
    @meshbluXmppAverageResponseTimeReporter = new MeshbluXmppAverageResponseTimeReporter {@elasticsearch_uri, @statuspage_api_key, @dry_run}
    @meshbluAmqpAverageResponseTimeReporter = new MeshbluAmqpAverageResponseTimeReporter {@elasticsearch_uri, @statuspage_api_key, @dry_run}
    @meshbluCoapAverageResponseTimeReporter = new MeshbluCoapAverageResponseTimeReporter {@elasticsearch_uri, @statuspage_api_key, @dry_run}
    @meshbluCoreJobCountReporter = new MeshbluCoreJobCountReporter {@elasticsearch_uri, @statuspage_api_key, @dry_run}
    @nanocyteEngineCapacityReporter = new NanoctyeEngineCapacityReporter {@elasticsearch_uri, @statuspage_api_key, @dry_run}

  run: (callback) =>
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
    async.parallel tasks, callback

module.exports = ReporterRunner
