ips = {
   mode = tap,
   variables = default_variables,
   rules = [[
        include /etc/snort/rules/local.rules
   ]],
   rate_filter = {
    {
        name = 'icmp-limit',
        mode = 'both',
        track = 'by_src',
        count = 20,
        seconds = 5,
        sid = 10000002
    },
    {
        name = 'synflood-limit',
        mode = 'both',
        track = 'by_src',
        count = 30,
        seconds = 5,
        sid = 10000003
    },
    {
        name = 'ddos-limit',
        mode = 'both',
        track = 'by_dst',
        count = 100,
        seconds = 5,
        sid = 10000004
    },
    {
        name = 'ssh-brute-limit',
        mode = 'both',
        track = 'by_src',
        count = 10,
        seconds = 60,
        sid = 10000005
    },
    {
        name = 'smtp-brute-limit',
        mode = 'both',
        track = 'by_src',
        count = 10,
        seconds = 60,
        sid = 10000006
    },
    {
        name = 'imap-brute-limit',
        mode = 'both',
        track = 'by_src',
        count = 10,
        seconds = 60,
        sid = 10000007
    },
    {
        name = 'pop3-brute-limit',
        mode = 'both',
        track = 'by_src',
        count = 10,
        seconds = 60,
        sid = 10000008
    }
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
