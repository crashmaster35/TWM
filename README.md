# ToroWM Design

**ToroWM** is a lightweight window manager being designed for the **ToroKernel** and will run on **ToroOS**. The project is currently in the **design phase**, and no development has started yet. The goal is to provide a basic window management system with minimal system overhead, while maintaining compatibility with the ToroKernel's architecture.

## Initial Design Parameters

* **Language:** Pascal will be used for development, with object-oriented programming applied only when strictly necessary. This choice ensures simplicity in the codebase and efficient performance.

* **Graphics Mode**: The window manager will use **VESA (Video Electronics Standards Association)** for the graphical mode. VESA was selected for its simplicity and hardware compatibility, making it a robust solution for rendering graphical elements such as windows, buttons, and text.

* **Communication Protocol:** **IPC (Inter-Process Communication)** will serve as the communication protocol for **ToroWM**. This enables effective and secure communication between applications, the window manager, and other system components.

* **Event Handling:** **Hardware interrupts** will handle event processing, including user input like keyboard and mouse events. This method guarantees real-time responsiveness, avoiding delays introduced by polling mechanisms.

## Key Features (Planned)

1. **Window Management:** Basic operations like opening, moving, resizing, and closing windows.
1. **Graphics Rendering:** Drawing UI elements (windows, icons, text) via VESA.
1. **User Input Handling:** Handling of keyboard and mouse inputs through an interrupt-driven approach.
1. **Efficient Resource Use:** A focus on minimizing memory and CPU usage to preserve the lightweight nature of ToroOS.

## Current Status: Design Phase

As of now, **ToroWM** is still in the **design phase**. No development has begun, and the project team is working on finalizing the core architecture and technical specifications. Future updates will provide more details on development progress and implementation plans.

## Contributing

We welcome new contributors! If you are interested in helping shape the development of **ToroWM**, feel free to join us. We are particularly looking for contributors with experience in the following areas:

* Pascal programming (with or without object-oriented practices).
* Graphics programming using VESA or other low-level techniques.
* Event handling via hardware interrupts or similar mechanisms.
* Inter-process communication protocols and implementation.

Whether you are a seasoned developer or someone looking to learn, we value all contributions. Feel free to open issues or submit pull requests with your ideas. Let’s build something great together!
