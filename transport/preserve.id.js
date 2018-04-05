function transform(msg) {
  msg.data["mongo_id"] = msg.data._id['$oid'];
  //msg.data = _.omit(msg.data, ["_id"]);
  return msg;
}
