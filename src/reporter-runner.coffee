async = require 'async'
MeshbluCoreCapacityReporter = require './reporters/meshblu-core-capacity-reporter'
MeshbluCoreAverageResponseTimeReporter = require './reporters/meshblu-core-average-response-time-reporter'
MeshbluHttpAverageResponseTimeReporter = require './reporters/meshblu-http-average-response-time-reporter'
MeshbluSocketIOAverageResponseTimeReporter = require './reporters/meshblu-socket-io-average-response-time-reporter'
NanoctyeEngineCapacityReporter = require './reporters/nanocyte-engine-capacity-reporter'

class ReporterRunner
  constructor: ({@elasticsearch_uri, @statuspage_api_key, @dry_run}) ->
    @meshbluCoreCapacityReporter = new MeshbluCoreCapacityReporter {@elasticsearch_uri, @statuspage_api_key, @dry_run}
    @meshbluCoreAverageResponseTimeReporter = new MeshbluCoreAverageResponseTimeReporter {@elasticsearch_uri, @statuspage_api_key, @dry_run}
    @meshbluHttpAverageResponseTimeReporter = new MeshbluHttpAverageResponseTimeReporter {@elasticsearch_uri, @statuspage_api_key, @dry_run}
    @meshbluSocketIOAverageResponseTimeReporter = new MeshbluSocketIOAverageResponseTimeReporter {@elasticsearch_uri, @statuspage_api_key, @dry_run}
    @nanocyteEngineCapacityReporter = new NanoctyeEngineCapacityReporter {@elasticsearch_uri, @statuspage_api_key, @dry_run}

  run: (callback) =>
    tasks = [
      async.apply @meshbluCoreCapacityReporter.run
      async.apply @meshbluCoreAverageResponseTimeReporter.run
      async.apply @meshbluHttpAverageResponseTimeReporter.run
      async.apply @meshbluSocketIOAverageResponseTimeReporter.run
      async.apply @nanocyteEngineCapacityReporter.run
    ]
    async.parallel tasks, callback

module.exports = ReporterRunner
