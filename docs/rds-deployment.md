# 🚀 Deploying Amazon RDS Aurora & Integrating with Auto Scaling Web Application

In this section, I will **deploy an RDS Aurora (MySQL) instance** within `scalable-webapp-vpc` and configure the **Auto Scaling web service** (Apache + PHP) to connect to it. After establishing the connection, I will **create a new Custom AMI** and update the **Auto Scaling Group** with the new AMI version.

---

## **1️⃣ Configuring Security Groups for RDS Access**
Amazon RDS **follows the same security model as EC2**. To maintain the **principle of least privilege**, I will create a **security group** that allows only the **Auto Scaling EC2 instances** to access the database.

### **Create RDS Security Group**
1. **Go to** AWS Console → **VPC** → **Security Groups**.
2. Click **Create Security Group**.
3. **Enter the following details:**

   | **Key**             | **Value**                      |
   |---------------------|--------------------------------|
   | Security Group Name | `DB-SG`                        |
   | Description        | `Database Security Group`      |
   | VPC               | `scalable-webapp-vpc`          |

4. **Inbound Rule:** Click **Add Rule** → Set **Type** to `MySQL/Aurora` (port `3306`).
5. **Source:** Select **EC2 Security Group (`ASG-Web-Inst-SG`)**.
6. Click **Create Security Group**.

📸 ![RDS Security Group](../screenshots/rds-security-group.png)

✅ **Why?**
- This ensures **only EC2 web instances** in the Auto Scaling Group can connect to the database.

---

## **2️⃣ Creating Amazon RDS Aurora Instance**

1. **Go to AWS Console** → **RDS**.
2. Click **Create Database**.
3. Select **Standard Create**.
4. **Database Engine:** `Amazon Aurora (MySQL Compatible)`.
5. **Version:** `Aurora MySQL 5.7`.

### **Database Settings**
| **Key**                | **Value**                     |
|------------------------|-----------------------------|
| DB Cluster Identifier | `rdscluster`                |
| Master Username       | `awsuser`                    |
| Master Password       | `awspassword`                |

📸 ![Database Settings](../screenshots/database-settings.png)

### **Instance Configuration**
1. **DB Instance Class:** `db.r5.large` (Memory Optimized).
2. **Availability & Durability:** `Create an Aurora Replica in another AZ` (for high availability).

### **Networking & Security**
| **Key**                  | **Value**                     |
|--------------------------|-----------------------------|
| VPC                      | `scalable-webapp-vpc`       |
| Subnet Group             | `Create new DB subnet group` |
| Publicly Accessible?     | `No`                         |
| Security Group           | `DB-SG`                      |
| Database Port            | `3306`                       |

📸 ![RDS Network Settings](../screenshots/rds-network-settings.png)

7. Click **Create Database**.
8. Wait until the **DB Status is `Available`**.

✅ **Why?**
- **Databases should be in private subnets** for security.
- **High availability ensures failover** in case of an outage.

---

## **3️⃣ Storing RDS Credentials in AWS Secrets Manager**
To **securely store database credentials**, I will use **AWS Secrets Manager** instead of hardcoding them in application code.

### **Creating a Secret for Database Credentials**
1. **Go to AWS Console** → **Secrets Manager**.
2. Click **Store a New Secret**.
3. **Select `Credentials for Amazon RDS database`**.
4. Enter the database credentials:

   | **Key**     | **Value**    |
   |------------|-------------|
   | Username   | `awsuser`   |
   | Password   | `awspassword` |

5. Select the **RDS instance (`rdscluster`)**.
6. Click **Next** → Set Secret Name: `mysecret`.
7. Click **Store**.

📸 ![Secrets Manager](../screenshots/secrets-manager.png)

✅ **Why?**
- **Prevents credentials from being exposed in the application code.**
- **Allows secure retrieval using AWS IAM permissions.**

---

## **4️⃣ Granting Web Server Access to Secrets Manager**
Since the web server needs access to database credentials, I will **attach a policy to its IAM role**.

### **Create an IAM Policy for Secrets Manager Access**
1. **Go to AWS Console** → **IAM** → **Policies**.
2. Click **Create Policy** → Choose **Secrets Manager**.
3. Under **Permissions**, select `Read` → `GetSecretValue`.
4. Click **Next** → **Name the Policy `ReadSecrets`** → **Create Policy**.

### **Attach the Policy to Web Server IAM Role**
1. **Go to AWS Console** → **IAM** → **Roles**.
2. Find `SSMInstanceProfile` (the IAM role for EC2 instances).
3. Click **Attach Policies** → Search `ReadSecrets` → Attach.

📸 ![IAM Policy](../screenshots/iam-policy.png)

✅ **Why?**
- Grants **minimum permissions** to retrieve credentials.
- **Prevents unauthorized access** to other secrets.

---

## **5️⃣ Connecting the Web App to RDS**
1. **Go to EC2 Console** → **Load Balancers**.
2. Copy the **ALB DNS Name**.
3. Open a **web browser** → Paste the ALB URL.
4. Click the **RDS Tab** on the web app.
5. The database should now be **readable from the web app!** 🎉

📸 ![Web App Connected](../screenshots/web-app-rds.png)

✅ **Why?**
- The web app is now dynamically retrieving data from RDS.

---

## **6️⃣ Creating a New AMI & Updating Auto Scaling Group**
Since the web server is now **connected to RDS**, I will create a **new AMI** and update Auto Scaling to use it.

### **Create a New AMI**
1. **Go to EC2 Console** → **Instances**.
2. Select the running web server instance.
3. Click **Actions** → **Create Image**.
4. Set **Image Name**: `Web Server RDS v1`.
5. Click **Create Image**.

📸 ![Create AMI](../screenshots/create-ami.png)

### **Update Auto Scaling Group**
1. **Go to EC2 Console** → **Launch Templates**.
2. Click **Web-ASG** → **Create New Version**.
3. Select **AMI: `Web Server RDS v1`**.
4. Click **Create Launch Template Version**.
5. **Update Auto Scaling Group** to use the new version.

📸 ![Update ASG](../screenshots/update-asg.png)

✅ **Why?**
- Ensures **new instances automatically use the latest configuration**.
- **No manual setup required for future scaling.**

---

## **✅ Summary**
By completing this setup, I have:
✅ Deployed an **Amazon RDS Aurora MySQL database**.  
✅ Configured **secure access** using Security Groups & IAM.  
✅ Connected the **web application to RDS** using AWS Secrets Manager.  
✅ Created a **new AMI** and updated **Auto Scaling** for seamless scaling.  

📸 ![Final Architecture](../screenshots/final-architecture.png)

---
