async = require 'async'
MeshbluCoreCapacityReporter = require './reporters/meshblu-core-capacity-reporter'
NanoctyeEngineCapacityReporter = require './reporters/nanocyte-engine-capacity-reporter'

class ReporterRunner
  constructor: ({@elasticsearch_uri, @statuspage_api_key}) ->
    @meshbluCoreCapacityReporter = new MeshbluCoreCapacityReporter {@elasticsearch_uri, @statuspage_api_key}
    @nanocyteEngineCapacityReporter = new NanoctyeEngineCapacityReporter {@elasticsearch_uri, @statuspage_api_key}

  run: (callback) =>
    tasks = [
      async.apply @meshbluCoreCapacityReporter.run
      async.apply @nanocyteEngineCapacityReporter.run
    ]
    async.parallel tasks, callback

module.exports = ReporterRunner
