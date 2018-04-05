var source = mongodb({
  "uri": "mongodb://mongodb:27017/flavour_db",
  // "timeout": "30s",
   "tail": true,
  // "ssl": false,
  // "cacerts": ["/path/to/cert.pem"],
  // "wc": 1,
  // "fsync": false,
  // "bulk": false,
  // "collection_filters": "{}",
  // "read_preference": "Primary"
})

var sink = elasticsearch({
  "uri": "http://elastic-search:9200/flavour"
  // "timeout": "10s", // defaults to 30s
  // "aws_access_key": "ABCDEF", // used for signing requests to AWS Elasticsearch service
  // "aws_access_secret": "ABCDEF" // used for signing requests to AWS Elasticsearch service
  // "parent_id": "elastic_parent" // defaults to "elastic_parent" parent identifier for Elasticsearch
})

t.Source("source", source, "/^comments$/").
// Transform(goja({"filename":"./preserve.id.js"})).
Save("sink", sink, "/.*/")
//t.Source({name:"source-respond-mongo"}).save({name:"dest-respond-es"})
