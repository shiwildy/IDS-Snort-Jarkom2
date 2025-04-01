ips = {
   mode = tap,
   detection = default_detection,
   variables = default_variables,
   rules = [[
        include /etc/snort/rules/local.rules
   ]]
}

alert_fast = {
   file = true,
   packet = false
}

alert_csv = {
   file = true,
   separator = ",",
   fields = "timestamp proto src_addr src_port dst_addr dst_port msg class sid" 
}

config = {
   detection = {
      flow_timeout = 30
   }
}
