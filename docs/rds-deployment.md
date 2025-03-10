# 🚀 Deploying Amazon RDS Aurora & Connecting to Auto Scaling Web Service  

Now that my **Auto Scaling Web Service** is running, I will deploy an **Amazon RDS Aurora instance** in `scalable-webapp-vpc` and configure the **web servers** in the Auto Scaling Group to connect to the database.

This setup ensures:
✅ **High availability** with Amazon RDS Aurora (Multi-AZ).  
✅ **Scalability** by allowing multiple web servers to connect to a single database.  
✅ **Separation of concerns** (database is managed separately from the web layer).  

---

## **1️⃣ Creating an Amazon RDS Aurora Database**
Amazon RDS Aurora is a **fully managed relational database service** that is optimized for high performance and availability. Since I am using a **MySQL-compatible Aurora instance**, I can easily integrate it with my web service.

### **Creating the RDS Instance**
1. Navigate to **AWS Console** → **RDS**.
2. Click **Create Database**.
3. Select **Standard Create**.
4. Choose **Engine Type** → Select **Amazon Aurora**.
5. Under **Edition**, choose **Aurora MySQL-Compatible Edition**.

📸 ![Create RDS Aurora](../screenshots/create-rds-aurora.png)

---

### **Configuring Database Settings**
1. **DB Cluster Identifier:** `scalable-webapp-db`
2. **Master Username:** `admin`
3. **Master Password:** Set a strong password.
4. **DB Instance Class:** `db.t3.medium` (adjust based on workload).
5. **Multi-AZ Deployment:** ✅ Enabled for high availability.
6. **Storage Type:** `General Purpose (SSD)`.

📸 ![RDS Configuration](../screenshots/rds-config.png)

✅ **Why?**
- **Aurora is highly available** (Multi-AZ).
- **Better performance than traditional RDS MySQL**.
- **Automatic scaling** to handle large workloads.

---

### **2️⃣ Configuring Networking for RDS**
Since my **web application in Auto Scaling Group** needs to connect to the database, I must ensure that:
- The **RDS instance is inside `scalable-webapp-vpc`**.
- The **web servers in Auto Scaling Group can communicate with the database**.

#### **VPC & Security Settings**
1. **VPC:** `scalable-webapp-vpc`
2. **Subnet Group:** Select the **public and private subnets**.
3. **Security Group:** Create a new security group for RDS.

📸 ![RDS Networking](../screenshots/rds-networking.png)

---

### **3️⃣ Setting Up Security Groups for Database Access**
I need to **allow EC2 instances** to connect to the RDS database while **blocking direct internet access**.

#### **Creating RDS Security Group**
1. **Go to EC2 Console** → **Security Groups**.
2. Click **Create Security Group**.
3. **Name:** `rds-db-sg`
4. **Inbound Rules:**
   - **Type:** MySQL/Aurora
   - **Port:** `3306`
   - **Source:** `ASG-Web-Inst-SG` (Web server security group)

📸 ![RDS Security Group](../screenshots/rds-sg.png)

✅ **Why?**
- **Only web servers in Auto Scaling Group can connect to the database**.
- **Blocks external access for security**.

---

## **4️⃣ Updating Web Service to Use RDS**
Now that **RDS is set up**, I need to **update my web service** to use the **database connection**.

### **Updating the Web Application Code**
I will modify the **database connection settings** in my web service’s **PHP configuration**.

#### **Editing `db-config.php`**
1. SSH into one of the **EC2 instances**.
2. Open the PHP configuration file:
   ```sh
   sudo nano /var/www/html/db-config.php

