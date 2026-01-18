# Forestry Management System (KTPMUD)

[🇻🇳 Xem phiên bản tiếng Việt](README.vi.md)

## Project Overview
The Forestry Management System is a specialized Windows desktop application designed for the comprehensive management of forestry resources. It provides a centralized platform to track seedling nurseries, wood processing plants, and wildlife conservation centers. The system is built on the .NET Framework using a custom Model-View-Controller (MVC) architecture and features interactive mapping capabilities.

## Key Features
- **Facility Management**: Centralized tracking for seedling sources, timber processing units, and wildlife sanctuaries.
- **Administrative Hierarchy**: A robust 4-level management system for geographical data (Province, District, Commune, and Village/Hamlet).
- **Interactive Mapping**: Integration with Microsoft Edge WebView2 to render interactive geospatial data and facility locations.
- **System Auditing**: Automated logging of user activities and system modifications to ensure data integrity and accountability.

## Technical Specifications
- **Programming Language**: C#
- **Platform**: .NET Framework 4.7.2 (WPF)
- **Architecture**: Custom MVC Pattern
- **Database**: Microsoft SQL Server
- **Key Libraries**:
    - **Newtonsoft.Json**: Used for data serialization and system configuration.
    - **Microsoft.Web.WebView2**: Used for embedding web-based map components.
    - **Vst.Controls**: A custom UI library for consistent interface components.

## Role-Based Access Control (RBAC)
The system implements a structured permission model defined in the system's action metadata to ensure secure data access.

| Role | Access Level | Primary Responsibilities |
| :--- | :--- | :--- |
| **Developer** | Full System | Database migrations, core configuration, and system-level debugging. |
| **Admin** | Management | User account administration, group permissions, and administrative unit setup. |
| **Staff** | Operational | Management of seedlings, wood processing, and wildlife records. |

## Database Initialization
The application relies on a SQL Server backend. Follow these steps to set up the data layer:

1. **Create Database**: Create a new database instance named `KTPM`.
2. **Schema Deployment**: Execute the `SQL/Tables.sql` script to generate the necessary tables and initial seed data.
3. **Business Logic**: Execute the `SQL/Procs.sql` script to install the Stored Procedures required for system operations.

## System Architecture
The project follows a modular structure to separate concerns:
- **Controllers**: Located in the `/Controllers` directory, these handle the business logic and bridge the gap between the UI and Database.
- **Views**: Located in the `/Views` directory, these manage the WPF interface and the HTML/JS templates for mapping.
- **Models**: Defines the data structures used throughout the application.
- **Data Provider**: A centralized execution engine for running Stored Procedures safely and efficiently.

## Installation and Setup
1. **Requirements**:
    - Visual Studio 2019 or later.
    - Microsoft SQL Server 2016+.
    - Microsoft Edge WebView2 Runtime.
2. **Clone the Repository**:
   ```bash
   git clone [https://github.com/lca1605/KTPMUD_forest_manage.git](https://github.com/lca1605/KTPMUD_forest_manage.git)
