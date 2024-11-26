#!/bin/bash

# Enable Debugging if 'debugging' flag is set
debugging=1
[ $debugging -eq 1 ] && set -x

# Log file
logfile="/home/ubuntu/day1/health_check.log"

# Function to log messages
log_message() {
    local msg="$1"
    echo "$(date +'%Y-%m-%d %H:%M:%S') : $msg" >> "$logfile"
}

# Function to check disk usage
check_disk_usage() {
    echo "Checking Disk Usage..."
    log_message "Disk Usage Check in progress"
    df -h || log_message "Error: Failed to check disk usage"
}

# Function to monitor running services
monitor_running_services() {
    echo "Monitoring Running Services..."
    log_message "Service Monitoring in progress"
    systemctl list-units --type=service --state=running || log_message "Error: Failed to monitor running services"
}

# Function to assess memory usage
assess_memory_usage() {
    echo "Assessing Memory Usage..."
    log_message "Memory Usage Assessment in progress"
    free -h || log_message "Error: Failed to assess memory usage"
}

# Function to evaluate CPU usage
evaluate_cpu_usage() {
    echo "Evaluating CPU Usage..."
    log_message "CPU Usage Evaluation in progress"
    top -b -n 1 | head -n 10 || log_message "Error: Failed to evaluate CPU usage"
}

# Function to send a comprehensive report
send_comprehensive_report() {
    rep="/home/ubuntu/day1/system_health_report.txt"
    echo "Here is your Comprehensive Report..."
    log_message "Comprehensive Report Generation in progress"
    
    {
        echo "System Health Report - $(date)"
        echo "========================================"
        echo ""
        echo "Disk Usage:"
        df -h
        echo ""
        echo "Running Services:"
        systemctl list-units --type=service --state=running
        echo ""
        echo "Memory Usage:"
        free -h
        echo ""
        echo "CPU Usage (Top 10 Processes):"
        top -b -n 1 | head -n 10
    } > "$rep"

    # Sending Email
    echo "Sending Report via Email..."
    email="snehsrivastava9@gmail.com"
    mail -s "System Health Check Report - $(date)" "email" < "$rep" || log_message "Error: Failed to send email report"
}

# Menu-driven interface
while true; do
    echo ""
    echo "========================================"
    echo "       System Health Check Menu         "
    echo "========================================"
    echo "1. Check Disk Usage"
    echo "2. Monitor Running Services"
    echo "3. Assess Memory Usage"
    echo "4. Evaluate CPU Usage"
    echo "5. Send Comprehensive Report"
    echo "6. Exit"
    echo "========================================"
    read -rp "Enter your choice: " CHOICE

    case $CHOICE in
        1)
            check_disk_usage
            ;;
        2)
            monitor_running_services
            ;;
        3)
            assess_memory_usage
            ;;
        4)
            evaluate_cpu_usage
            ;;
        5)
            send_comprehensive_report
            ;;
        6)
            echo "Exiting... Goodbye!"
            log_message "Script Exited by User"
            break
            ;;
        *)
            echo "Invalid choice, please try again."
            log_message "Invalid Menu Choice: $CHOICE"
            ;;
    esac
done
