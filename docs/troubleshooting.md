# 🛠 Troubleshooting Guide

This guide provides solutions to common issues encountered while deploying and testing the **AWS Scalable Web Application**.

---

## ❌ ALB Not Routing Traffic
### 🔍 Issue:
- The ALB DNS name returns a **504 Gateway Timeout** or no response.
- Page doesn't load when accessing **http://<ALB-DNS-Name>**.

### ✅ Fix:
1. **Check Target Group Health Status**
   - Go to **EC2 Console** → **Target Groups**.
   - Select **Web-TG** and check if instances are **Healthy**.
   - If instances are **Unhealthy**, follow these steps:
     - Ensure **EC2 security group allows HTTP traffic** from `web-ALB-SG`.
     - Restart the web server:
       ```sh
       sudo systemctl restart httpd
       ```

2. **Verify ALB Security Group**
   - Go to **EC2 Console** → **Security Groups**.
   - Find `web-ALB-SG` and check **Inbound Rules**.
   - Ensure HTTP (80) is allowed from `0.0.0.0/0` (Anywhere).

3. **Confirm Route Table Configuration**
   - Navigate to **VPC Console** → **Route Tables**.
   - Ensure that the **public subnet’s route table** has a route:
     - **Destination:** `0.0.0.0/0`
     - **Target:** `igw-xxxxxxxx` (Internet Gateway)

---

## ❌ No Public IP Assigned to EC2 Instances
### 🔍 Issue:
- EC2 instances in public subnets do not have a **Public IPv4 Address**.

### ✅ Fix:
1. **Enable Auto-assign Public IP in Subnet Settings**
   - Go to **VPC Console** → **Subnets**.
   - Select the **public subnet** (e.g., `scalable-webapp-subnet-public1-us-east-1a`).
   - Click **Modify Auto-assign IP Settings**.
   - Enable **Auto-assign Public IPv4 Address**.

2. **Manually Assign an Elastic IP** (If Auto-Assign is Disabled)
   - Go to **EC2 Console** → **Elastic IPs**.
   - Click **Allocate New Elastic IP**.
   - Select **VPC** and click **Allocate**.
   - Associate it with the **EC2 instance**.

---

## ❌ Auto Scaling Group Not Launching New Instances
### 🔍 Issue:
- Auto Scaling does not create new instances even when CPU usage exceeds 30%.

### ✅ Fix:
1. **Verify Scaling Policies**
   - Navigate to **EC2 Console** → **Auto Scaling Groups**.
   - Select **Web-ASG**.
   - Check that the **Target Tracking Policy** is enabled for **CPU Utilization > 30%**.

2. **Check IAM Role Permissions**
   - Go to **IAM Console** → **Roles**.
   - Select the **role attached to the Auto Scaling Group**.
   - Ensure it has the **AmazonEC2AutoScalingFullAccess** policy.

3. **Confirm Instance Termination Protection**
   - If **instances are not terminating**, check if **termination protection is enabled**.
   - Disable it if necessary by selecting the instances → **Actions** → **Change Termination Protection**.

---

## ❌ Web Page Not Loading on EC2 Instance
### 🔍 Issue:
- EC2 instance is running but the **web page does not load** when accessing `http://<Public-IPv4-Address>`.

### ✅ Fix:
1. **Ensure Web Server is Running**
   - SSH into the instance:
     ```sh
     ssh -i my-key.pem ec2-user@<Public-IPv4-Address>
     ```
   - Check web server status:
     ```sh
     sudo systemctl status httpd
     ```
   - If the service is inactive, restart it:
     ```sh
     sudo systemctl restart httpd
     ```

2. **Check Security Group Rules**
   - Go to **EC2 Console** → **Security Groups**.
   - Ensure HTTP (80) is allowed from `0.0.0.0/0` or `web-ALB-SG`.

---

## ❌ Database Connection Fails
### 🔍 Issue:
- The web application cannot connect to the **Amazon RDS database**.

### ✅ Fix:
1. **Check RDS Security Group**
   - Go to **EC2 Console** → **Security Groups**.
   - Find the **RDS security group**.
   - Ensure **Inbound Rules** allow:
     - **MySQL/Aurora (3306)** → **Source:** `ASG-Web-Inst-SG`

2. **Verify Database Endpoint & Credentials**
   - Go to **RDS Console** → **Databases**.
   - Copy the **Endpoint** and ensure the application uses the correct:
     ```env
     DB_HOST=<RDS-ENDPOINT>
     DB_USER=admin
     DB_PASSWORD=yourpassword
     ```

3. **Ensure EC2 Can Reach RDS**
   - SSH into the EC2 instance and run:
     ```sh
     telnet <RDS-ENDPOINT> 3306
     ```
   - If the connection fails, **update RDS security group rules**.

---

## **✅ Need More Help?**
- If issues persist, check AWS **CloudWatch Logs** for debugging.
- Ensure all **IAM roles and security policies** are correctly configured.

🚀 **For additional troubleshooting, refer to AWS Documentation:** [AWS Troubleshooting Guide](https://docs.aws.amazon.com/)

