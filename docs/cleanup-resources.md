# 🧹 AWS Resources Cleanup Guide

After completing my project, I'll delete all AWS resources to prevent unwanted charges. Below are step-by-step instructions, ordered for safe and efficient removal.

---

## ⚠️ Important:
- Delete resources in **reverse order** of creation to avoid dependency issues.
- Confirm deletions carefully; deleted resources **cannot be recovered**.

---

## 🗃️ **1. RDS Database Cleanup**

### **Disable Deletion Protection**
- **AWS Console → RDS → Databases**
- Select the DB Cluster → click **Modify**.
- **Uncheck** "Enable deletion protection" → Click **Continue**.
- Select **Apply immediately** → Click **Modify cluster**.

### **Delete DB Instances**
- **RDS → Databases**
- Select **Writer instance** → **Actions → Delete**
  - Confirm deletion by typing `delete me`.
- Repeat for **Reader instance**.

### **Delete DB Cluster**
- Select the DB Cluster → **Actions → Delete**.
- **Uncheck** "Take final snapshot".
- Confirm "I acknowledge…" option.
- Type `delete me` → Click **Delete DB cluster**.

### **Delete RDS Snapshot**
- **RDS → Snapshots**
- Select `webapp-db-snapshot` → **Actions → Delete snapshot** → Confirm.

---

## 🔑 **2. AWS Secrets Manager Cleanup**

- Go to **AWS Console → Secrets Manager**.
- Select secret (`mysecret`) → **Actions → Delete secret**.
- Schedule deletion for **7 days** (minimum allowed) → Confirm.

---

## 💻 **3. EC2 Compute Cleanup**

### **Delete Auto Scaling Group (ASG)**
- **EC2 Console → Auto Scaling Groups**
- Select `Web-ASG` → **Actions → Delete**
- Type `delete` to confirm → Click **Delete**.

### **Delete Application Load Balancer (ALB)**
- **EC2 Console → Load Balancers**
- Select `Web-ALB` → **Actions → Delete**
- Type `confirm` to confirm → Click **Delete**.

### **Delete Target Group**
- **EC2 → Target Groups**
- Select `web-TG` → **Actions → Delete** → Confirm deletion.

### **Deregister EC2 AMI**
- **EC2 → AMIs**
- Select `Web Server v1` → **Actions → Deregister** → Confirm.

### **Delete Associated Snapshot**
- **EC2 → Snapshots**
- Select snapshot associated with your AMI → **Actions → Delete snapshot** → Confirm.

### **Delete EC2 Launch Template**
- **EC2 → Launch Templates**
- Select `Web` → **Actions → Delete template**
- Confirm by typing `Delete` → Click **Delete**.

### **Delete EC2 Instances (Optional)**
- **EC2 → Instances**
- Select the EC2 instance used for DB access → **Instance state → Terminate instance** → Confirm.

---

## 🌐 **4. Networking (VPC) Cleanup**

### **Delete VPC Endpoints**
- **AWS Console → VPC → Endpoints**
- Select **S3 endpoint** → **Actions → Delete**
- Type `delete` to confirm → Click **Delete**.

### **Delete NAT Gateway**
- **VPC Console → NAT Gateways**
- Select the NAT gateway → **Actions → Delete NAT gateway**
- Type `delete` → Confirm.

### **Release Elastic IP (EIP)**
- **VPC → Elastic IPs**
- Select the Elastic IP → **Actions → Release Elastic IP addresses** → Confirm.

> **Note:** Elastic IP isn't deleted automatically after NAT gateway deletion.

### **Delete Security Groups**
- Delete in the following order to prevent dependency issues:
  1. `Immersion Day - Web Server`
  2. `DB-SG`
  3. `ASG-Web-Inst-SG`
  4. `web-ALB-SG`

- **VPC → Security Groups**
- Select each security group → **Actions → Delete security groups**
- Type `delete` → Confirm each time.

---

### **Delete VPC**
- **VPC Console → Your VPCs**
- Select your VPC (`scalable-webapp-vpc`) → **Actions → Delete VPC**
- Type `delete` → Confirm.

---

## 🗑️ **5. Amazon S3 Cleanup**

- **AWS Console → S3**
- Select your bucket → **Empty** the bucket first, then **Delete** it to remove completely.

---

## ✅ **Final Checks**
- Double-check each AWS service used to ensure no resources remain.
- Monitor billing dashboard after cleanup to verify no further charges accrue.

---

