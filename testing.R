single_net <- bootnet::estimateNetwork(
  network_data,
  default = "mgm",
  tuning = 0.25,
  criterion = "EBIC",
  rule = "OR",
  type = rep("c", 14)
)