<h1 align="center">📂 Core 🛠️</h1>

## Overview  

The `core/` directory serves as the backbone of the application, managing essential configurations, services, navigation, themes, and utilities. It provides a structured foundation to ensure the application's maintainability and scalability.  

---

## **File Structure**  

```plaintext
core/
├── constants/
│   ├── api_config.dart          # API configuration settings
│   ├── images.dart              # Image file references
├── locales/
│   ├── localizations.dart       # Text translation management
├── routes/
│   ├── routes.dart              # Application navigation routes
├── services/
│   ├── locator.dart             # Dependency injection handler
├── storages/
│   ├── database.dart            # SQLite database management
│   ├── shared_preferences.dart  # Temporary data storage
│   ├── sqlite.dart              # SQLite operations
├── themes/
│   ├── app_theme.dart           # Main UI theme of the application
├── utils/
│   ├── nfc_helper.dart          # NFC utility functions
│   ├── nfc_session_handler.dart # NFC session management
```

---

## **Folder Details**  

### **1. constants/**  
- **Purpose**: Manages constants and default settings.  
- **Key Files**:  
  - `api_config.dart`: API configuration settings.  
  - `images.dart`: References for image files.  

---

### **2. locales/**  
- **Purpose**: Supports multilingual text translations in the application.  
- **Key Files**:  
  - `localizations.dart`: Loads and translates text based on the user's language settings.  

---

### **3. routes/**  
- **Purpose**: Defines application navigation routes.  
- **Key Files**:  
  - `routes.dart`: Contains all route definitions.  

---

### **4. services/**  
- **Purpose**: Manages application services and dependencies.  
- **Key Files**:  
  - `locator.dart`: Handles dependency injection using GetIt to decouple object dependencies.  

---

### **5. storages/**  
- **Purpose**: Manages database operations and data storage.  
- **Key Files**:  
  - `database.dart`: Handles SQLite database connection and creation.  
  - `shared_preferences.dart`: Provides temporary data storage services.  
  - `sqlite.dart`: Manages SQLite-related operations.  

---

### **6. themes/**  
- **Purpose**: Manages the UI theme of the application.  
- **Key Files**:  
  - `app_theme.dart`: The main theme configuration of the application.  

---

### **7. utils/**  
- **Purpose**: Stores utility functions for specific tasks.  
- **Key Files**:  
  - `nfc_helper.dart`: Manages NFC operations.  
  - `nfc_session_handler.dart`: Handles NFC lifecycle according to app state changes.  

---
