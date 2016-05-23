async = require 'async'
MeshbluCoreCapacityReporter = require './meshblu-core-capacity-reporter'

class ElasticSearchtoStatusPage
  constructor: ({@elasticsearch_uri, @statuspage_api_key}) ->
    @meshbluCoreCapacityReporter = new MeshbluCoreCapacityReporter {@elasticsearch_uri, @statuspage_api_key}

  run: (callback) =>
    tasks = [
      async.apply @meshbluCoreCapacityReporter.run
    ]
    async.parallel tasks, callback

module.exports = ElasticSearchtoStatusPage
