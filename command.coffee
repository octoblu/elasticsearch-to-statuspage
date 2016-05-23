dashdash = require 'dashdash'
ElasticSearchtoStatusPage = require './src/elasticsearch-to-statuspage'

options = [
  {
    name: 'version'
    type: 'bool'
    help: 'Print tool version and exit.'
  }
  {
    names: ['help', 'h']
    type: 'bool'
    help: 'Print this help and exit.'
  }
  {
    names: ['elasticsearch-uri', 'e']
    type: 'string'
    env: 'ELASTICSEARCH_URI'
    help: 'ElasticSearch URI'
    helpArg: 'URI'
  }
  {
    names: ['statuspage-api-key', 'k']
    type: 'string'
    env: 'STATUSPAGE_API_KEY'
    help: 'StatusPage.io API key'
    helpArg: 'KEY'
  }
]

parser = dashdash.createParser(options: options)
try
  opts = parser.parse(process.argv)
catch e
  console.error 'elastic-search-to-statuspage: error: %s', e.message
  process.exit 1

if opts.help
  help = parser.help(includeEnv: true).trimRight()
  console.log 'usage: node command.js [OPTIONS]\n' + 'options:\n' + help
  process.exit 0

elasticSearchToStatusPage = new ElasticSearchtoStatusPage opts
elasticSearchToStatusPage.run (error) =>
  if error
    console.error error.stack
    process.exit 1
  process.exit 0
