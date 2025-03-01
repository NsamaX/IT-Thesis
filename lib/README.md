<h1 align="center">📂 lib 🛠️</h1>

## Overview  

The `lib` folder serves as the core of the application, structured according to the **Clean Architecture** principles. This approach ensures a well-organized design, scalability, and maintainability. By systematically dividing the application into distinct layers, it helps separate concerns, reduce direct dependencies, and increase development flexibility.  

---

## **Structure & Responsibilities**  

### **Clean Architecture**  
The structure is divided into five main layers:  
1. **Presentation**: Manages UI and user interactions.  
2. **Domain**: Contains the core business logic.  
3. **Data**: Handles data sources, both Local and Remote.  
4. **Core**: Stores utilities, services, and shared constants.  
5. **Assets**: Contains static resources.  

---

## **File Structure**  

```plaintext
lib/
├── assets/                      # Static resources
├── core/                        # Utilities and shared resources
├── data/                        # Data management from Local/Remote sources
├── domain/                      # Business logic and abstract data structures
├── presentation/                # UI rendering and state management
```

---

## **Folder Details**  

### **1. assets/**  
- **Role**: Stores shared static resources used across all layers.  
- **See More**: [README for assets](../assets/README.md)  

---

### **2. core/**  
- **Role**: Contains utilities, services, and shared constants used across all layers.  
- **See More**: [README for core](./core/README.md)  

---

### **3. data/**  
- **Role**: Manages data from various sources, both Local and Remote, working with Repositories and Data Sources.  
- **Usage**:  
  - `datasources/`: Manages data from local storage or APIs.  
  - `repositories/`: Combines data from multiple sources and transforms it into a usable format.  
- **See More**: [README for data](./data/README.md)  

---

### **4. domain/**  
- **Role**: The core layer containing business logic and abstract data structures.  
- **Usage**:  
  - `entities/`: Stores abstract data structures independent of databases or APIs.  
  - `usecases/`: Contains business logic operations and processes.  
- **See More**: [README for domain](./domain/README.md)  

---

### **5. presentation/**  
- **Role**: Manages UI and user interactions, displaying data from `domain` and handling state through Cubits or BLoC.  
- **Usage**:  
  - `cubits/`: Manages UI state and logic.  
  - `pages/`: Contains the main screens of the application.  
  - `widgets/`: Stores reusable UI components.  
- **See More**: [README for presentation](./presentation/README.md)  

---
