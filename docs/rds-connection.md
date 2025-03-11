# 🚀 Connecting to RDS Aurora via EC2

In this section, I will:  
✅ **Launch an EC2 instance in a Public Subnet** to access RDS Aurora.  
✅ **Update Security Groups** to allow EC2 to connect to RDS.  
✅ **Use MySQL CLI to verify the connection** and run database queries.  

---

## **1️⃣ Launching an EC2 Instance in a Public Subnet**
To connect to RDS from an EC2 instance, I need to **launch a new EC2 instance** inside the **Public Subnet** of my VPC.

### **Steps to Launch EC2**
1. **Go to AWS Console** → **EC2**.
2. Click **Launch Instance**.
3. **Choose AMI:** ✅ **Select the Custom AMI (`Web Server v1`)**.
4. **Choose Instance Type:** `t2.micro` (or any required size).
5. **Configure Network Settings:**
   - **VPC:** `scalable-webapp-vpc`
   - **Subnet:** **Public Subnet** (`scalable-webapp-subnet-public1-us-east-1a`)
   - ✅ **Enable Auto-assign Public IPv4**
6. **Select Key Pair:** ✅ Use existing key or create a new one.
7. **Click Launch**.

✅ **Now, my EC2 instance is ready to connect to RDS.**  

---

## **2️⃣ Updating RDS Security Group to Allow EC2 Access**
By default, RDS is **inside a private subnet**, and **cannot be accessed directly from the internet**. To allow connections from my new EC2 instance, I need to update the **RDS security group**.

### **Steps to Update RDS Security Group**
1. **Go to AWS Console** → **EC2** → **Security Groups**.
2. **Find the RDS Security Group (`DB-SG`)** and click on it.
3. **Edit Inbound Rules**:
   - **Type:** `MySQL/Aurora`
   - **Port:** `3306`
   - **Source:** **EC2 Security Group (`ASG-Web-Inst-SG`)**
4. Click **Save Rules**.

✅ **Now, my EC2 instance is allowed to connect to RDS.**  

---

## **3️⃣ Connecting to EC2 via SSH**
Now that my EC2 instance has access to RDS, I will **log into it using SSH**.

### **Steps to Connect**
1. **Find the EC2 Public IP:**
   - **Go to AWS Console** → **EC2** → **Instances**.
   - **Copy the Public IPv4 Address**.
2. **Connect via SSH using the private key**:
   ```sh
   ssh -i my-key.pem ec2-user@<EC2-PUBLIC-IP>
For example:
ssh -i AWS-Key.pem ec2-user@18.234.56.78

Last login: Mon Mar 11 14:41:59 2024 from 192.168.1.100

       __|  __|_  )
       _|  (     /   Amazon Linux 2 AMI
      ___|\___|___|

https://aws.amazon.com/amazon-linux-2/
✅ Now, I am inside the EC2 instance.

4️⃣ Connecting to RDS Aurora using MySQL CLI
Since the EC2 web server already has the MySQL client installed, I will connect to the RDS instance.

Steps to Connect to RDS
Run the following command:

sh
Copy
Edit
mysql -u awsuser -p -h <RDS-ENDPOINT>
Example:

sh
Copy
Edit
mysql -u awsuser -p -h scalable-webapp-db.cluster-xxxxxxxx.us-east-1.rds.amazonaws.com
Enter the RDS password when prompted (awspassword).

Expected Output:
pgsql
Copy
Edit
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 34
Server version: 5.7.34 MySQL Community Server (GPL)

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.
✅ Now, I am connected to the RDS database.

5️⃣ Running MySQL Commands to Verify Database Access
Once connected, I can execute MySQL commands to check the databases and tables.

Check Available Databases
sh
Copy
Edit
mysql> SHOW DATABASES;
Expected Output:
pgsql
Copy
Edit
+--------------------+
| Database          |
+--------------------+
| information_schema |
| webapp_db         |
| mysql             |
| performance_schema |
+--------------------+
4 rows in set (0.01 sec)
Switch to the Web Application Database
sh
Copy
Edit
mysql> USE webapp_db;
Expected Output:
nginx
Copy
Edit
Database changed
Show Tables
sh
Copy
Edit
mysql> SHOW TABLES;
Expected Output:
sql
Copy
Edit
+-----------------+
| Tables_in_webapp_db |
+-----------------+
| users           |
| orders          |
| products        |
+-----------------+
3 rows in set (0.01 sec)
Query the Database (Example)
I will check sample user records stored in the users table.

sh
Copy
Edit
mysql> SELECT * FROM users;
Expected Output:
sql
Copy
Edit
+----+-------+--------------+---------------------+
| id | name  | phone        | email               |
+----+-------+--------------+---------------------+
|  1 | Bob   | 630-555-1254 | bob@fakeaddress.com |
|  2 | Alice | 571-555-4875 | alice@address2.us   |
+----+-------+--------------+---------------------+
2 rows in set (0.00 sec)
✅ Now, my RDS connection is successfully verified! 🎉

Next Steps
➡️ **[Storage – Amazon S3](../docs/s3-deployment.md)**
➡️ **[Review Troubleshooting Guide](../docs/troubleshooting.md)**
