ips = {
   mode = tap,
   variables = default_variables,
   rules = [[
        include /etc/snort/rules/local.rules
   ]]
}

rate_filter = {
    {
        gid = 1,
        sid = 10000002,
        track = 'by_src',
        count = 20,
        seconds = 5,
        new_action = 'alert',
        timeout = 30
    },
    {
        gid = 1,
        sid = 10000003,
        track = 'by_src',
        count = 30,
        seconds = 5,
        new_action = 'alert',
        timeout = 30
    },
    {
        gid = 1,
        sid = 10000004,
        track = 'by_dst',
        count = 100,
        seconds = 5,
        new_action = 'alert',
        timeout = 30
    },
    {
        gid = 1,
        sid = 10000005,
        track = 'by_src',
        count = 10,
        seconds = 60,
        new_action = 'alert',
        timeout = 60
    },
    {
        gid = 1,
        sid = 10000006,
        track = 'by_src',
        count = 10,
        seconds = 60,
        new_action = 'alert',
        timeout = 60
    },
    {
        gid = 1,
        sid = 10000007,
        track = 'by_src',
        count = 10,
        seconds = 60,
        new_action = 'alert',
        timeout = 60
    },
    {
        gid = 1,
        sid = 10000008,
        track = 'by_src',
        count = 10,
        seconds = 60,
        new_action = 'alert',
        timeout = 60
    }
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
