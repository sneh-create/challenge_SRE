#!/bin/bash

#awk '{for(i=1;i<=NF;i++) if ($i ~ /^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$/) print $i}' user_activity.log | sort | uniq
#awk '{for(i=1;i<=NF;i++) if ($i ~ /user/) print $i}' user_activity.log | sort | uniq

#==== task 1
awk '{
    for(i=1; i<=NF; i++) {
        if ($i ~ /^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$/) {
            ips[$i]++
        }
    }
} 
END {
    for (ip in ips) {
        print ip
        count++
    }
    print "Total unique IP addresses:", count
}' user_activity.log | sort

#------ task2
awk '{
    for(i=1; i<=NF; i++) {
        if ($i ~ /user/) {
            us[$i]++
        }
    }
} 
END {
    for (u in us) {
        print u
        c1++
    }
    
    print "Total number of users:", c1
}' user_activity.log | sort -n 

#---- task3
awk '{cod[$NF]++} 
END {for (c2 in cod) 
        print c2, cod[c2]}' user_activity.log | sort -n

awk '$NF == 403 {print $4, $5}' user_activity.log | column -t

#---- task4
awk '
{
    
    for(i=1;i<=NF;i++) {if ($i ~ /user/) {c++}}
    total++
    if ($NF == 200) successful++
    if ($NF == 404 || $NF == 403) failed++
}
END {
    print "Total unique users: " c
    print "Total requests: " total
    print "Successful requests (200): " successful
    print "Failed requests (404 or 403): " failed
}' user_activity.log

