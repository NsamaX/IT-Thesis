<h1 align="center">📂 Domain 🌐</h1>

## Overview  

The `domain/` directory serves as the middle layer between **UI** and **Data**, focusing on **Business Logic** and core functionalities independent of presentation or data sources. This separation enhances maintainability and scalability.  

---

## **File Structure**  

```plaintext
domain/
├── entities/
├── mappers/
├── usecases/
```

---

## **Folder Details**  

### **1. entities/**  
- **Purpose**:  
  Stores abstract data structures that are not directly tied to a database or API.  

---

### **2. mappers/**  
- **Purpose**:  
  Contains functions for converting data between Data Models and Entities.  

---

### **3. usecases/**  
- **Purpose**:  
  Stores core Business Logic processes, integrating data from multiple sources.  

---
