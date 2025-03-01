<h1 align="center">📂 Presentation 🖥️</h1> 

## Overview  

The `presentation/` directory represents the **UI Layer**, responsible for rendering the user interface and handling user interactions. It primarily displays data from the **Domain Layer** and sends user commands back to the **Business Logic** through Cubits or BLoC.  

---

## **File Structure**  

```plaintext
presentation/
├── cubits/
├── pages/
├── widgets/
```

---

## **Folder Details**  

### **1. cubits/**  
- **Purpose**:  
  Manages the UI state using Cubit (or BLoC) to control state changes within the application.  

---

### **2. pages/**  
- **Purpose**:  
  Contains the main screen components of the application. Each screen retrieves data from Cubit or BLoC to display content and manage user interactions.  

---

### **3. widgets/**  
- **Purpose**:  
  Stores reusable UI components that can be used across multiple screens.  

---
