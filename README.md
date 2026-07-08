# 🐾 Rafiq - Smart Pet Care Platform

Rafiq is a comprehensive smart pet care platform designed to bridge the gap between pet owners, their pets, and veterinary services through advanced IoT integration and AI-powered insights.

## 🌟 Key Features

### 🔐 Authentication & Account Management
* **Secure Auth:** Seamless registration, login, and OTP-based password recovery.
* **Role-Based Onboarding:** Tailored journeys for Pet Owners and Veterinarians.
* **Personalized Setup:** Interactive onboarding to define user interests and preferences.
* **Comprehensive Profile Management:** Full control over personal data (Name, Email, Contact details), security settings, and account deletion.

### ⚙️ User Experience & Privacy
* **Localization & Theming:** Full support for English/Arabic (RTL) and dynamic Dark/Light modes.
* **Privacy Controls:** Advanced user settings to manage pet visibility and messaging permissions.

### 🏥 Clinics & Appointment Management
* **Clinic Directory:** Discovery of vet clinics with detailed profiles and ratings.
* **Booking System:** Easy appointment scheduling with specific visit reasons.
* **Appointment Lifecycle:** Full management of bookings (Pending, Confirmed, Completed, Cancelled).

### 🧠 Smart Collar & IoT Health Ecosystem
* **Real-time Connectivity:** Live monitoring of vitals (Heart Rate, Temp) and location tracking.
* **AI Diagnosis:** ML models analyzing vitals for proactive health status and alerts.
* **Device Management:** Intuitive interface to pair/unpair devices.

### 💬 Community & Chat
* **Dynamic Feed:** Personalized community feed for pet moments (Post & Comment interactions).
* **Real-time Chat:** Instant communication between users and vets powered by SignalR.

### 🛒 Pet Store & Admin Operations
* **Marketplace:** Browse and shop for pet essentials, accessories, and supplies.
* **Admin Inventory:** Capability to add and manage product listings.
* **Order Processing:** Efficient management of customer orders, including status updates from Pending to Completed.

---

## 📸 UI Showcase

### 🔐 Authentication & Onboarding
| Login | Registration | Role Selection | Interest Selection | Auth/OTP |
| :---: | :---: | :---: | :---: | :---: |
| <img src="snapshots/auth/auth-login.png" width="150"> | <img src="snapshots/auth/auth-signup-step1.png" width="150"> | <img src="snapshots/auth/auth-role-selection.png" width="150"> | <img src="snapshots/auth/auth-interests.png" width="150"> | <img src="snapshots/auth/auth-otp-verification.png" width="150"> |

### ⚙️ Settings
| Settings (Light/EN) | Settings (Dark/AR) | Privacy & Security |
| :---: | :---: | :---: |
| <img src="snapshots/profile_settings/settings-main-en-light.png" width="150"> | <img src="snapshots/profile_settings/settings-main-ar-dark.png" width="150"> | <img src="snapshots/profile_settings/settings-privacy-security.png" width="150"> |

### 👤 Profiles
| Doctor Profile | Owner Profile | Pet Profile |
| :---: | :---: | :---: |
| <img src="snapshots/profile_settings/profile-doctor.png" width="150"> | <img src="snapshots/profile_settings/profile-owner.png" width="150"> | <img src="snapshots/profile_settings/profile-pet-details.png" width="150"> |

### 🏠 Home Dashboard
| Dashboard (Connected) | Dashboard (Not Connected) | Dashboard (Dark) | Health Records |
| :---: | :---: | :---: | :---: |
| <img src="snapshots/home_collar/home-dashboard.png" width="150"> | <img src="snapshots/home_collar/no-collar.png" width="150"> | <img src="snapshots/home_collar/home-dashboard-dark.png" width="150"> | <img src="snapshots/home_collar/home-dashboard-records.png" width="150"> |

### 🐾 Smart Collar Ecosystem
| Collar Vitals | AI Diagnosis | Device Management | Link Collar |
| :---: | :---: | :---: | :---: |
| <img src="snapshots/home_collar/collar-vitals-map.png" width="150"> | <img src="snapshots/home_collar/collar-ai-diagnosis.png" width="150"> | <img src="snapshots/home_collar/collar-connected.png" width="150"> | <img src="snapshots/home_collar/collar-link-device.png" width="150"> |

### 🏥 Clinics & Appointment Booking
| Clinic Directory | Clinic Profile | Book Appointment | Manage Appointments |
| :---: | :---: | :---: | :---: |
| <img src="snapshots/clinics_appointments/clinic-directory.png" width="150"> | <img src="snapshots/clinics_appointments/clinic-profile.png" width="150"> | <img src="snapshots/clinics_appointments/appointment-book-clinic.png" width="150"> | <img src="snapshots/clinics_appointments/appointment-manage-confirmed.png" width="150"> |

### 💬 Community & Chat
| Community Feed | Add Post | Post Comments | Chat Interface |
| :---: | :---: | :---: | :---: |
| <img src="snapshots/community_chat/community-feed.png" width="150"> | <img src="snapshots/community_chat/community-add-post.png" width="150"> | <img src="snapshots/community_chat/community-post-comments.png" width="150"> | <img src="snapshots/community_chat/chat-conversation.png" width="150"> |

### 🛒 Pet Store & Management
| Store Browse | Shopping Cart | Admin: Order Management | Admin: Product Form |
| :---: | :---: | :---: | :---: |
| <img src="snapshots/store/store-products.png" width="150"> | <img src="snapshots/store/store-cart.png" width="150"> | <img src="snapshots/store/store-admin-orders.png" width="150"> | <img src="snapshots/store/store-admin-product-form.png" width="150"> |

---
## 🛠 Tech Stack

Rafiq is built with a robust, scalable architecture to handle real-time IoT data and complex state:

* **Core Framework:** Flutter
* **State Management:** BLoC / Cubit (for complex business logic) & Provider (for dependency injection & UI state)
* **Networking:** Dio (API communication)
* **Real-time Communication:** SignalR (for instant Chat messaging).
* **Maps & Location:** Flutter Map & Geocoding
* **UI/UX:** Flutter ScreenUtil (Responsiveness), Flutter SVG, Iconsax, Shimmer
* **Architecture:** Clean Architecture
* **Tools:** Figma (Design)

## 🚀 Future Roadmap
- [ ] **Push Notifications:** Instant, critical alerts for health anomalies or geofencing breaches.
- [ ] **AI Model Optimization:** Retraining with larger datasets for higher accuracy.
- [ ] **Long-term Analytics:** Advanced trend analysis charts for weekly/monthly pet health stats.

---
*Developed with passion for Pet Care Excellence.*
