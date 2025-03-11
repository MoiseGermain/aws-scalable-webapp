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

📸 ![Launch EC2 in Public Subnet](../screenshots/launch-ec2-public.png)

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

📸 ![Update RDS Security Group](../screenshots/update-rds-sg.png)

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
