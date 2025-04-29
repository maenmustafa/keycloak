Keycloak Username Lowercase Fix for SAP Business One Fiori Cockpit / Invalid username or password


Overview
This repository addresses a common issue encountered when integrating SAP Business One for HANA (specifically FP2502 and FP2502 HF1 versions) with Keycloak authentication services.

By default, Keycloak automatically converts usernames to lowercase, leading to connection problems, especially in environments where usernames are case-sensitive — such as in SAP Fiori Cockpit.

To provide a safe, tested, and production-ready solution, the affected Keycloak JAR files were rebuilt and recompiled to prevent automatic lowercasing, ensuring seamless authentication.

Solution
The provided fix involves replacing the relevant Keycloak JAR files with updated versions that retain the original username casing.

How to Apply the Fix
⚠️ Important: Always back up your existing JAR files before replacing them.

1. Extract the Provided Files
First, extract the provided tar archive:




tar -xvf keycloak_tolowercase.tar.gz

2. Backup Existing JAR Files
Navigate to your Keycloak JAR directory:


cd /usr/sap/SAPBusinessOne/Common/keycloak/lib/lib/main

Backup the existing JAR files:




cp org.keycloak.keycloak-crypto-default-24.0.4.jar org.keycloak.keycloak-crypto-default-24.0.4.jar.bak

cp org.keycloak.keycloak-model-jpa-24.0.4.jar org.keycloak.keycloak-model-jpa-24.0.4.jar.bak

cp org.keycloak.keycloak-model-storage-24.0.4.jar org.keycloak.keycloak-model-storage-24.0.4.jar.bak

cp org.keycloak.keycloak-model-storage-private-24.0.4.jar org.keycloak.keycloak-model-storage-private-24.0.4.jar.bak

cp org.keycloak.keycloak-server-spi-24.0.4.jar org.keycloak.keycloak-server-spi-24.0.4.jar.bak

cp org.keycloak.keycloak-server-spi-private-24.0.4.jar org.keycloak.keycloak-server-spi-private-24.0.4.jar.bak

cp org.keycloak.keycloak-services-24.0.4.jar org.keycloak.keycloak-services-24.0.4.jar.bak


3. Copy the New JAR Files
   
Return to the folder containing the extracted, compiled JAR files:




cp org.keycloak* /usr/sap/SAPBusinessOne/Common/keycloak/lib/lib/main

4. Set Permissions
   
Back in the Keycloak main directory:


cd /usr/sap/SAPBusinessOne/Common/keycloak/lib/lib/main

Apply correct permissions:

chmod 775 org.keycloak.keycloak-crypto-default-24.0.4.jar

chmod 775 org.keycloak.keycloak-model-jpa-24.0.4.jar

chmod 775 org.keycloak.keycloak-model-storage-24.0.4.jar

chmod 775 org.keycloak.keycloak-model-storage-private-24.0.4.jar

chmod 775 org.keycloak.keycloak-server-spi-24.0.4.jar

chmod 775 org.keycloak.keycloak-server-spi-private-24.0.4.jar

chmod 775 org.keycloak.keycloak-services-24.0.4.jar


Update ownership to b1service0:

chown b1service0:b1service0 org.keycloak.keycloak-crypto-default-24.0.4.jar

chown b1service0:b1service0 org.keycloak.keycloak-model-jpa-24.0.4.jar

chown b1service0:b1service0 org.keycloak.keycloak-model-storage-24.0.4.jar

chown b1service0:b1service0 org.keycloak.keycloak-model-storage-private-24.0.4.jar

chown b1service0:b1service0 org.keycloak.keycloak-server-spi-24.0.4.jar

chown b1service0:b1service0 org.keycloak.keycloak-server-spi-private-24.0.4.jar

chown b1service0:b1service0 org.keycloak.keycloak-services-24.0.4.jar

5. Clean Up Authentication Users
   
Login to the Authentication Service and delete all users except b1siteuser.

This ensures no corrupted or lowercased user entries remain.

6. Restart Authentication Service
Finally, restart the SAP B1 Authentication Service:




service sapb1servertools-authentication restart


Once you have completed the above steps:

Login to SAP Business One normally.

The Fiori Cockpit and related authentication issues will be resolved.

Important Notes
This fix is specifically compiled for Keycloak 24.0.4.

Tested and verified with SAP Business One FP2502 and FP2502 HF1.

Always perform changes in a test environment first before applying to production.

License
This fix is distributed as-is, without warranties. Use it at your own risk for improving SAP Business One integrations.

