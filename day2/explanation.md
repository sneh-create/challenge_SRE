
![py1](https://github.com/user-attachments/assets/a164e68f-7aaf-4478-b727-c73cfddf9ec5)


# Explanation

# 1. Bucket Summary
The print_summary function loops through each bucket and prints its name, region, size in GB, and whether versioning is enabled.

# 2. Identifying Large Unused Buckets
The function identify_large_unused_buckets filters buckets based on:

Size > 80 GB
Unused for more than 90 days (calculated using the days_since_creation helper function).

# 3. Cost Report
The function generate_cost_report:

Groups bucket storage costs by region and team.
Calculates the total cost for each group.
Adds buckets with:
Size > 100 GB and inactive for 20+ days to a deletion queue.
Size > 50 GB to a list of Glacier archival candidates.

# 4. Final Recommendations
The generate_final_recommendations function:

Lists buckets recommended for deletion (from the deletion queue).
Lists buckets recommended for archival to Glacier storage.

PS: I have not created the modular form of coding because all the sections were required to be executed. You are welcome to suggest
improvised version of code.

# Output:

Bucket Summary:
==================================================
Name: prod-data, Region: us-west-2, Size: 120 GB, Versioning: True
Name: dev-app-logs, Region: us-east-1, Size: 10 GB, Versioning: False
Name: backup, Region: eu-central-1, Size: 80 GB, Versioning: True
Name: audit-logs, Region: ap-southeast-1, Size: 50 GB, Versioning: True
Name: test-results, Region: us-west-1, Size: 15 GB, Versioning: False
Name: old-backups, Region: us-east-2, Size: 200 GB, Versioning: True
Name: staging-resources, Region: eu-west-1, Size: 30 GB, Versioning: False
Name: app-analytics, Region: ap-northeast-1, Size: 250 GB, Versioning: True
Name: raw-data, Region: us-west-2, Size: 90 GB, Versioning: False
Name: compliance-data, Region: ca-central-1, Size: 300 GB, Versioning: True
==================================================

Large Buckets Unused for 90+ Days:
Name: prod-data, Size: 120 GB, Created On: 2023-10-12
Name: old-backups, Size: 200 GB, Created On: 2020-08-15
Name: app-analytics, Size: 250 GB, Created On: 2021-03-18
Name: raw-data, Size: 90 GB, Created On: 2023-06-20
Name: compliance-data, Size: 300 GB, Created On: 2022-01-01

Cost Report by Region and Department:
Region: us-west-2
  Department: analytics, Total Cost: $2.76
  Department: data-engineering, Total Cost: $2.07
Region: us-east-1
  Department: engineering, Total Cost: $0.23
Region: eu-central-1
  Department: ops, Total Cost: $1.84
Region: ap-southeast-1
  Department: security, Total Cost: $1.15
Region: us-west-1
  Department: qa, Total Cost: $0.34
Region: us-east-2
  Department: ops, Total Cost: $4.60
Region: eu-west-1
  Department: development, Total Cost: $0.69
Region: ap-northeast-1
  Department: analytics, Total Cost: $5.75
Region: ca-central-1
  Department: compliance, Total Cost: $6.90

Buckets Recommended for Deletion:
==================================================
Name: prod-data, Size: 120 GB, Last Accessed: 2023-10-12
Name: old-backups, Size: 200 GB, Last Accessed: 2020-08-15
Name: app-analytics, Size: 250 GB, Last Accessed: 2021-03-18
Name: compliance-data, Size: 300 GB, Last Accessed: 2022-01-01

Buckets Recommended for Glacier Archival:
==================================================
Name: backup, Size: 80 GB, Last Accessed: 2022-11-30
Name: raw-data, Size: 90 GB, Last Accessed: 2023-06-20
