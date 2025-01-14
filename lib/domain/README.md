<h1 align="center">📂 Domain 🌐</h1>

## ภาพรวม

โฟลเดอร์ `domain` เป็นเลเยอร์ที่ทำหน้าที่เชื่อมต่อระหว่าง **UI** และ **Data** โดยเน้นการจัดการตรรกะธุรกิจ (Business Logic) และการทำงานของแอปพลิเคชันในเชิงนามธรรม (Abstract Layer) ทำให้แอปพลิเคชันสามารถขยายตัวได้อย่างมีประสิทธิภาพ

---

## โครงสร้าง “domain”

### **1. entities/**
- **วัตถุประสงค์**: เก็บโครงสร้างข้อมูลเชิงนามธรรมที่ไม่ผูกกับโครงสร้างของฐานข้อมูลหรือ API

### **2. mappers/**
- **วัตถุประสงค์**: ใช้สำหรับแปลงข้อมูลระหว่าง `entities` และ `models` ในเลเยอร์ 

### **3. usecases/**
- **วัตถุประสงค์**: เก็บฟังก์ชันที่เป็นแกนหลักของตรรกะธุรกิจ เช่น การสร้างเด็คใหม่ 

---
