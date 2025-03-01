<h1 align="center">📂 Data 📦</h1>

## Overview  

The `data/` directory serves as the core data management layer of the application. It is responsible for retrieving, storing, and processing data from various sources, as well as handling data models used within the system.  

- **Local**: Connects to local storage and manages data via SQLite.  
- **Remote**: Connects to external APIs and handles data retrieval via HTTP requests.  
- **Repositories**: Acts as an intermediary between data sources (Local & Remote) and the business logic layer.  

---

## **File Structure**  

```plaintext
data/
├── datasources/
│   ├── local/
│   ├── remote/
│   │   ├── factories/
│   │   │   ├── 3ase_api.dart       # Base class for API requests
│   │   │   ├── dummy.dart          # API for generating dummy data
│   │   ├── game_factory.dart       # Factory for selecting game APIs
├── models/
├── repositories/
```

---

## **Folder Details**  

### **1. datasources/local/**  
- **Purpose**: Manages data storage in local storage (SQLite).  

---

### **2. datasources/remote/**  
- **Purpose**: Handles data retrieval from external APIs (Remote API).  
- **Key Subfolders**:  
  - **factories/**  
    - `game_factory.dart`: A factory class for selecting the appropriate API for different games.  
    - `3ase_api.dart`: A base class containing common API functionalities, such as sending HTTP requests and response validation.  
    - `dummy.dart`: An API used to generate dummy data for testing purposes.  

---

### **3. models/**  
- **Purpose**: Stores data models used for processing within the system.  

---

### **4. repositories/**  
- **Purpose**: Acts as a bridge between data sources (Local & Remote) and the business logic layer.  

---
