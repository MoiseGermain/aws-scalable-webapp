# 🚀 Security Group Rules for EC2 Web Server  

## **🔹 Security Group Name: scalable-webapp-security-group**  
This security group is assigned to the EC2 instance hosting the web application. It controls **inbound** and **outbound** traffic, following the principle of **least privilege**.

---

## **✅ Inbound Rules**  
| **Rule Name** | **Type** | **Protocol** | **Port Range** | **Source** | **Description** |
|--------------|---------|-------------|---------------|------------|--------------|
| Allow HTTP Traffic | HTTP | TCP | 80 | My IP | Allows web traffic from my machine only |
| Allow SSH Access (Optional) | SSH | TCP | 22 | My IP | Allows SSH access from my machine for management |

📌 *Port 22 (SSH) should only be allowed if I need to access the instance manually. It’s best to use EC2 Instance Connect instead for security.*  

---

## **✅ Outbound Rules**  
By default, AWS security groups allow all **outbound traffic**. If outbound rules are restricted, I will ensure that **HTTP (80) and HTTPS (443)** traffic is allowed for updates and external API requests.

| **Rule Name** | **Type** | **Protocol** | **Port Range** | **Destination** | **Description** |
|--------------|---------|-------------|---------------|------------|--------------|
| Allow Web Traffic | HTTP | TCP | 80 | 0.0.0.0/0 | Allows outbound web traffic |
| Allow Secure Web Traffic | HTTPS | TCP | 443 | 0.0.0.0/0 | Allows outbound secure web traffic |

---

## **🔹 Additional Security Considerations**
- ❌ **Avoid using `0.0.0.0/0` for SSH access.** Instead, restrict to **My IP**.
- 🔐 **For production environments**, consider using a **bastion host** or **Session Manager** instead of opening SSH.
- ✅ **For a public-facing web application**, change the HTTP rule source from **My IP** to `0.0.0.0/0` so that anyone can access the website.

---

## **📌 Next Steps**
🔹 I will update this file when adding **RDS Security Groups** in the next phase.  
🔹 If I add an **Application Load Balancer (ALB)**, I will create a **separate security group** for it.

---

