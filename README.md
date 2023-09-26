# Salesforce-Object-Dictionary
The Salesforce Object Dictionary Generator is a utility designed to simplify the process of documenting objects and fields in a Salesforce org. It addresses the common need to list all objects and their associated fields, which often arises during data migration tasks or system audits.

# Why This Project
In Salesforce, obtaining comprehensive information about all objects and their fields can be a labor-intensive task, typically requiring manual exploration. While there are some third-party solutions available on the AppExchange, we wanted to create a lightweight, open-source utility that could accomplish this without the need for additional installations.

# Features
Generates a basic Data Dictionary for Salesforce objects, providing the following details about each field:
   - Object Label
   - Object API Name
   - Field Label
   - Field API Name
   - Field Type (Standard or Custom)
   - UI Data Type
   - Help Text
   - Picklist Values (if applicable)
   - External ID Status
   - Uniqueness Constraint
   - Required Field
With the Data Dictionary generated, you can easily understand the structure of your Salesforce org, making it invaluable for data migration activities, system audits, and general system understanding.

# Requirements
Before using this utility, ensure you have the following:
   - A Salesforce org with MyDomain enabled.
   - Salesforce credentials with appropriate permissions to access the objects you want to document.

# Usage
    1. Launch the utility by opening the provided Lightning Web Component (LWC) in your Salesforce org.
    2. Select the Salesforce objects you want to include in your Data Dictionary.
    3. Click on the "Download Selected" button.
    4. The utility will process your selection and generate a CSV file containing the Data Dictionary.
    5. Download the CSV file on the fly for your reference.

# Contributing
We welcome contributions from the community. If you have suggestions for improvements or would like to report issues, please open an issue on this repository. For contributions, please follow our Contribution Guidelines.
    
