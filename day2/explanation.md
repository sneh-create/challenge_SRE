
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

<img width="682" alt="Screenshot 2024-11-26 at 4 43 31 PM" src="https://github.com/user-attachments/assets/f75f64ca-f0fc-4a95-91ba-8f4f29308adf">

<img width="761" alt="Screenshot 2024-11-26 at 4 43 22 PM" src="https://github.com/user-attachments/assets/83b0cdd0-5d0d-41b1-9c84-4a815d1e929f">

<img width="564" alt="Screenshot 2024-11-26 at 4 43 38 PM" src="https://github.com/user-attachments/assets/47a8afc1-2bdd-4507-94f5-3d6accc31120">
