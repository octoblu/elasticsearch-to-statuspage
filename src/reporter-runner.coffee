async = require 'async'
MeshbluCoreCapacityReporter = require './reporters/meshblu-core-capacity-reporter'
MeshbluCoreAverageResponseTimeReporter = require './reporters/meshblu-core-average-response-time-reporter'
NanoctyeEngineCapacityReporter = require './reporters/nanocyte-engine-capacity-reporter'

class ReporterRunner
  constructor: ({@elasticsearch_uri, @statuspage_api_key, @dry_run}) ->
    @meshbluCoreCapacityReporter = new MeshbluCoreCapacityReporter {@elasticsearch_uri, @statuspage_api_key, @dry_run}
    @meshbluCoreAverageResponseTimeReporter = new MeshbluCoreAverageResponseTimeReporter {@elasticsearch_uri, @statuspage_api_key, @dry_run}
    @nanocyteEngineCapacityReporter = new NanoctyeEngineCapacityReporter {@elasticsearch_uri, @statuspage_api_key, @dry_run}

  run: (callback) =>
    tasks = [
      async.apply @meshbluCoreCapacityReporter.run
      async.apply @meshbluCoreAverageResponseTimeReporter.run
      async.apply @nanocyteEngineCapacityReporter.run
    ]
    async.parallel tasks, callback

module.exports = ReporterRunner
